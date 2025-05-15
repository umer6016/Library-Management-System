import psycopg2
from config import get_db_connection

def check_schema():
    """Check if all required tables exist in the database"""
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        # Check users table
        cur.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id SERIAL PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                email VARCHAR(100) UNIQUE NOT NULL,
                password VARCHAR(255) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        
        # Check books table
        cur.execute("""
            CREATE TABLE IF NOT EXISTS books (
                id SERIAL PRIMARY KEY,
                title VARCHAR(255) NOT NULL,
                author VARCHAR(100) NOT NULL,
                genre VARCHAR(50),
                quantity INTEGER NOT NULL DEFAULT 1,
                added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        
        # Check issued_books table
        cur.execute("""
            CREATE TABLE IF NOT EXISTS issued_books (
                id SERIAL PRIMARY KEY,
                user_id INTEGER REFERENCES users(id),
                book_id INTEGER REFERENCES books(id),
                issue_date DATE NOT NULL DEFAULT CURRENT_DATE,
                due_date DATE NOT NULL,
                return_date DATE,
                fine DECIMAL(10,2) DEFAULT 0,
                returned BOOLEAN DEFAULT FALSE
            )
        """)
        
        # Check librarians table
        cur.execute("""
            CREATE TABLE IF NOT EXISTS librarians (
                id SERIAL PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                email VARCHAR(100) UNIQUE NOT NULL,
                salary DECIMAL(10,2) NOT NULL,
                joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        
        # Check book_logs table with ON DELETE SET NULL
        cur.execute("""
            CREATE TABLE IF NOT EXISTS book_logs (
                id SERIAL PRIMARY KEY,
                book_id INTEGER REFERENCES books(id) ON DELETE SET NULL,
                action_type VARCHAR(50) NOT NULL,
                action_details JSONB NOT NULL,
                performed_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
                performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        
        conn.commit()
        print("Schema check completed successfully")
        
    except Exception as e:
        print(f"Error checking schema: {e}")
        conn.rollback()
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    check_schema() 