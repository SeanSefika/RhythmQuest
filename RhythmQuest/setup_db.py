#!/usr/bin/env python
"""Database setup script for RhythmQuest"""

import MySQLdb
import re

try:
    # Read the SQL file with UTF-8 encoding
    with open('database/database_setup.sql', 'r', encoding='utf-8') as f:
        sql_content = f.read()
    
    # Remove comments
    sql_content = re.sub(r'--.*$', '', sql_content, flags=re.MULTILINE)
    
    # Split by semicolon to get individual statements
    statements = [stmt.strip() for stmt in sql_content.split(';') if stmt.strip()]
    
    conn = MySQLdb.connect(host='localhost', user='root', passwd='root')
    cursor = conn.cursor()
    
    print("Setting up database...")
    success_count = 0
    
    for statement in statements:
        try:
            cursor.execute(statement)
            success_count += 1
            
            # Show progress
            if 'CREATE DATABASE' in statement.upper():
                print('✓ Created database')
            elif 'CREATE TABLE' in statement.upper():
                match = re.search(r'CREATE TABLE\s+(\w+)', statement, re.IGNORECASE)
                if match:
                    table_name = match.group(1)
                    print(f'✓ Created table: {table_name}')
        except Exception as e:
            error_msg = str(e)
            if 'already exists' not in error_msg and 'Duplicate' not in error_msg:
                print(f'⚠ {error_msg[:100]}')
    
    conn.commit()
    
    # Verify tables were created
    cursor.execute('USE rhythmquest')
    cursor.execute('SHOW TABLES')
    tables = [t[0] for t in cursor.fetchall()]
    
    # Count data
    cursor.execute('SELECT COUNT(*) FROM QUESTIONS')
    q_count = cursor.fetchone()[0]
    cursor.execute('SELECT COUNT(*) FROM ACHIEVEMENTS')
    a_count = cursor.fetchone()[0]
    
    print(f'\n✓ Database Setup Complete!')
    print(f'Tables: {", ".join(tables)}')
    print(f'Questions: {q_count}')
    print(f'Achievements: {a_count}')
    
    cursor.close()
    conn.close()
    
except Exception as e:
    import traceback
    print(f'✗ Error: {str(e)}')
    traceback.print_exc()
