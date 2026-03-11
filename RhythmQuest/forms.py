from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import DataRequired, Email, EqualTo, Length, ValidationError
from wtforms.validators import Regexp
import re

class RegistrationForm(FlaskForm):
    """Form for user registration with validation"""
    
    name = StringField('Full Name',
                       validators=[
                           DataRequired(message='Name is required'),
                           Length(min=2, max=100, message='Name must be between 2 and 100 characters')
                       ])
    
    email = StringField('Email Address',
                        validators=[
                            DataRequired(message='Email is required'),
                            Email(message='Invalid email address')
                        ])
    
    password = PasswordField('Password',
                            validators=[
                                DataRequired(message='Password is required'),
                                Length(min=8, message='Password must be at least 8 characters long'),
                                Regexp(
                                    regex=r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])',
                                    message='Password must contain: uppercase, lowercase, number, and special character (@$!%*?&)'
                                )
                            ])
    
    confirm_password = PasswordField('Confirm Password',
                                     validators=[
                                         DataRequired(message='Please confirm your password'),
                                         EqualTo('password', message='Passwords must match')
                                     ])
    
    submit = SubmitField('🎶 Register')


class LoginForm(FlaskForm):
    """Form for user login with validation"""
    
    email = StringField('Email Address',
                        validators=[
                            DataRequired(message='Email is required'),
                            Email(message='Invalid email address')
                        ])
    
    password = PasswordField('Password',
                            validators=[
                                DataRequired(message='Password is required')
                            ])
    
    submit = SubmitField('🎧 Login')


class QuizForm(FlaskForm):
    """Form for quiz answer submission"""
    
    answer = StringField('Your Answer',
                        validators=[
                            DataRequired(message='Please enter an answer')
                        ])
    
    submit = SubmitField('🚀 Submit')
