# 🚀 RhythmQuest Deployment Guide

This guide explains how to deploy your RhythmQuest application to production on various platforms.

## ⚠️ Pre-Deployment Checklist

Before deploying, make sure you've completed:

- [ ] **Environment Configuration**
  - [ ] Set `FLASK_ENV=production` in your `.env`
  - [ ] Generate a new strong `FLASK_SECRET_KEY` (never expose the development one!)
  - [ ] Update database credentials for production server
  - [ ] Enable HTTPS/SSL certificate

- [ ] **Security Audit**
  - [ ] Remove all debug code
  - [ ] Review `requirements.txt` - only include necessary packages
  - [ ] Check `.gitignore` includes `.env`
  - [ ] Verify no credentials in code
  - [ ] Run `git log` to ensure no secrets were committed

- [ ] **Testing**
  - [ ] Run all test cases from `TESTING.md`
  - [ ] Load test with multiple concurrent users
  - [ ] Test on actual production database
  - [ ] Verify all error pages display correctly

- [ ] **Database**
  - [ ] Run `database_setup.sql` on production server
  - [ ] Set up automated backups
  - [ ] Test restore from backup
  - [ ] Create database user with limited permissions

---

## 📋 Generate Strong Secret Key

Before deploying, generate a new `FLASK_SECRET_KEY`:

**Option 1: Using Python**
```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

**Option 2: Using OpenSSL**
```bash
openssl rand -hex 32
```

Update your `.env` file:
```
FLASK_SECRET_KEY=your_newly_generated_key_here
```

---

## 🌐 Option 1: Deploy to Heroku (FREE / PAID)

### Step 1: Install Heroku CLI
Download from: https://devcenter.heroku.com/articles/heroku-cli

### Step 2: Create Heroku Account
Sign up at https://www.heroku.com

### Step 3: Create Procfile
Create a file named `Procfile` in your project root:
```
web: gunicorn -w 4 -b 0.0.0.0:$PORT app:app
```

### Step 4: Create runtime.txt (Optional)
Specify Python version:
```
python-3.11.5
```

### Step 5: Login and Deploy
```bash
heroku login
heroku create your-app-name
heroku config:set MYSQL_HOST=your-database-host
heroku config:set MYSQL_USER=your-db-user
heroku config:set MYSQL_PASSWORD=your-db-password
heroku config:set MYSQL_DB=your-db-name
heroku config:set FLASK_SECRET_KEY=your-secret-key
heroku config:set FLASK_ENV=production
git push heroku main
```

### Step 6: Set Up Database
```bash
heroku run python
>>> import MySQLdb
>>> # Test connection
```

---

## 🐍 Option 2: Deploy to PythonAnywhere (PAID)

### Step 1: Create PythonAnywhere Account
Sign up at https://www.pythonanywhere.com

### Step 2: Upload Your Files
1. Go to Files
2. Create folder `rhythmquest`
3. Upload all files (except `.env` and `venv/`)

### Step 3: Create Virtual Environment
In the Bash console:
```bash
mkvirtualenv --python=/usr/bin/python3.9 myenv
pip install -r requirements.txt
```

### Step 4: Configure Web App
1. Go to Web Apps
2. Create new web app (Python 3.9)
3. Choose Flask
4. Point to your project directory

### Step 5: Edit WSGI Configuration
Edit the WSGI configuration file to include:
```python
import sys
import os
path = '/home/yourusername/rhythmquest'
if path not in sys.path:
    sys.path.append(path)

os.environ['FLASK_ENV'] = 'production'
from app import app
application = app
```

### Step 6: Set Environment Variables
Create `.env` file in your project with production settings

### Step 7: Reload Web App
Click "Reload" on the Web tab

---

## 🔐 Option 3: Deploy to AWS (EC2)

### Step 1: Launch EC2 Instance
- Instance type: `t3.micro` (free tier eligible)
- OS: Ubuntu 22.04 LTS
- Security group: Open ports 80 (HTTP), 443 (HTTPS), 22 (SSH)

### Step 2: Connect via SSH
```bash
ssh -i your-key.pem ubuntu@your-ec2-ip
```

### Step 3: Install Dependencies
```bash
sudo apt update
sudo apt install python3-pip python3-venv mysql-server nginx
```

### Step 4: Clone Your Project
```bash
git clone your-repo-url
cd rhythmquest
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Step 5: Configure MySQL
```bash
sudo mysql
CREATE DATABASE rhythmquest;
CREATE USER 'webapp'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON rhythmquest.* TO 'webapp'@'localhost';
FLUSH PRIVILEGES;
```

