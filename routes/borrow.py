from flask import Blueprint, render_template, request, redirect, url_for, session, flash
import psycopg2
from datetime import date
from datetime import timedelta
from config import get_db_connection

borrow_bp = Blueprint('borrow', __name__, url_prefix='/borrow')

#check available books
@borrow_bp.route('/available')
def available_books():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM books WHERE quantity > 0')
    books = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('available_books.html', books=books)


# borrow a book
@borrow_bp.route('/book/<int:book_id>', methods=['POST'])
def borrow_book(book_id):
    if 'user_id' not in session:
        flash('Please log in to borrow books.')
        return redirect(url_for('user.login'))

    user_id = session['user_id']
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # Check if user has any overdue books
        cur.execute("""
            SELECT COUNT(*) FROM issued_books 
            WHERE user_id = %s AND returned = FALSE AND (CURRENT_DATE - issue_date) > 7
        """, (user_id,))
        overdue_count = cur.fetchone()[0]

        if overdue_count > 0:
            flash('You have overdue books. Please return them before borrowing new ones.')
            return redirect(url_for('book.view_books'))

        # Check if book is available
        cur.execute('SELECT quantity FROM books WHERE id = %s', (book_id,))
        quantity = cur.fetchone()[0]

        if quantity <= 0:
            flash('This book is not available for borrowing.')
            return redirect(url_for('book.view_books'))

        # Calculate due date (7 days from now)
        issue_date = date.today()
        due_date = issue_date + timedelta(days=7)

        # Insert borrow record
        cur.execute('INSERT INTO issued_books (user_id, book_id, issue_date, due_date) VALUES (%s, %s, %s, %s)', 
                   (user_id, book_id, issue_date, due_date))

        # Update book quantity
        cur.execute('UPDATE books SET quantity = quantity - 1 WHERE id = %s', (book_id,))
        
        conn.commit()
        flash('Book borrowed successfully.')

    except Exception as e:
        conn.rollback()
        flash('Error occurred while borrowing the book.')
        print(e)

    finally:
        cur.close()
        conn.close()

    return redirect(url_for('book.view_books'))


# check borrowed books
@borrow_bp.route('/mybooks')
def my_books():
    if 'user_id' not in session:
        flash('Please log in.')
        return redirect(url_for('user.login'))

    user_id = session['user_id']
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT b.id, bk.title, ib.issue_date, ib.return_date, ib.returned
        FROM issued_books ib
        JOIN books bk ON ib.book_id = bk.id
        JOIN users b ON ib.user_id = b.id
        WHERE b.id = %s
    """, (user_id,))
    borrowed = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('my_books.html', borrowed=borrowed)


# return a book
@borrow_bp.route('/return/<int:book_id>', methods=['POST'])
def return_book(book_id):
    if 'user_id' not in session:
        flash('Please log in to return books.')
        return redirect(url_for('user.login'))

    user_id = session['user_id']
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # Get the borrow record
        cur.execute("""
            SELECT id, issue_date FROM issued_books
            WHERE user_id = %s AND book_id = %s AND returned = FALSE
        """, (user_id, book_id))
        borrow_record = cur.fetchone()

        if not borrow_record:
            flash('No active borrow record found for this book.')
            return redirect(url_for('borrow.borrow_history'))

        borrow_id, issue_date = borrow_record
        days_borrowed = (date.today() - issue_date).days

        # Calculate fine if overdue (7 days limit)
        fine = max(0, (days_borrowed - 7) * 50)  # Rs. 50 per day after 7 days

        # Update the borrow record
        cur.execute("""
            UPDATE issued_books
            SET returned = TRUE, 
                return_date = CURRENT_DATE,
                fine = %s
            WHERE id = %s
        """, (fine, borrow_id))

        # Update book quantity
        cur.execute('UPDATE books SET quantity = quantity + 1 WHERE id = %s', (book_id,))
        
        conn.commit()

        if fine > 0:
            flash(f'Book returned successfully. Fine for late return: Rs. {fine}')
        else:
            flash('Book returned successfully.')

    except Exception as e:
        conn.rollback()
        print(f"Error returning book: {e}")
        flash('Error occurred while returning the book.')

    finally:
        cur.close()
        conn.close()

    return redirect(url_for('borrow.borrow_history'))


# fines 
@borrow_bp.route('/fines')
def my_fines():
    if 'user_id' not in session:
        flash('Please log in.')
        return redirect(url_for('user.login'))

    user_id = session['user_id']
    conn = get_db_connection()
    cur = conn.cursor()
    try:
        cur.execute("""
            SELECT b.title, ib.issue_date, ib.return_date, ib.fine
            FROM issued_books ib
            JOIN books b ON ib.book_id = b.id
            WHERE ib.user_id = %s AND ib.fine > 0
        """, (user_id,))
        fines = cur.fetchall()
    except Exception as e:
        print(f"Error fetching fines: {e}")
        flash('Error loading fines information')
        fines = []
    finally:
        cur.close()
        conn.close()
    
    return render_template('my_fines.html', fines=fines)

@borrow_bp.route('/history')
def borrow_history():
    if 'user_id' not in session:
        return redirect(url_for('user.login'))

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute("""
            SELECT b.title, ib.issue_date, ib.due_date, ib.return_date, ib.fine, b.id
            FROM issued_books ib
            JOIN books b ON ib.book_id = b.id
            WHERE ib.user_id = %s
            ORDER BY ib.issue_date DESC
        """, (session['user_id'],))
        
        history = cur.fetchall()
    except Exception as e:
        print(f"Error fetching history: {e}")
        flash('Error loading borrowing history')
        history = []
    finally:
        cur.close()
        conn.close()

    return render_template('borrow_history.html', 
        history=history,
        current_date=date.today()
    )
