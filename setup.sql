CREATE DATABASE library_management;
USE library_management;

-- Admin table
CREATE TABLE admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories table
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    status TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Authors table
CREATE TABLE authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Books table
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_name VARCHAR(255) NOT NULL,
    category_id INT,
    author_id INT,
    isbn VARCHAR(50),
    price DECIMAL(10,2),
    quantity INT DEFAULT 0,
    available_quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (author_id) REFERENCES authors(id)
);

-- Students table
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) UNIQUE NOT NULL,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mobile VARCHAR(15),
    password VARCHAR(255) NOT NULL,
    status TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Issue books table
CREATE TABLE issued_books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    student_id VARCHAR(20),
    issued_date DATE,
    return_date DATE,
    returned_date DATE NULL,
    fine DECIMAL(8,2) DEFAULT 0,
    status ENUM('issued', 'returned') DEFAULT 'issued',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Insert default admin
INSERT INTO admin (fullname, email, password) VALUES 
('Admin User', 'admin@library.com', MD5('admin123'));

-- Insert sample categories
INSERT INTO categories (category_name) VALUES 
('Programming'), ('Science Fiction'), ('History'), ('Mathematics'), ('Physics'), ('Literature');

-- Insert sample authors
INSERT INTO authors (author_name) VALUES 
('Robert C. Martin'), ('Isaac Asimov');

-- Insert sample student
INSERT INTO students (student_id, fullname, email, mobile, password) VALUES 
('STU001', 'John Doe', 'student@example.com', '1234567890', MD5('student123'));
-- Add to existing setup.sql

-- Activity logs table
CREATE TABLE activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_type ENUM('admin', 'student') NOT NULL,
    user_id VARCHAR(50) NOT NULL,
    action VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Password reset tokens table
CREATE TABLE password_reset_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    token VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    used TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add indexes for better performance
CREATE INDEX idx_issued_books_student ON issued_books(student_id);
CREATE INDEX idx_issued_books_status ON issued_books(status);
CREATE INDEX idx_books_category ON books(category_id);
CREATE INDEX idx_books_author ON books(author_id);
CREATE INDEX idx_students_email ON students(email);
CREATE INDEX idx_students_student_id ON students(student_id);

-- Update books table to add more fields
ALTER TABLE books ADD COLUMN publication_year YEAR AFTER isbn;
ALTER TABLE books ADD COLUMN pages INT AFTER publication_year;
ALTER TABLE books ADD COLUMN language VARCHAR(50) DEFAULT 'English' AFTER pages;

-- Insert additional sample data
INSERT INTO categories (category_name) VALUES 
('Computer Science'), ('Engineering'), ('Business'), ('Arts'), ('Medicine');

INSERT INTO authors (author_name) VALUES 
('Martin Fowler'), ('Kent Beck'), ('Gang of Four'), ('Steve McConnell'), ('Andrew Hunt');

INSERT INTO books (book_name, category_id, author_id, isbn, price, quantity, available_quantity, publication_year, pages) VALUES 
('Clean Code', 1, 1, '978-0132350884', 45.99, 5, 5, 2008, 464),
('Refactoring', 1, 1, '978-0201485677', 54.99, 3, 3, 1999, 431),
('Design Patterns', 1, 3, '978-0201633610', 64.99, 4, 4, 1994, 395),
('Code Complete', 1, 4, '978-0735619678', 49.99, 6, 6, 2004, 960),
('The Pragmatic Programmer', 1, 5, '978-0201616224', 44.99, 4, 4, 1999, 352);
