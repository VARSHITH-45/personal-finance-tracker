-- Setting up the environment, good practice.
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Create the database if it's not already there
CREATE DATABASE IF NOT EXISTS `personal_finance_tracker`;
USE `personal_finance_tracker`;

-- ----------------------------
-- Table structure for Users
-- ----------------------------
DROP TABLE IF EXISTS `Users`;
CREATE TABLE `Users` (
  `user_id` INT AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL UNIQUE,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL COMMENT 'NEVER store plain text passwords. This would be a hash.',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for Categories
-- ----------------------------
DROP TABLE IF EXISTS `Categories`;
CREATE TABLE `Categories` (
  `category_id` INT AUTO_INCREMENT,
  `user_id` INT NOT NULL COMMENT 'Links to the user who created this category.',
  `name` VARCHAR(50) NOT NULL,
  `category_type` ENUM('income', 'expense') NOT NULL COMMENT 'So we can use one table for both.',
  PRIMARY KEY (`category_id`),
  FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE,
  -- A user shouldn't have two 'Groceries' categories for 'expense'
  UNIQUE KEY `uq_user_category_type` (`user_id`, `name`, `category_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for Income
-- ----------------------------
DROP TABLE IF EXISTS `Income`;
CREATE TABLE `Income` (
  `income_id` INT AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  `amount` DECIMAL(10, 2) NOT NULL COMMENT 'Always use DECIMAL for money, not FLOAT.',
  `description` VARCHAR(255),
  `transaction_date` DATE NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`income_id`),
  FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`category_id`) REFERENCES `Categories`(`category_id`) ON DELETE RESTRICT 
  -- We use RESTRICT here. Don't want to delete a category if income is tied to it.
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for Expenses
-- ----------------------------
DROP TABLE IF EXISTS `Expenses`;
CREATE TABLE `Expenses` (
  `expense_id` INT AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  `amount` DECIMAL(10, 2) NOT NULL,
  `description` VARCHAR(255),
  `transaction_date` DATE NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`expense_id`),
  FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`category_id`) REFERENCES `Categories`(`category_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Insert Dummy Data
-- ----------------------------

-- 1. Create Users
INSERT INTO `Users` (`username`, `email`, `password_hash`) 
VALUES 
('bob_smith', 'bob@example.com', 'hashed_password_123'),
('jane_doe', 'jane@example.com', 'hashed_password_456');

-- Get User IDs (better than hardcoding 1 and 2)
SET @bob_id = (SELECT user_id FROM Users WHERE username = 'bob_smith');
SET @jane_id = (SELECT user_id FROM Users WHERE username = 'jane_doe');

-- 2. Create Categories for each user
INSERT INTO `Categories` (`user_id`, `name`, `category_type`)
VALUES
-- Bob's Categories
(@bob_id, 'Salary', 'income'),
(@bob_id, 'Groceries', 'expense'),
(@bob_id, 'Rent', 'expense'),
(@bob_id, 'Utilities', 'expense'),
-- Jane's Categories
(@jane_id, 'Salary', 'income'),
(@jane_id, 'Freelance', 'income'),
(@jane_id, 'Groceries', 'expense'),
(@jane_id, 'Dining Out', 'expense'),
(@jane_id, 'Transport', 'expense');

-- 3. Insert Income Transactions
-- Bob's Income
INSERT INTO `Income` (`user_id`, `category_id`, `amount`, `description`, `transaction_date`)
VALUES
(@bob_id, (SELECT category_id FROM Categories WHERE user_id = @bob_id AND name = 'Salary'), 5000.00, 'Monthly Paycheck', '2025-10-01');

-- Jane's Income
INSERT INTO `Income` (`user_id`, `category_id`, `amount`, `description`, `transaction_date`)
VALUES
(@jane_id, (SELECT category_id FROM Categories WHERE user_id = @jane_id AND name = 'Salary'), 4500.00, 'Monthly Paycheck', '2025-10-01'),
(@jane_id, (SELECT category_id FROM Categories WHERE user_id = @jane_id AND name = 'Freelance'), 750.50, 'Web design project', '2025-10-15');

-- 4. Insert Expense Transactions
-- Bob's Expenses
INSERT INTO `Expenses` (`user_id`, `category_id`, `amount`, `description`, `transaction_date`)
VALUES
(@bob_id, (SELECT category_id FROM Categories WHERE user_id = @bob_id AND name = 'Rent'), 1200.00, 'Monthly Rent', '2025-10-05'),
(@bob_id, (SELECT category_id FROM Categories WHERE user_id = @bob_id AND name = 'Groceries'), 180.45, 'Weekly shop', '2025-10-07'),
(@bob_id, (SELECT category_id FROM Categories WHERE user_id = @bob_id AND name = 'Utilities'), 75.20, 'Electric bill', '2025-10-10');

-- Jane's Expenses
INSERT INTO `Expenses` (`user_id`, `category_id`, `amount`, `description`, `transaction_date`)
VALUES
(@jane_id, (SELECT category_id FROM Categories WHERE user_id = @jane_id AND name = 'Groceries'), 210.00, 'Big grocery run', '2025-10-03'),
(@jane_id, (SELECT category_id FROM Categories WHERE user_id = @jane_id AND name = 'Dining Out'), 65.00, 'Dinner with friends', '2025-10-05'),
(@jane_id, (SELECT category_id FROM Categories WHERE user_id = @jane_id AND name = 'Transport'), 55.50, 'Monthly bus pass', '2025-10-02');

SET FOREIGN_KEY_CHECKS = 1;
