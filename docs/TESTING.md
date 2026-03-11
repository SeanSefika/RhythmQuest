# 🧪 RhythmQuest Testing Guide

This guide will help you test all the new security features and validations we've added.

## 📋 Pre-Testing Checklist

- [ ] Database is created and running
- [ ] `.env` file is configured correctly
- [ ] All requirements installed: `pip install -r requirements.txt`
- [ ] Flask app starts without errors: `python app.py`

## 🧪 Test Cases

### 1. Registration Form Validation

#### Test 1.1: Valid Registration
**Expected**: User should be registered and redirected to login with success message

1. Go to `/register`
2. Fill in:
   - Name: `John Doe`
   - Email: `john@example.com`
   - Password: `SecurePass123!`
   - Confirm: `SecurePass123!`
3. Click Register
4. **Expected Result**: ✅ "Registration successful! Please login." appears, redirected to login

#### Test 1.2: Short Password (< 8 characters)
**Expected**: Error message about password length

1. Go to `/register`
2. Fill in:
   - Name: `Jane Doe`
   - Email: `jane@example.com`
   - Password: `Pass12!`
3. **Expected Result**: ❌ Error: "Password must be at least 8 characters long"

#### Test 1.3: Password Without Uppercase Letter
**Expected**: Error message about uppercase requirement

1. Go to `/register`
2. Fill password: `securepass123!`
3. **Expected Result**: ❌ Error about uppercase letter requirement

#### Test 1.4: Password Without Number
**Expected**: Error message about number requirement

1. Go to `/register`
2. Fill password: `SecurePassword!`
3. **Expected Result**: ❌ Error about number requirement

#### Test 1.5: Password Without Special Character
**Expected**: Error message about special character requirement

1. Go to `/register`
2. Fill password: `SecurePass123`
3. **Expected Result**: ❌ Error about special character requirement

#### Test 1.6: Passwords Don't Match
**Expected**: Error message about passwords not matching

1. Go to `/register`
2. Password: `SecurePass123!`
3. Confirm: `SecurePass124!`
4. **Expected Result**: ❌ Error: "Passwords must match"

#### Test 1.7: Duplicate Email
**Expected**: Error when registering with existing email

1. Register with `test@example.com` first
2. Try to register again with `test@example.com`
3. **Expected Result**: ❌ Error: "Email already registered!"

#### Test 1.8: Invalid Email Format
**Expected**: Error for invalid email

1. Fill email: `invalidemail`
2. **Expected Result**: ❌ Error: "Invalid email address"

---

### 2. Login Form Validation

#### Test 2.1: Valid Login
**Expected**: Successful login with personalized greeting

1. Register first if needed
2. Go to `/login`
3. Enter registered email and password
4. **Expected Result**: ✅ "Welcome back, [Name]!" appears, redirected to music page

#### Test 2.2: Wrong Password
**Expected**: Error message for invalid credentials

1. Go to `/login`
2. Email: `john@example.com`
3. Password: `WrongPassword123!`
4. **Expected Result**: ❌ Error: "Invalid email or password"

#### Test 2.3: Non-existent Email
**Expected**: Error message

1. Go to `/login`
2. Email: `nonexistent@example.com`
3. Password: `AnyPassword123!`
4. **Expected Result**: ❌ Error: "Invalid email or password"

#### Test 2.4: Empty Email
**Expected**: Validation error

1. Go to `/login`
2. Leave email empty
3. **Expected Result**: ❌ Error: "Email is required"

---

### 3. Logout Functionality

#### Test 3.1: Logout Button Works
**Expected**: User logged out and redirected to login

1. Login successfully
2. Click "Logout" button in navbar
3. **Expected Result**: ✅ "You have been logged out successfully!" message, redirected to login page

#### Test 3.2: Session Cleared
**Expected**: Can't access protected pages after logout

1. Logout
2. Try to visit `/music` directly
3. **Expected Result**: ❌ Redirected to login page

---

### 4. Quiz Answer Validation

#### Test 4.1: Correct Answer
**Expected**: Score 100 and success message

