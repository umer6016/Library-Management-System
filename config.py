from configparser import ConfigParser
import os

def config(filename='database.ini', section='postgresql'):
    # Create a parser
    parser = ConfigParser()
    
    # Get the absolute path to the config file
    current_dir = os.path.dirname(os.path.abspath(__file__))
    db_config_path = os.path.join(current_dir, filename)
    
    # Read config file
    parser.read(db_config_path)

    # Get section
    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception(f'Section {section} not found in the {filename} file')

    return db

def get_db_connection():
    """Get database connection using config parameters"""
    import psycopg2
    try:
        params = config()
        return psycopg2.connect(**params)
    except Exception as e:
        print(f"Error connecting to database: {e}")
        raise e 