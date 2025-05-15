from flask import Flask, render_template, session, flash
import os
import sys


# Add the project directory to Python path
project_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(project_dir)

try:
    from routes.user import user_bp
    from routes.books import book_bp
    from routes.librarian import librarian_bp
    from routes.admin import admin_bp
    from routes.borrow import borrow_bp
    from check_schema import check_schema
    from firebase_config import sync_data
except ImportError as e:
    print(f"Error importing modules: {e}")
    sys.exit(1)

app = Flask(__name__)
app.secret_key = 'your_secret_key'

app.register_blueprint(user_bp, url_prefix='/user')
app.register_blueprint(book_bp, url_prefix='/book') 
app.register_blueprint(librarian_bp, url_prefix='/librarian')
app.register_blueprint(admin_bp, url_prefix='/admin')
app.register_blueprint(borrow_bp, url_prefix='/borrow')

@app.route('/')
def home():
    return render_template('home_page.html')

if __name__ == '__main__':
    try:
        # Initialize database schema
        check_schema()
        # sync_data()
        # Run the application
        app.run(debug=True, host='127.0.0.1', port=5000)
    except Exception as e:
        print(f"Error starting application: {e}")
        sys.exit(1)

