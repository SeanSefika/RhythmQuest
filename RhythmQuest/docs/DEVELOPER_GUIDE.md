# 👨‍💻 RhythmQuest Developer Guide

This guide explains the architecture and how to extend RhythmQuest with new features.

## 📁 Project Structure

```
RhythmQuest/
├── app.py                    # Main Flask application
├── forms.py                  # WTForms form definitions
├── requirements.txt          # Python dependencies
├── .env                      # Configuration (secrets)
├── .gitignore               # Git ignore rules
│
├── static/                  # Static files (don't change at runtime)
│   ├── css/
│   │   └── style.css       # All styling
│   └── js/
│       └── music.js        # Music game logic
│
├── templates/               # HTML templates
│   ├── layout.html         # Base template (all pages extend this)
│   ├── login.html          # Login page
│   ├── register.html       # Registration page
│   ├── music.html          # Music challenge
│   ├── quiz.html           # Quiz page
│   ├── dashboard.html      # Performance dashboard
│   ├── 404.html            # Not found error
│   ├── 500.html            # Server error
│   └── 403.html            # Access forbidden error
│
├── logs/                    # Application logs
│   └── app.log             # Log file (auto-created)
│
├── database_setup.sql       # Database schema
├── setup.bat               # Windows setup script
├── README.md               # User guide
├── TESTING.md              # Testing guide
├── DEPLOYMENT.md           # Deployment guide
└── DEVELOPER_GUIDE.md      # This file

```

---

## 🏗️ Application Architecture

### MVC Pattern (Model-View-Controller)

```
User Input (HTML Form)
    ↓
Controller (Flask Route in app.py)
    ↓
Model (Database via MySQL)
    ↓
View (HTML Template)
    ↓
Browser Display
```

### Data Flow Example: Registration

```
1. User fills registration form
2. Form submitted to /register (POST)
3. Flask checks form validation (forms.py)
4. If valid, hashes password (app.py)
5. Inserts into STUDENT table (MySQL)
6. Redirects to /login with success message
7. HTML template (login.html) displayed
```

---

## 🔄 Core Routes Explained

### Public Routes (No Login Required)
- `GET /` - Home page (redirects based on auth status)
- `GET /register` - Show registration form
- `POST /register` - Process registration
- `GET /login` - Show login form
- `POST /login` - Process login

### Protected Routes (Login Required)
- `GET /music` - Show music challenge
- `GET /quiz` - Show quiz page
- `POST /submit_quiz` - Submit quiz answer
- `GET /dashboard` - Show performance dashboard
- `GET /logout` - Log out user

### Error Routes
- `404` - Page not found
- `500` - Server error
- `403` - Access forbidden

---

## 💾 Database Schema

### STUDENT Table
```
ID (Primary Key)      → Auto-increment, unique identifier
Name (VARCHAR 255)    → Student's full name
Email (VARCHAR 255)   → Student's email, UNIQUE
Password (VARCHAR)    → Hashed password (never store plain text!)
CreatedAt (TIMESTAMP) → When account was created
```

### PERFORMANCE Table
```
ID (Primary Key)       → Auto-increment
Student_ID (Foreign Key) → Links to STUDENT table
Music_Score (INT)      → Score from music challenge (0-100)
Academic_Score (INT)   → Score from quiz (0-100)
Attempt_Number (INT)   → Which attempt this was
CreatedAt (TIMESTAMP)  → When record was created
```

---

## 🔐 Security Patterns

### Password Hashing
```python
from werkzeug.security import generate_password_hash, check_password_hash

# When user registers:
hashed = generate_password_hash(user_password)
# Store hashed in database

# When user logs in:
if check_password_hash(stored_hash, entered_password):
    # Correct password
```

### CSRF Protection
```python
from flask_wtf.csrf import CSRFProtect

# In app.py:
csrf = CSRFProtect(app)

# In HTML template:
{{ form.hidden_tag() }}  # Adds CSRF token
```

### Input Validation
```python
from wtforms.validators import Email, Length

# In forms.py:
email = StringField('Email', validators=[
    DataRequired(),
    Email()  # Validates email format
])
```

### Session Management
```python
# Store user info in session after login:
session['user_id'] = user[0]

# Check if user is logged in:
if 'user_id' not in session:
    return redirect('/login')

# Clear session on logout:
session.clear()
```

---

## ✨ How to Add New Features

### Example: Add a New Quiz Question

**Step 1: Add to Database**
Create a QUESTIONS table:
```sql
CREATE TABLE QUESTIONS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Question TEXT NOT NULL,
    CorrectAnswer VARCHAR(255) NOT NULL
);

INSERT INTO QUESTIONS (Question, CorrectAnswer) VALUES
('What is 1/4 + 1/4?', '1/2'),
('What is 5 * 6?', '30');
```

**Step 2: Update app.py**
```python
# In the quiz route, get a random question:
@app.route('/quiz')
def quiz():
    if 'user_id' not in session:
        return redirect('/login')
    
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM QUESTIONS ORDER BY RAND() LIMIT 1")
    question = cursor.fetchone()
    cursor.close()
    
    session['question_id'] = question[0]
    session['correct_answer'] = question[2]
    
    return render_template('quiz.html', question=question[1])
```

**Step 3: Update quiz.html**
```html
<p class="mb-4">{{ question }}</p>
```

**Step 4: Update submit_quiz**
```python
correct_answer = session.get('correct_answer')
```

---

### Example: Add Leaderboard Feature

