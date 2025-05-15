from flask import Blueprint, render_template, request, redirect, url_for, flash, session
import psycopg2
from datetime import datetime, timedelta
from config import get_db_connection

librarian_bp = Blueprint('librarian', __name__, url_prefix='/librarian')

# lend a book
@librarian_bp.route('/lend', methods=['GET', 'POST'])
def lend_book():
    conn = get_db_connection()
    cur = conn.cursor()

    if request.method == 'POST':
        user_id = request.form['user_id']
        book_id = request.form['book_id']
        due_date = datetime.now() + timedelta(days=14)

        try:
            cur.execute('INSERT INTO issued_books (user_id, book_id, issue_date, due_date) VALUES (%s, %s, %s, %s)',
                        (user_id, book_id, datetime.now(), due_date))
            cur.execute('UPDATE books SET quantity = quantity - 1 WHERE id = %s', (book_id,))
            conn.commit()
            flash('Book issued successfully.')
        except Exception as e:
            flash('Error issuing book.')
            print(e)
        finally:
            cur.close()
            conn.close()
        return redirect(url_for('librarian.lend_book'))

    cur.execute('SELECT id, title FROM books WHERE quantity > 0')
    books = cur.fetchall()
    cur.execute('SELECT id, name FROM users')
    users = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('lend_book.html', books=books, users=users)

# return books and apply fine
@librarian_bp.route('/return', methods=['GET', 'POST'])
def return_book():
    conn = get_db_connection()
    cur = conn.cursor()

    if request.method == 'POST':
        issue_id = request.form['issue_id']
        cur.execute('SELECT due_date, book_id FROM issued_books WHERE id = %s', (issue_id,))
        record = cur.fetchone()

        if record:
            due_date, book_id = record
            return_date = datetime.now()
            fine = max(0, (return_date - due_date).days) * 10  # Rs.10 per day fine

            cur.execute('DELETE FROM issued_books WHERE id = %s', (issue_id,))
            cur.execute('UPDATE books SET quantity = quantity + 1 WHERE id = %s', (book_id,))
            conn.commit()
            flash(f'Book returned. Fine: Rs.{fine}')
        cur.close()
        conn.close()
        return redirect(url_for('librarian.return_book'))


#view issued books
@librarian_bp.route('/issued')
def view_issued_books():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('''
        SELECT u.name, b.title, ib.issue_date, ib.due_date
        FROM issued_books ib
        JOIN users u ON ib.user_id = u.id
        JOIN books b ON ib.book_id = b.id
    ''')
    records = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('issued_books.html', records=records)
