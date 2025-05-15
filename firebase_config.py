import psycopg2
import firebase_admin
from firebase_admin import credentials, db
import os
from configparser import ConfigParser
import json
from datetime import datetime

def config(filename='database.ini', section='postgresql'):
    # create a parser
    parser = ConfigParser()
    # read config file
    parser.read(filename)

    # get section, default to postgresql
    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception(f'Section {section} not found in the {filename} file')

    return db

# Initialize Firebase Admin SDK with service account credentials
cred = credentials.Certificate('credentials.json')  # Look for credentials.json in the current directory
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://dbms-theory-proejct-default-rtdb.asia-southeast1.firebasedatabase.app/'
})

# Function to sync data from SQL database to Firebase Realtime Database
def sync_data():
    try:
        # Create a new connection for this sync operation
        params = config()
        db_connection = psycopg2.connect(**params)
        cursor = db_connection.cursor()

        # Get timestamp for this backup
        backup_timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
        root_ref = db.reference(f'backups/{backup_timestamp}')

        # Sync books
        cursor.execute("SELECT * FROM books")
        books = cursor.fetchall()
        books_data = {
            str(book[0]): {
                'title': book[1],
                'author': book[2],
                'genre': book[3],
                'quantity': book[4]
            } for book in books
        }
        root_ref.child('books').set(books_data)

        # Sync users
        cursor.execute("SELECT * FROM users")
        users = cursor.fetchall()
        users_data = {
            str(user[0]): {
                'name': user[1],
                'email': user[2],
                'password': user[3],
                'created_at': str(user[4])
            } for user in users
        }
        root_ref.child('users').set(users_data)

        # Sync librarians
        cursor.execute("SELECT * FROM librarians")
        librarians = cursor.fetchall()
        librarians_data = {
            str(lib[0]): {
                'name': lib[1],
                'email': lib[2],
                'salary': float(lib[3]) if lib[3] else 0
            } for lib in librarians
        }
        root_ref.child('librarians').set(librarians_data)

        # Sync issued books
        cursor.execute("SELECT * FROM issued_books")
        issued_books = cursor.fetchall()
        issued_books_data = {
            str(issue[0]): {
                'user_id': issue[1],
                'book_id': issue[2],
                'issue_date': str(issue[3]),
                'return_date': str(issue[4]) if issue[4] else None,
                'fine': float(issue[5]) if issue[5] else 0
            } for issue in issued_books
        }
        root_ref.child('issued_books').set(issued_books_data)

        # Add backup metadata
        root_ref.child('metadata').set({
            'timestamp': str(datetime.now()),
            'books_count': len(books),
            'users_count': len(users),
            'librarians_count': len(librarians),
            'issued_books_count': len(issued_books)
        })

        cursor.close()
        db_connection.close()

        return {
            'success': True,
            'timestamp': backup_timestamp,
            'counts': {
                'books': len(books),
                'users': len(users),
                'librarians': len(librarians),
                'issued_books': len(issued_books)
            }
        }

    except Exception as error:
        print("Error syncing data:", error)
        return {
            'success': False,
            'error': str(error)
        }

# Function to listen for real-time updates from Firebase Realtime Database
def listen_for_updates():
    firebase_ref = db.reference('books')
    firebase_ref.listen(lambda event: print(event.event_type, event.data))

if __name__ == "__main__":
    sync_data()
    listen_for_updates()

# # Call synchronization function
# sync_data()

# # Call function to listen for real-time updates
# listen_for_updates()