**Step 1: Create Route**
```python
@app.route('/leaderboard')
def leaderboard():
    """Show top 10 students by average score"""
    cursor = mysql.connection.cursor()
    cursor.execute("""
        SELECT 
            s.Name,
            COUNT(p.ID) as attempts,
            AVG(p.Music_Score) as avg_music,
            AVG(p.Academic_Score) as avg_academic
        FROM STUDENT s
        LEFT JOIN PERFORMANCE p ON s.ID = p.Student_ID
        GROUP BY s.ID
        ORDER BY (AVG(p.Music_Score) + AVG(p.Academic_Score))/2 DESC
        LIMIT 10
    """)
    
    data = cursor.fetchall()
    cursor.close()
    
    return render_template('leaderboard.html', data=data)
```

**Step 2: Create Template (leaderboard.html)**
```html
{% extends "layout.html" %}

{% block content %}
<h2>🏆 Top Performers</h2>

<table class="table">
    <thead>
        <tr>
            <th>Rank</th>
            <th>Name</th>
            <th>Attempts</th>
            <th>Avg Music Score</th>
            <th>Avg Academic Score</th>
        </tr>
    </thead>
    <tbody>
        {% for user in data %}
        <tr>
            <td>{{ loop.index }}</td>
            <td>{{ user[0] }}</td>
            <td>{{ user[1] }}</td>
            <td>{{ "%.1f"|format(user[2]) }}</td>
            <td>{{ "%.1f"|format(user[3]) }}</td>
        </tr>
        {% endfor %}
    </tbody>
</table>
{% endblock %}
```

**Step 3: Add Link in layout.html**
```html
<a href="/leaderboard" class="btn btn-sm btn-warning">🏆 Leaderboard</a>
```

---

## 🧪 Testing Your Changes

### Unit Test Example
```python
# test_app.py
import unittest
from app import app

class TestRegistration(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
    
    def test_registration_page_loads(self):
        response = self.app.get('/register')
        self.assertEqual(response.status_code, 200)
    
    def test_invalid_password_rejected(self):
        response = self.app.post('/register', data={
            'name': 'Test',
            'email': 'test@example.com',
            'password': 'weak'  # Too weak
        })
        self.assertIn(b'Password must be at least', response.data)

if __name__ == '__main__':
    unittest.main()
```

---

## 📝 Logging Best Practices

### Add Logs to Your Code
```python
import logging
logger = logging.getLogger(__name__)

# Log info
logger.info(f'User {user_id} completed quiz')

# Log errors
logger.error(f'Database error: {str(e)}')

# Log warnings
logger.warning(f'Failed login attempt: {email}')
```

### View Logs
```bash
# On development:
tail -f logs/app.log

# On production (AWS):
tail -f /var/log/rhythmquest/app.log
```

---

## 🚀 Performance Tips

### Database Optimization
```python
# ✅ Good: Use indexes
CREATE INDEX idx_email ON STUDENT(Email);

# ❌ Bad: Full table scan
cursor.execute("SELECT * FROM STUDENT WHERE Name LIKE '%John%'")

# ✅ Better: Use WHERE with indexed columns
cursor.execute("SELECT * FROM STUDENT WHERE Email = %s", (email,))
```

### Reduce Database Queries
```python
# ❌ Bad: Multiple queries
for user in users:
    cursor.execute("SELECT * FROM PERFORMANCE WHERE Student_ID = %s", (user[0],))

# ✅ Good: Single query with JOIN
cursor.execute("""
    SELECT s.*, p.* FROM STUDENT s
    LEFT JOIN PERFORMANCE p ON s.ID = p.Student_ID
""")
```

### Cache Results
```python
# Use session to cache data
session['user_name'] = user[1]  # Don't fetch again

# Or use Flask caching (advanced)
from flask_caching import Cache
cache = Cache(app, config={'CACHE_TYPE': 'simple'})

@app.route('/expensive')
@cache.cached(timeout=300)  # Cache for 5 minutes
def expensive_operation():
    return calculate_something()
```

---

## 🔧 Common Debugging Techniques

### Print Debug Info
```python
# Print to console (development only)
print(f"USER: {user_id}")
print(f"DATA: {user}")
```

### Use Logging (Production safe)
```python
logger.info(f"User data: {user}")
logger.debug(f"Query result: {result}")
```

### Flask Debug Mode
In `.env`:
```
FLASK_ENV=development
```

### Check Logs
```bash
tail logs/app.log
```

### Use Browser DevTools
- F12 → Network tab (see requests)
- F12 → Console tab (see errors)
- F12 → Application tab (see cookies/session)

---

## 📚 Resources

### Flask Documentation
- https://flask.palletsprojects.com/
- https://flask-sqlalchemy.palletsprojects.com/

### WTForms Documentation
- https://wtforms.readthedocs.io/

### MySQL Documentation
- https://dev.mysql.com/doc/

### Security Best Practices
- https://owasp.org/www-community/attacks/csrf
- https://cheatsheetseries.owasp.org/

---

## 🎓 Learning Path

To understand the codebase better, study these concepts in order:

1. **Python Basics** - Variables, functions, classes
2. **Flask Basics** - Routes, templates, request/response
3. **HTML/CSS** - Forms, styling
4. **JavaScript** - Event handling, DOM manipulation
5. **MySQL** - Queries, relationships, indexes
6. **Web Security** - CSRF, SQL injection, password hashing
7. **Deployment** - Environment setup, monitoring

---

## 🆘 Tips for Contributing

1. **Always test your changes**
   - Run through TESTING.md test cases
   - Check logs for errors
   - Test on clean database

2. **Follow code style**
   - Use meaningful variable names
   - Add comments for complex logic
   - Keep functions small and focused

3. **Document your changes**
   - Add docstrings to functions
   - Update README if needed
   - Log important actions

4. **Commit good code**
   - Never commit `.env` or secrets
   - Write clear commit messages
   - Test before committing

---

**Happy Coding! 🎵**
