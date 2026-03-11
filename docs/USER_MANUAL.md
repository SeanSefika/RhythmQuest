# RhythmQuest - User Manual

## Welcome to RhythmQuest! 🎵

A web application combining **music reaction challenges** with **academic quizzes** for an engaging learning experience.

---

## **Table of Contents**
1. Getting Started
2. Registration & Login
3. Music Challenge
4. Quiz System
5. Profile & Statistics
6. Leaderboard
7. Achievements
8. Admin Features

---

## **1. Getting Started** 🚀

### **Access the Application**
- Open your browser
- Go to: **http://localhost:5000**
- You should see the **RhythmQuest Home Page**

### **First Time Users**
1. Click **"Register"** button
2. Create your account (see Registration section)
3. Start playing!

---

## **2. Registration & Login** 👤

### **Create Account**

**Password Requirements:**
- Minimum 8 characters
- At least one UPPERCASE letter
- At least one lowercase letter
- At least one number (0-9)
- At least one special character (!@#$%^&*)

**Example Valid Password:** `MyPass123!`

**Steps:**
1. Click **"Register"**
2. Enter Name: `John Doe`
3. Enter Email: `john@example.com`
4. Enter Password: `MyPass123!`
5. Click **Register**
6. Automatically redirected to login
7. Log in with your credentials

### **Login**
1. Click **"Login"**
2. Enter your Email
3. Enter your Password
4. Click **Login**
5. Redirected to Dashboard

### **Forgot Password?**
Not implemented yet - contact admin if you forget your password.

---

## **3. Music Challenge** 🎵

### **How to Play**

1. Click **"Music"** button in navbar
2. Click **"Start Challenge"**
3. **LISTEN CAREFULLY** - you'll hear a musical note or beep
4. Click the button as soon as you hear the sound
5. Your **reaction time** is recorded (in milliseconds)

### **Scoring**

| Reaction Time | Score |
|---|---|
| < 200ms | **100** (Excellent!) |
| 200-300ms | **80** (Good) |
| 300-400ms | **60** (Okay) |
| > 400ms | **40** (Slow) |

### **Tips for Better Score**
- Use good quality headphones
- Sit in a quiet environment
- Stay focused and alert
- Try multiple times to improve

### **Requirement to Take Quiz**
- You must score **60 or higher** on music challenge to take the quiz
- If you score below 60, try again!

---

## **4. Quiz System** ❓

### **How to Quiz**

1. After scoring 60+ on music challenge, click **"Take Quiz"**
2. Read the **question carefully**
3. Type your answer in the text field
4. Click **"Submit Answer"**
5. See your **quiz score** (0-100)

### **Questions**

- **Topics**: Mathematics (fractions, multiplication, etc.)
- **Random**: Different question each time
- **10+ Questions** available (more can be added via admin)
- **Difficulty Levels**: Easy, Medium, Hard

### **Answer Format**

Follow the **Hint** provided with each question:
- **Fractions**: `1/2`, `3/4`, etc.
- **Whole Numbers**: `5`, `10`, `25`, etc.
- **Case Insensitive**: `1/2` same as `1/2`
- **Spaces ignored**: `1 / 2` same as `1/2`

### **Example Question**

```
Question: "What is 1/4 + 1/4?"
Hint: Express as a fraction (e.g., 1/2)
Correct Answer: 1/2
Your Answer: 1/2 ✓ (Correct - Score: 100)
```

---

## **5. Profile & Statistics** 👤

### **View Your Profile**

1. Click **"Profile"** in navbar
2. See your personal statistics

### **What's Displayed**

| Stat | Description |
|------|-------------|
| **Name** | Your account name |
| **Email** | Your registered email |
| **Join Date** | When you created account |
| **Total Attempts** | Total quizzes taken |
| **Music Score (Avg)** | Average music reaction score |
| **Academic Score (Avg)** | Average quiz score |
| **Best Music Score** | Highest music reaction score |
| **Best Academic Score** | Highest quiz score |
| **Combined Average** | (Music + Academic) / 2 |

### **Interpreting Your Stats**

- **Above 80%**: Excellent performer! 🌟
- **70-80%**: Good player 👍
- **Below 70%**: Keep practicing! 💪

---

## **6. Leaderboard** 🏆

### **View Rankings**

1. Click **"Leaderboard"** in navbar
2. See **top 10 players** ranked by combined score

### **Medal System**

| Rank | Medal |
|------|-------|
| 1st | 🥇 Gold |
| 2nd | 🥈 Silver |
| 3rd | 🥉 Bronze |
| 4-10 | — |

### **What It Shows**

- Player **Name**
- **Music Score** (average)
- **Academic Score** (average)
- **Combined Score** (both averaged together)
- **Progress bar** visualizing score

### **Tips to Climb Leaderboard**

1. Play more quizzes (higher average)
2. Get 100% on music challenges
3. Answer quiz questions correctly
4. Consistent high scores beats one-time attempts

---

## **7. Achievements** 🎖️

### **View Your Badges**

1. Click **"🏆 Achievements"** in navbar
2. See all **10 available badges**
3. Unlocked badges show **✓ UNLOCKED**
4. Locked badges show **🔒 LOCKED**

### **10 Achievement Badges**

| Badge | Requirement |
|-------|-------------|
| 👟 **First Step** | Complete 1 quiz |
| 🚀 **Getting Started** | Complete 5 quizzes |
| 🎓 **Quiz Master** | Complete 25 quizzes |
| 💯 **Perfect Score** | Get 100% on a quiz |
| ⚡ **Speed Racer** | Music score ≥ 100 |
| ✨ **Perfectionist** | Get 10 perfect scores |
| 🏆 **Climber** | Reach top 10 on leaderboard |
| 📈 **Consistent** | Average score ≥ 80% |
| 🔥 **Marathoner** | Complete 50 attempts |
| 👑 **Legend** | Average score ≥ 90% |

### **Unlocking Strategy**

1. **Start**: Complete first quiz (👟 First Step)
2. **Grow**: Take more quizzes (🚀 Getting Started)
3. **Challenge**: Get high scores (💯 Perfect Score)
4. **Master**: Reach 25+ quizzes (🎓 Quiz Master)
5. **Compete**: Reach leaderboard (🏆 Climber)
6. **Excel**: Maintain 80%+ average (📈 Consistent)

---

## **8. Admin Features** ⚙️

### **Admin Access** (First User Only)

Only the first registered user (you!) can access admin features.

### **How to Access Admin**

1. Log in as first user
2. Look for **"⚙️ Admin"** button in navbar
3. Click it
4. Go to Admin Dashboard

### **Admin Dashboard**

Shows:
- **Total Users** on platform
- **Total Questions** in database
- **Total Attempts** (all quiz attempts)

---

## **9. Add Questions (Admin Only)** ➕

### **Steps**

1. Go to **Admin Dashboard**
2. Under **"Add a new question"** section:
   - **Question**: Enter your question
   - **Answer**: Enter correct answer
   - **Difficulty**: Choose Easy/Medium/Hard
3. Click **"✅ Add Question"**
4. New question appears in table

### **Example**

```
Question: "What is 7 + 8?"
Answer: "15"
Difficulty: "Easy"
```

---

## **10. Delete Questions (Admin Only)** ❌

### **Steps**

1. Go to **Admin Dashboard**
2. Find question in **"Question Management"** table
3. Click **"🗑️ Delete"** button
4. Confirm deletion
5. Question removed immediately

---

## **Common Issues & Solutions** 🔧

| Issue | Solution |
|-------|----------|
| Can't login | Check email/password, make sure you registered |
| Music challenge won't play sound | Check volume, try headphones, refresh |
| Quiz score not saving | Refresh page, check database connection |
| Can't see achievements | Wait a few minutes, achievements update automatically |
| Forgot password | Contact admin to reset |

---

## **Tips for Best Experience** 💡

1. **Use Headphones** - Music challenges sound better
2. **Quiet Environment** - Reduces latency
3. **Good Internet** - For database operations
4. **Take Breaks** - Don't play too long at once
5. **Check Profile** - Monitor your progress regularly
6. **Try Different Difficulties** - Challenge yourself

---

## **Keyboard Shortcuts** ⌨️

| Shortcut | Action |
|----------|--------|
| Ctrl+R | Refresh page |
| Alt+← | Back button |
| Spacebar | Music challenge trigger (if enabled) |

---

## **Account Security** 🔐

- **Never share password** with anyone
- **Logout** when done playing
- **Change password** regularly (feature coming soon)
- **Use strong password** with special characters

---

## **Support & Feedback** 📞

Having issues?
1. Check this manual
2. Try refreshing the page
3. Clear browser cache
4. Contact administrator

---

**Happy Learning! 🚀**

Start at **http://localhost:5000** and begin your RhythmQuest journey!
