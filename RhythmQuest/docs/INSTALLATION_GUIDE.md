# RhythmQuest - Installation Guide

## System Requirements

- **Operating System**: Windows, macOS, or Linux
- **Python**: Version 3.8 or higher
- **MySQL**: Version 5.7 or higher
- **RAM**: 2GB minimum
- **Storage**: 500MB minimum

## Prerequisites

Before installing, make sure you have:
1. ✅ Python installed and in PATH
2. ✅ MySQL installed and running
3. ✅ pip (Python package manager)

---

## **Installation Steps**

### **Step 1: Clone or Download Project**

```bash
# If using Git
git clone https://github.com/yourusername/RhythmQuest.git
cd RhythmQuest
```

Or manually download and extract the project folder.

---

### **Step 2: Set Up Python Environment**

```bash
# Navigate to project directory
cd RhythmQuest

# Create virtual environment (optional but recommended)
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate
```

---

### **Step 3: Install Dependencies**

```bash
# Install required packages
pip install -r requirements.txt
```

**Expected packages:**
- Flask 3.0.0
- Flask-MySQLdb 2.0.0
- Flask-WTF 1.2.1
- WTForms 3.1.1
- python-dotenv 1.0.0
- email_validator 2.3.0

---

### **Step 4: Configure Database**

#### **A. Update `.env` File**

Create/edit `.env` file in project root:

```
FLASK_ENV=development
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=your_password
MYSQL_DB=rhythmquest
FLASK_SECRET_KEY=your_super_secret_key_here_change_this_in_production
```

Replace:
- `your_password` - Your MySQL root password
- `FLASK_SECRET_KEY` - Generate a random string (or use: `python -c "import secrets; print(secrets.token_hex(32))"`)

#### **B. Create Database Tables**

```bash
# Run setup script
python setup_db.py
```

Or manually in MySQL:
```bash
mysql -u root -p
```
```sql
SOURCE database/database_setup.sql;
```

---

### **Step 5: Run the Application**

```bash
# Start Flask development server
python app.py
```

You should see:
```
 * Running on http://127.0.0.1:5000
 * Debug mode: on
```

---

### **Step 6: Access the Application**

Open your browser and go to:
**http://localhost:5000**

---

## **Troubleshooting**

| Problem | Solution |
|---------|----------|
| "ModuleNotFoundError: No module named 'flask'" | Run: `pip install -r requirements.txt` |
| "Cannot connect to MySQL server" | Check MySQL is running, credentials in .env are correct |
| "Port 5000 already in use" | Edit app.py, change `port=5000` to `port=5001` |
| "Database error" | Run: `python setup_db.py` |
| "Email validation error" | Run: `pip install email_validator` |

---

## **Post-Installation Tests**

After installation, verify everything works:

```bash
# Test Flask
python -c "import flask; print('Flask OK')"

# Test MySQL connection
python -c "import MySQLdb; print('MySQL OK')"

# Test database setup
python setup_db.py
```

---

## **For Production Deployment**

See **DEPLOYMENT.md** for cloud hosting options:
- Heroku (free tier available)
- AWS EC2
- PythonAnywhere
- DigitalOcean

---

## **Support**

For issues:
1. Check logs: `logs/app.log`
2. Review README.md
3. Check DEVELOPER_GUIDE.md

---

**Installation Complete! 🎉**

Start testing the application at **http://localhost:5000**
