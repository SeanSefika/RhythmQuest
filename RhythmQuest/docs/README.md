# 🎵 RhythmQuest - Music & Academic Challenge Platform

A Flask-based web application that combines music reaction challenges with academic quizzes to track student cognitive performance.

## 📋 Project Overview

RhythmQuest tests students' cognitive abilities through:
- **Music Challenge**: A reaction time game where users click as fast as possible
- **Academic Challenge**: Dynamic math questions loaded from database
- **Performance Dashboard**: Visualize your scores over time with interactive charts
- **User Profile**: View detailed performance statistics and personal information
- **Leaderboard**: Compete with other players and see top performers
- **Multi-Question Support**: 10+ questions in database, randomly selected for each challenge

## 📚 Documentation Files

- **README.md** (this file) - Project overview and setup guide
- **TESTING.md** - Comprehensive testing guide with detailed test cases
- **DEVELOPER_GUIDE.md** - Architecture and how to add new features
- **DEPLOYMENT.md** - Production deployment on Heroku, AWS, PythonAnywhere
- **database_setup.sql** - SQL script to set up the database
- **setup.bat** - Automated setup script for Windows
- **.env** - Configuration file (keep SECRET, never commit to git)
- **requirements.txt** - Python package dependencies

## 🚀 Quick Start Guide (For Beginners)

### Step 1: Install Python Dependencies

Open your **PowerShell/Terminal** in the RhythmQuest folder and run:

```bash
pip install -r requirements.txt
```

**What this does**: Downloads and installs all the packages listed in `requirements.txt`

### Step 2: Set Up Your Database

Make sure you have **MySQL** installed and running locally.

Create the database by running this SQL in MySQL:

```sql
CREATE DATABASE rhythmquest;

USE rhythmquest;

CREATE TABLE STUDENT (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE PERFORMANCE (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID INT NOT NULL,
    Music_Score INT NOT NULL,
    Academic_Score INT NOT NULL,
    Attempt_Number INT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Student_ID) REFERENCES STUDENT(ID)
);
```

### Step 3: Configure Your Settings

Open the `.env` file in your project and update these values:

```
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=root
MYSQL_DB=rhythmquest
FLASK_SECRET_KEY=your_super_secret_key_here_change_this_in_production
FLASK_ENV=development
```

**⚠️ Important**: 
- Change `FLASK_SECRET_KEY` to something unique (you can use any random string)
- Make sure your `MYSQL_USER` and `MYSQL_PASSWORD` match your MySQL setup
- **NEVER** commit `.env` to GitHub (it's in `.gitignore`)

### Step 4: Run the Application

```bash
python app.py
```

You should see:
```
 * Running on http://127.0.0.1:5000
```

Open your browser and go to: **http://localhost:5000**

## 📁 Project Structure

```
RhythmQuest/
├── app.py                 # Main application file
├── requirements.txt       # Python dependencies
├── .env                   # Configuration (KEEP SECRET!)
├── .gitignore            # Files to ignore in git
├── static/
│   ├── css/
│   │   └── style.css     # Styling
│   └── js/
│       └── music.js      # Game logic
└── templates/
    ├── layout.html       # Base template
    ├── login.html        # Login page
    ├── register.html     # Registration page
    ├── music.html        # Music challenge
    ├── quiz.html         # Academic quiz
    ├── dashboard.html    # Performance stats
    ├── 404.html         # Error page (not found)
    ├── 500.html         # Error page (server error)
    └── 403.html         # Error page (forbidden)
```

## 🔐 Security Features Added

✅ **Environment Variables**: Credentials stored in `.env`, not in code
✅ **Password Hashing**: User passwords hashed with Werkzeug
✅ **CSRF Protection**: Forms protected against Cross-Site Request Forgery attacks
✅ **Input Validation**: WTForms validates all user inputs before processing
✅ **Password Strength Requirements**:
   - Minimum 8 characters
   - Must contain uppercase letter (A-Z)
   - Must contain lowercase letter (a-z)
   - Must contain number (0-9)
   - Must contain special character (@$!%*?&)
✅ **Email Validation**: Only valid email addresses accepted
✅ **Duplicate Detection**: Can't register with existing email
✅ **Logging System**: All important actions logged to `logs/app.log`
✅ **Error Handling**: User-friendly error pages
✅ **Session Management**: Proper user session handling with logout
✅ **Git Security**: `.gitignore` prevents committing secrets

## ⚠️ Important Before Deploying to Production

1. **Change `FLASK_SECRET_KEY`** in `.env` to a secure random string
2. **Set `FLASK_ENV=production`** in `.env`
3. **Use Gunicorn** instead of Flask's development server:
   ```bash
   gunicorn -w 4 -b 0.0.0.0:5000 app:app
   ```
4. **Use a real database** (if using cloud hosting)
5. **Set up HTTPS/SSL** certificate for secure data transmission
6. **Enable database backups** regularly

## 🐛 Troubleshooting

### "ModuleNotFoundError: No module named 'flask'"
→ Run: `pip install -r requirements.txt`

### "Access denied for user 'root'@'localhost'"
→ Check your MySQL username/password in `.env` file

### "No database selected"
→ Make sure you created the database using the SQL commands in `database_setup.sql`

### "CSRF token missing"
→ The form is missing `{{ form.hidden_tag() }}` - check your template

### "Invalid email address" validation error
→ Make sure email has format: `user@domain.com`

### Password validation errors
→ Password must have:
- At least 8 characters
- One uppercase letter (e.g., A)
- One lowercase letter (e.g., a)
- One number (e.g., 1)
- One special character (@$!%*?&)

Example valid password: `SecurePass123!`

## 📊 Available Routes & Features

### Authentication
- **GET /** - Home (redirects based on auth status)
- **GET /register** - User registration form
- **POST /register** - Process registration
- **GET /login** - User login form
- **POST /login** - Process login
- **GET /logout** - Logout user

### Main Features
- **GET /music** - Music reaction challenge
- **GET /quiz** - Random quiz question
- **POST /submit_quiz** - Submit quiz answer
- **GET /dashboard** - Performance tracking chart
- **GET /profile** - User profile with statistics ✨ NEW
- **GET /leaderboard** - Top 10 players leaderboard ✨ NEW

### Error Pages
- **404** - Page not found
- **500** - Server error
- **403** - Access forbidden

## 🎯 Feature Highlights (Phase 3)

✨ **Dynamic Quiz Questions**
- 10+ questions stored in database
- Randomly selected each challenge
- Easy/Medium/Hard difficulty levels

✨ **User Profile Page**
- View personal statistics
- See best scores
- Track accuracy rate
- View join date

✨ **Leaderboard System**
- Top 10 performers list
- Combined score ranking
- Music & Academic score display
- Progress bars for visualization

✨ **Session Management**
- 2-hour session timeout
- Automatic logout on timeout
- Secure session handling

## 📊 Next Steps for Future Development

1. ✅ Add multiple quiz questions (NOW DYNAMIC!)
2. ✅ Implement leaderboard system (COMPLETED!)
3. ✅ Create user profile page (COMPLETED!)
4. 🔲 Add more music challenge types
5. 🔲 Create admin dashboard for managing questions
6. 🔲 Add email verification for registration
7. 🔲 Implement password reset functionality
8. 🔲 Add achievements/badges system

## 🤝 Contributing

This is a BSc Final Year Project. For academic integrity, please submit contributions through your institution's guidelines.

## 📝 License

This project is for educational purposes.

---

**Made with ❤️ for RhythmQuest**
