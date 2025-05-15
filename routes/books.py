# books.py
from flask import Blueprint, render_template, request, redirect, url_for, flash, session
import psycopg2
import json
from datetime import datetime
from config import get_db_connection

book_bp = Blueprint('book', __name__, url_prefix='/book')

def log_book_action(cur, book_id, action_type, action_details):
    """Helper function to log book actions"""
    user_id = session.get('user_id')  # Get the current user's ID from session
    try:
        cur.execute('''
            INSERT INTO book_logs (book_id, action_type, action_details, performed_by)
            VALUES (%s, %s, %s, %s)
        ''', (book_id, action_type, json.dumps(action_details), user_id))
    except Exception as e:
        print(f"Error logging action: {e}")

# Add Book
@book_bp.route('/add', methods=['GET', 'POST'])
def add_book():
    if request.method == 'POST':
        title = request.form['title']
        author = request.form['author']
        genre = request.form['genre']
        quantity = request.form['quantity']

        conn = get_db_connection()
        cur = conn.cursor()
        try:
            # Insert the book
            cur.execute('INSERT INTO books (title, author, genre, quantity) VALUES (%s, %s, %s, %s) RETURNING id', 
                       (title, author, genre, quantity))
            book_id = cur.fetchone()[0]
            
            # Log the action
            action_details = {
                'title': title,
                'author': author,
                'genre': genre,
                'quantity': quantity
            }
            log_book_action(cur, book_id, 'ADD', action_details)
            
            conn.commit()
            flash('Book added successfully!')
            return redirect(url_for('book.view_books'))
        except Exception as e:
            conn.rollback()
            flash('Error adding the book. Please check the details and try again.')
            print(e)
        finally:
            cur.close()
            conn.close()
    return render_template('add_book.html')

# View all books
@book_bp.route('/view')
def view_books():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM books')
    books = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('view_books.html', books=books)

# Remove a book
@book_bp.route('/remove/<int:book_id>', methods=['GET', 'POST'])
def remove_book(book_id):
    conn = get_db_connection()
    cur = conn.cursor()
    
    if request.method == 'POST':
        try:
            # Get book details before deletion for logging
            cur.execute('SELECT * FROM books WHERE id = %s', (book_id,))
            book = cur.fetchone()
            
            if not book:
                flash('Book not found.')
                return redirect(url_for('book.view_books'))
            
            # First check if the book has any issued copies
            cur.execute('''
                SELECT COUNT(*) FROM issued_books 
                WHERE book_id = %s AND returned = FALSE
            ''', (book_id,))
            active_issues = cur.fetchone()[0]
            
            if active_issues > 0:
                flash('Cannot remove book: There are currently issued copies of this book. Please wait for all copies to be returned.')
                return redirect(url_for('book.view_books'))
            
            # Log the deletion before actually deleting
            action_details = {
                'title': book[1],
                'author': book[2],
                'genre': book[3],
                'quantity': book[4]
            }
            log_book_action(cur, book_id, 'DELETE', action_details)
            
            # Delete related records from issued_books where returned = TRUE
            cur.execute('DELETE FROM issued_books WHERE book_id = %s AND returned = TRUE', (book_id,))
            
            # Finally delete the book
            cur.execute('DELETE FROM books WHERE id = %s', (book_id,))
            
            conn.commit()
            flash('Book removed successfully!')
            
        except Exception as e:
            conn.rollback()
            print(f"Error removing book: {e}")
            flash(f'Error removing book: {str(e)}')  # Show the actual error message
            
        finally:
            cur.close()
            conn.close()
            
        return redirect(url_for('book.view_books'))
    
    # If GET request, show confirmation page
    cur.execute('SELECT * FROM books WHERE id = %s', (book_id,))
    book = cur.fetchone()
    cur.close()
    conn.close()
    
    if book is None:
        flash('Book not found.')
        return redirect(url_for('book.view_books'))
    
    return render_template('remove_book.html', book=book)

# edit a book
@book_bp.route('/edit/<int:book_id>', methods=['GET', 'POST'])
def edit_book(book_id):
    conn = get_db_connection()
    cur = conn.cursor()

    if request.method == 'POST':
        validation_error = False
        try:
            # Get the old book details for logging
            cur.execute('SELECT * FROM books WHERE id = %s', (book_id,))
            old_book = cur.fetchone()
            
            # Get form data with defaults
            form_data = {
                'title': request.form.get('title', '').strip(),
                'author': request.form.get('author', '').strip(),
                'genre': request.form.get('genre', '').strip(),
                'quantity': request.form.get('quantity', '0')
            }
            
            # Validate data
            if not all(form_data.values()):
                missing = [k for k, v in form_data.items() if not v]
                flash(f'Missing required fields: {", ".join(missing)}')
                validation_error = True
                raise ValueError(f'Missing fields: {missing}')
            
            # Convert quantity to int
            try:
                quantity = int(form_data['quantity'])
                if quantity < 0:
                    flash('Quantity cannot be negative')
                    validation_error = True
                    raise ValueError('Negative quantity')
            except (ValueError, TypeError):
                flash('Invalid quantity value')
                validation_error = True
                raise ValueError('Invalid quantity')

            # Update book
            cur.execute('''
                UPDATE books
                SET title = %s, author = %s, genre = %s, quantity = %s
                WHERE id = %s
            ''', (
                form_data['title'],
                form_data['author'],
                form_data['genre'],
                quantity,
                book_id
            ))
            
            # Log the edit action with both old and new values
            if old_book:
                action_details = {
                    'old': {
                        'title': old_book[1],
                        'author': old_book[2],
                        'genre': old_book[3],
                        'quantity': old_book[4]
                    },
                    'new': form_data
                }
                log_book_action(cur, book_id, 'EDIT', action_details)
            
            conn.commit()
            flash('Book updated successfully!')
            
        except ValueError as e:
            conn.rollback()
            print(f"Validation error: {e}")
            validation_error = True
        except Exception as e:
            conn.rollback()
            print(f"Database error: {e}")
            flash('Error updating book in database')
        finally:
            cur.close()
            conn.close()
            
        if not validation_error:
            return redirect(url_for('book.view_books'))

    # GET request or validation error
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT * FROM books WHERE id = %s', (book_id,))
        book = cur.fetchone()
        
        if book is None:
            flash('Book not found')
            return redirect(url_for('book.view_books'))
            
        return render_template('edit_book.html', book=book)
        
    except Exception as e:
        print(f"Error fetching book: {e}")
        flash('Error loading book details')
        return redirect(url_for('book.view_books'))
    finally:
        cur.close()
        conn.close()

# View book logs
@book_bp.route('/logs')
def view_logs():
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        cur.execute('''
            SELECT bl.id, b.title, bl.action_type, bl.action_details, 
                   u.name as performed_by, bl.performed_at
            FROM book_logs bl
            LEFT JOIN books b ON bl.book_id = b.id
            LEFT JOIN users u ON bl.performed_by = u.id
            ORDER BY bl.performed_at DESC
        ''')
        logs = cur.fetchall()
        return render_template('book_logs.html', logs=logs)
    except Exception as e:
        print(f"Error fetching logs: {e}")
        flash('Error loading book logs')
        return redirect(url_for('book.view_books'))
    finally:
        cur.close()
        conn.close()