1. Complete music challenge
2. Go to quiz
3. Answer: `1/2`
4. **Expected Result**: ✅ "Correct! 🎉" message, saved to dashboard

#### Test 4.2: Incorrect Answer
**Expected**: Score 0 and hint shown

1. Go to quiz
2. Answer: `2/4` (different fraction)
3. **Expected Result**: ❌ "Incorrect. The answer is: 1/2" message

#### Test 4.3: Answer with Spaces (Normalized)
**Expected**: Should work (spaces removed)

1. Answer: `1 / 2` (with spaces)
2. **Expected Result**: ✅ Should accept as correct

#### Test 4.4: Empty Answer
**Expected**: Validation error

1. Leave answer empty
2. Click submit
3. **Expected Result**: ❌ Error: "Please enter an answer"

---

### 5. Error Pages Testing

#### Test 5.1: 404 Error
**Expected**: Friendly error page

1. Visit: `/nonexistent-page`
2. **Expected Result**: ✅ Shows "404 Page Not Found" with home button

#### Test 5.2: 403 Error (Access Forbidden)
**Expected**: Can't access /music without login

1. Make sure you're logged out
2. Visit: `/music`
3. **Expected Result**: ❌ Redirected to `/login` (403 protection)

---

### 6. Flash Messages Testing

#### Test 6.1: Success Messages
**Expected**: Green alert box with message

- After registration: "Registration successful!"
- After login: "Welcome back, [Name]!"
- After correct quiz answer: "Correct! 🎉"

#### Test 6.2: Error Messages
**Expected**: Red alert box with error

- Registration errors show in red
- Login errors show in red
- Quiz errors show in red

#### Test 6.3: Message Dismissal
**Expected**: Can close message by clicking X

1. See any message
2. Click the X button
3. **Expected Result**: ✅ Message disappears

---

### 7. Logging System Testing

#### Test 7.1: Check Log Files
**Expected**: Logs folder exists with app.log

1. Look for `/logs/app.log` folder
2. Open `app.log` file
3. **Expected Result**: ✅ Should see entries like:
   ```
   2026-03-07 10:30:45 - INFO - New user registered: john@example.com
   2026-03-07 10:31:20 - INFO - User logged in: john@example.com
   2026-03-07 10:32:15 - INFO - User answered quiz correctly
   ```

#### Test 7.2: Failed Attempts Logged
**Expected**: Failed login attempts recorded

1. Try wrong password
2. Check logs
3. **Expected Result**: ✅ Entry like: "Failed login attempt for email: john@example.com"

---

## 🐛 Troubleshooting Tests

### Issue: Form errors not showing
**Solution**: Check that templates have the error display code:
```html
{% if form.name.errors %}
    <div class="invalid-feedback d-block">...</div>
{% endif %}
```

### Issue: CSRF token errors
**Solution**: Template must include `{{ form.hidden_tag() }}` inside form

### Issue: Database constraint errors
**Solution**: Check `/logs/app.log` for detailed error messages

### Issue: Email validation too strict
**Solution**: Check the regex pattern in `forms.py`

---

## ✅ Testing Checklist Summary

- [ ] All password requirements validated
- [ ] Email format validated
- [ ] Duplicate emails rejected
- [ ] Login/logout works properly
- [ ] Quiz answers accepted/rejected correctly
- [ ] Error messages display properly
- [ ] Success messages display properly
- [ ] Logs are being created and recorded
- [ ] Session management working
- [ ] Error pages (404, 500) display correctly

---

## 📊 Performance Test

### Expected Response Times
- Login page load: < 500ms
- Login submission: < 1000ms
- Quiz submission: < 500ms
- Dashboard load: < 1000ms

If any of these are slower, check:
1. MySQL connection
2. Network latency
3. Database has proper indexes

---

## 🚀 Next Steps After Testing

Once all tests pass:
1. ✅ Commit changes to git (not .env!)
2. ✅ Write documentation for developers
3. ✅ Set up deployment
4. ✅ Configure production environment

---

**Happy Testing! 🎵**
