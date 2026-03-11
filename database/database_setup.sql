-- RhythmQuest Database Setup Script
-- Run this in MySQL to create the database and tables

-- Create the database
CREATE DATABASE IF NOT EXISTS rhythmquest;
USE rhythmquest;

-- Drop existing tables if they exist (for fresh setup)
DROP TABLE IF EXISTS USER_ACHIEVEMENTS;
DROP TABLE IF EXISTS ACHIEVEMENTS;
DROP TABLE IF EXISTS PERFORMANCE;
DROP TABLE IF EXISTS QUESTIONS;
DROP TABLE IF EXISTS STUDENT;

-- =============================================
-- STUDENT TABLE
-- =============================================
-- Stores user account information
CREATE TABLE STUDENT (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT email_valid CHECK (Email LIKE '%@%.%')
);

-- Create index on Email for faster lookups
CREATE INDEX idx_email ON STUDENT(Email);

-- =============================================
-- QUESTIONS TABLE
-- =============================================
-- Stores quiz questions and correct answers
CREATE TABLE QUESTIONS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Question TEXT NOT NULL,
    CorrectAnswer VARCHAR(255) NOT NULL,
    Difficulty VARCHAR(50) DEFAULT 'medium', -- easy, medium, hard
    Category VARCHAR(100) DEFAULT 'math',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample questions (feel free to add more!)
INSERT INTO QUESTIONS (Question, CorrectAnswer, Difficulty, Category) VALUES
('What is 1/4 + 1/4?', '1/2', 'easy', 'math'),
('What is 3/4 + 1/4?', '1', 'easy', 'math'),
('What is 2/3 + 1/3?', '1', 'easy', 'math'),
('What is 5/6 - 1/6?', '2/3', 'medium', 'math'),
('What is 7/8 - 3/8?', '1/2', 'medium', 'math'),
('What is 9/10 - 4/10?', '1/2', 'medium', 'math'),
('What is 5 * 6?', '30', 'easy', 'math'),
('What is 12 / 3?', '4', 'easy', 'math'),
('What is 2^4?', '16', 'medium', 'math'),
('What is the square root of 64?', '8', 'medium', 'math');

-- Create index on Difficulty for category queries
CREATE INDEX idx_difficulty ON QUESTIONS(Difficulty);

-- =============================================
-- PERFORMANCE TABLE
-- =============================================
-- Stores performance data for each quiz attempt
CREATE TABLE PERFORMANCE (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID INT NOT NULL,
    Question_ID INT,
    Music_Score INT NOT NULL DEFAULT 0,
    Academic_Score INT NOT NULL DEFAULT 0,
    Attempt_Number INT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Student_ID) REFERENCES STUDENT(ID) ON DELETE CASCADE,
    FOREIGN KEY (Question_ID) REFERENCES QUESTIONS(ID) ON DELETE SET NULL,
    CONSTRAINT score_range CHECK (Music_Score >= 0 AND Music_Score <= 100),
    CONSTRAINT academic_range CHECK (Academic_Score >= 0 AND Academic_Score <= 100)
);

-- Create index on Student_ID for faster queries
CREATE INDEX idx_student_id ON PERFORMANCE(Student_ID);
CREATE INDEX idx_creation ON PERFORMANCE(CreatedAt);

-- =============================================
-- ACHIEVEMENTS TABLE
-- =============================================
-- Stores available achievements/badges
CREATE TABLE ACHIEVEMENTS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT NOT NULL,
    Icon VARCHAR(50) DEFAULT '🏆',
    Requirement VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample achievements
INSERT INTO ACHIEVEMENTS (Name, Description, Icon, Requirement) VALUES
('First Step', 'Complete your first quiz', '👟', 'Complete 1 quiz'),
('Getting Started', 'Take 5 quizzes', '🚀', 'Complete 5 quizzes'),
('Quiz Master', 'Complete 25 quizzes', '🎓', 'Complete 25 quizzes'),
('Perfect Score', 'Get 100% on a quiz', '💯', 'Score 100 on quiz'),
('Speed Racer', 'Score 100 on music challenge', '⚡', 'Music score 100'),
('Perfectionist', 'Get 10 perfect scores', '✨', '10 perfect quizzes'),
('Climber', 'Reach the leaderboard top 10', '🏆', 'Top 10 ranking'),
('Consistent', 'Average score above 80%', '📈', 'Avg score > 80%'),
('Marathoner', 'Complete 50 attempts', '🔥', '50 total attempts'),
('Legend', 'Average score above 90%', '👑', 'Avg score > 90%');

-- =============================================
-- USER_ACHIEVEMENTS TABLE
-- =============================================
-- Tracks which achievements each user has earned
CREATE TABLE USER_ACHIEVEMENTS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID INT NOT NULL,
    Achievement_ID INT NOT NULL,
    UnlockedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Student_ID) REFERENCES STUDENT(ID) ON DELETE CASCADE,
    FOREIGN KEY (Achievement_ID) REFERENCES ACHIEVEMENTS(ID) ON DELETE CASCADE,
    UNIQUE KEY unique_achievement (Student_ID, Achievement_ID)
);

-- Create index for quick lookups
CREATE INDEX idx_user_achievements ON USER_ACHIEVEMENTS(Student_ID);

-- =============================================
-- VERIFY SETUP
-- =============================================
-- Run these commands to verify your setup:

-- Check all tables
-- SHOW TABLES;

-- Check STUDENT table
-- SELECT * FROM STUDENT;

-- Check QUESTIONS table
-- SELECT COUNT(*) as total_questions FROM QUESTIONS;

-- Check ACHIEVEMENTS
-- SELECT * FROM ACHIEVEMENTS;

-- Check USER_ACHIEVEMENTS
-- SELECT * FROM USER_ACHIEVEMENTS;
