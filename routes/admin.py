# routes/admin.py
from flask import Blueprint, render_template, request, redirect, url_for, flash, session
import psycopg2
from werkzeug.security import check_password_hash
from datetime import date, datetime
from datetime import timedelta
from config import get_db_connection
from firebase_config import sync_data
from functools import wraps

admin_bp = Blueprint('admin', __name__, url_prefix='/admin')

@admin_bp.route('/')
def dashboard():
    if 'admin_id' not in session:
        flash('Please login first.', 'danger')
        return redirect(url_for('admin.login'))
    return render_template('admin_dashboard.html')

@admin_bp.route('/login', methods=['GET', 'POST'])
def login():
    # If already logged in, redirect to dashboard
    if 'admin_id' in session:
        return redirect(url_for('admin.dashboard'))

    if request.method == 'GET':
        return render_template('admin_login.html')

    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')

        if not email or not password:
            flash('Please provide both email and password.', 'danger')
            return render_template('admin_login.html')

        conn = get_db_connection()
        cur = conn.cursor()
        
        try:
            cur.execute('SELECT id, name, password FROM admin WHERE email = %s', (email,))
            admin = cur.fetchone()

            if admin and admin[2] == password:  # Direct password comparison since it's stored directly
                session['admin_id'] = admin[0]
                session['admin_name'] = admin[1]
                flash('Login successful!', 'success')
                return redirect(url_for('admin.dashboard'))
            else:
                flash('Invalid email or password.', 'danger')
                return render_template('admin_login.html')
        except Exception as e:
            flash('An error occurred. Please try again.', 'danger')
            print(f"Login error: {e}")
            return render_template('admin_login.html')
        finally:
            cur.close()
            conn.close()

    return render_template('admin_login.html')

@admin_bp.route('/logout')
def logout():
    session.pop('admin_id', None)
    session.pop('admin_name', None)
    flash('Logged out successfully.', 'success')
    return redirect(url_for('home'))

# Add login_required decorator for admin routes
def admin_login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'admin_id' not in session:
            flash('Please login first.', 'danger')
            return redirect(url_for('admin.login'))
        return f(*args, **kwargs)
    return decorated_function

@admin_bp.route('/librarians')
@admin_login_required
def view_librarians():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM librarians")
    librarians = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('librarians.html', librarians=librarians)

# Rest of your routes with @admin_login_required decorator
@admin_bp.route('/add', methods=['GET', 'POST'])
@admin_login_required
def add_librarian():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        salary = request.form['salary']
        conn = get_db_connection()
        cur = conn.cursor()
        try:
            cur.execute("INSERT INTO librarians (name, email, salary) VALUES (%s, %s, %s)", (name, email, salary))
            conn.commit()
            flash("Librarian added successfully.")
            return redirect(url_for('admin.view_librarians'))
        except Exception as e:
            flash("Error: " + str(e))
        finally:
            cur.close()
            conn.close()
    return render_template('add_librarian.html')

@admin_bp.route('/update/<int:librarian_id>', methods=['GET', 'POST'])
@admin_login_required
def update_salary(librarian_id):
    conn = get_db_connection()
    cur = conn.cursor()
    if request.method == 'POST':
        new_salary = request.form['salary']
        cur.execute("UPDATE librarians SET salary = %s WHERE id = %s", (new_salary, librarian_id))
        conn.commit()
        flash("Salary updated.")
        cur.close()
        conn.close()
        return redirect(url_for('admin.view_librarians'))
    cur.execute("SELECT name, salary FROM librarians WHERE id = %s", (librarian_id,))
    librarian = cur.fetchone()
    cur.close()
    conn.close()
    return render_template('update_salary.html', librarian=librarian, librarian_id=librarian_id)

@admin_bp.route('/issued_books')
@admin_login_required
def issued_books():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT u.name, u.email, b.title, ib.issue_date, ib.due_date, ib.fine, ib.returned
        FROM issued_books ib
        JOIN users u ON ib.user_id = u.id
        JOIN books b ON ib.book_id = b.id
        ORDER BY ib.issue_date DESC
    """)
    data = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('admin_borrowed_books.html', data=data)

@admin_bp.route('/overdue_books')
@admin_login_required
def overdue_books():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT u.name, b.title, ib.issue_date, ib.due_date, ib.fine
        FROM issued_books ib
        JOIN users u ON ib.user_id = u.id
        JOIN books b ON ib.book_id = b.id
        WHERE ib.returned = FALSE AND ib.due_date < CURRENT_DATE
        ORDER BY ib.due_date ASC
    """)
    overdue = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('admin_overdue_books.html', overdue=overdue)

@admin_bp.route('/backup')
@admin_login_required
def manual_backup():
    return render_template('admin_backup.html')

@admin_bp.route('/perform_backup')
@admin_login_required
def perform_backup():
    try:
        result = sync_data()
        if result['success']:
            counts = result['counts']
            return {
                'success': True,
                'message': f"✅ Backup completed successfully!\n\nBacked up:\n- {counts['books']} books\n- {counts['users']} users\n- {counts['librarians']} librarians\n- {counts['issued_books']} issued books\n\nTimestamp: {result['timestamp']}"
            }
        else:
            return {
                'success': False,
                'message': f"❌ Backup failed: {result['error']}"
            }
    except Exception as e:
        return {
            'success': False,
            'message': f"❌ Backup failed: {str(e)}"
        }
