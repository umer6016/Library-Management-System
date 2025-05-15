from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from werkzeug.security import generate_password_hash, check_password_hash
import psycopg2
from datetime import datetime
from config import get_db_connection

user_bp = Blueprint('user', __name__, url_prefix='/user')

@user_bp.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        password = generate_password_hash(request.form['password'])

        conn = get_db_connection()
        cur = conn.cursor()
        try:
            cur.execute('INSERT INTO users (name, email, password) VALUES (%s, %s, %s)', (name, email, password))
            conn.commit()
            flash('Registered successfully. Please log in.')
            return redirect(url_for('user.login'))
        except Exception as e:
            flash('Email already exists or error occurred.')
            print(e)
        finally:
            cur.close()
            conn.close()
    return render_template('register.html')

@user_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        
        conn = get_db_connection()
        cur = conn.cursor()
        
        cur.execute('SELECT id, password FROM users WHERE email = %s', (email,))
        user = cur.fetchone()
        
        if user and check_password_hash(user[1], password):
            session['user_id'] = user[0]
            flash('Logged in successfully.')
            return redirect(url_for('user.dashboard'))
        else:
            flash('Invalid email or password.')
        
        cur.close()
        conn.close()
    return render_template('login.html')

@user_bp.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('user.login'))
    
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Get stats
    cur.execute('SELECT COUNT(*) FROM books WHERE quantity > 0')
    available_books = cur.fetchone()[0]
    
    cur.execute('''
        SELECT COUNT(*) FROM issued_books 
        WHERE user_id = %s AND returned = FALSE
    ''', (session['user_id'],))
    borrowed_books = cur.fetchone()[0]
    
    cur.execute('''
        SELECT COUNT(*) FROM issued_books 
        WHERE user_id = %s AND returned = FALSE AND due_date < CURRENT_DATE
    ''', (session['user_id'],))
    overdue_books = cur.fetchone()[0]
    
    # Get recent books
    cur.execute('SELECT * FROM books ORDER BY id DESC LIMIT 5')
    recent_books = cur.fetchall()
    
    # Get user's borrowed books
    cur.execute('''
        SELECT b.title, ib.issue_date, ib.due_date, ib.returned, 
               (ib.due_date < CURRENT_DATE AND NOT ib.returned) as is_overdue
        FROM issued_books ib
        JOIN books b ON ib.book_id = b.id
        WHERE ib.user_id = %s
        ORDER BY ib.issue_date DESC
    ''', (session['user_id'],))
    borrowed_books_list = cur.fetchall()
    
    cur.close()
    conn.close()
    
    return render_template('dashboard.html',
        stats={
            'available_books': available_books,
            'borrowed_books': borrowed_books,
            'overdue_books': overdue_books
        },
        recent_books=recent_books,
        borrowed_books=borrowed_books_list,
        current_date=datetime.now().date()
    )

@user_bp.route('/logout')
def logout():
    session.pop('user_id', None)
    flash('Logged out successfully.')
    return redirect(url_for('user.login'))