### Step 6: Set Up Environmental Variables
```bash
cp .env.production .env
nano .env  # Edit with your production values
```

### Step 7: Configure Nginx
Create `/etc/nginx/sites-available/rhythmquest`:
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /static {
        alias /home/ubuntu/rhythmquest/static;
    }
}
```

Enable it:
```bash
sudo ln -s /etc/nginx/sites-available/rhythmquest /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### Step 8: Setup Systemd Service
Create `/etc/systemd/system/rhythmquest.service`:
```ini
[Unit]
Description=RhythmQuest Flask Application
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/rhythmquest
ExecStart=/home/ubuntu/rhythmquest/venv/bin/gunicorn -w 4 -b 127.0.0.1:8000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
```

Start the service:
```bash
sudo systemctl start rhythmquest
sudo systemctl enable rhythmquest
```

---

## 🔒 Enable HTTPS (SSL Certificate)

### Using Let's Encrypt (FREE)

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot certonly --nginx -d your-domain.com
```

Update Nginx config to redirect HTTP to HTTPS:
```nginx
server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;
    
    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    
    # ... rest of config
}
```

---

## 📊 Database Backup Strategy

### Automated Daily Backups

**For AWS EC2:**
```bash
# Create backup script: /home/ubuntu/backup.sh
#!/bin/bash
DATE=$(date +\%Y\%m\%d_\%H\%M\%S)
mysqldump -u webapp -p'secure_password' rhythmquest > /backups/rhythmquest_$DATE.sql
```

Add to crontab:
```bash
crontab -e
# Add: 0 2 * * * /home/ubuntu/backup.sh  (Daily at 2 AM)
```

---

## 📈 Monitoring & Maintenance

### Set Up Monitoring
- **Application Logs**: Check `/var/log/rhythmquest/`
- **Error Tracking**: Consider services like Sentry
- **Performance Monitoring**: Use tools like New Relic

### Regular Tasks
- [ ] Check logs weekly
- [ ] Monitor disk space
- [ ] Update dependencies monthly
- [ ] Review database backups
- [ ] Performance optimization
- [ ] Security patches

---

## 🔧 Troubleshooting Deployment Issues

### Issue: `ImportError: No module named 'flask'`
**Solution**: Activate virtual environment before running app
```bash
source venv/bin/activate
```

### Issue: Database connection refused
**Solution**: Check MySQL is running and credentials in `.env`
```bash
sudo systemctl status mysql
```

### Issue: Port 5000 already in use
**Solution**: Use different port
```bash
python app.py --port 5001
```

### Issue: Static files not loading
**Solution**: Ensure Nginx is configured correctly for static files
```nginx
location /static {
    alias /path/to/rhythmquest/static;
}
```

### Issue: CSRF token errors in production
**Solution**: Ensure `FLASK_SECRET_KEY` is set and consistent
```bash
echo $FLASK_SECRET_KEY  # Verify it's set
```

---

## 🎯 Performance Optimization

### For Production:

1. **Enable Caching**
   - Add Redis for session storage
   - Cache dashboard queries

2. **Optimize Database**
   - Add proper indexes
   - Archive old performance records
   - Use query optimization

3. **Use CDN**
   - CloudFront for static assets
   - CSS/JS minification

4. **Enable Compression**
   - Gzip compression in Nginx
   - Minify HTML/CSS/JS

---

## 📝 Post-Deployment

1. **Domain Setup**
   - Point your domain to the server
   - Set up MX records if needed

2. **Monitoring**
   - Set up error logging
   - Configure alerts

3. **Backups**
   - Verify backups run successfully
   - Test restore procedure

4. **Documentation**
   - Document your setup
   - Keep deployment notes
   - Create runbook for troubleshooting

---

## 🆘 Getting Help

- Heroku Docs: https://devcenter.heroku.com
- PythonAnywhere Help: https://help.pythonanywhere.com
- AWS Documentation: https://docs.aws.amazon.com
- Flask Documentation: https://flask.palletsprojects.com

---

**Happy Deploying! 🚀**
