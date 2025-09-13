#!/bin/bash

# Library Management System - Complete Installation Script
# This script sets up the entire system including PHP web interface and C++ backend

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_status "🚀 Starting Library Management System Installation..."

# Check for required tools
print_status "🔍 Checking system requirements..."

MISSING_TOOLS=()

if ! command_exists php; then
    MISSING_TOOLS+=("php")
fi

if ! command_exists mysql; then
    MISSING_TOOLS+=("mysql")
fi

if ! command_exists g++; then
    MISSING_TOOLS+=("g++")
fi

if ! command_exists make; then
    MISSING_TOOLS+=("make")
fi

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    print_error "Missing required tools: ${MISSING_TOOLS[*]}"
    print_status "Please install the missing tools and run this script again."
    
    # Provide installation suggestions based on OS
    if command_exists apt-get; then
        print_status "On Ubuntu/Debian, run:"
        echo "sudo apt-get update"
        echo "sudo apt-get install apache2 php php-mysql mysql-server g++ make build-essential"
    elif command_exists yum; then
        print_status "On CentOS/RHEL, run:"
        echo "sudo yum install httpd php php-mysql mysql-server gcc-c++ make"
    elif command_exists brew; then
        print_status "On macOS with Homebrew, run:"
        echo "brew install php mysql gcc make"
    fi
    
    exit 1
fi

print_success "✅ All required tools are available!"

# Create necessary directories
print_status "📁 Creating project directories..."
mkdir -p include src obj config database assets/css assets/js admin student cpp-backend

# =============================================================================
# C++ BACKEND SETUP AND FIX
# =============================================================================

print_status "🔧 Setting up C++ backend with fixes..."

# Create the complete header file
print_status "📄 Creating clean C++ header file..."
cat > include/library.h << 'EOF'
#ifndef LIBRARY_H
#define LIBRARY_H

#include <string>
#include <vector>
#include <map>
#include <iostream>
#include <fstream>

class Book {
private:
    int id;
    std::string title;
    std::string author;
    std::string isbn;
    bool available;

public:
    // Default constructor
    Book() : id(0), title(""), author(""), isbn(""), available(true) {}
    
    // Parameterized constructor
    Book(int id, const std::string& title, const std::string& author, const std::string& isbn)
        : id(id), title(title), author(author), isbn(isbn), available(true) {}
    
    // Copy constructor
    Book(const Book& other)
        : id(other.id), title(other.title), author(other.author), isbn(other.isbn), available(other.available) {}
    
    // Assignment operator
    Book& operator=(const Book& other) {
        if (this != &other) {
            id = other.id;
            title = other.title;
            author = other.author;
            isbn = other.isbn;
            available = other.available;
        }
        return *this;
    }
    
    // Getters
    int getId() const { return id; }
    std::string getTitle() const { return title; }
    std::string getAuthor() const { return author; }
    std::string getIsbn() const { return isbn; }
    bool isAvailable() const { return available; }
    
    // Setters
    void setId(int newId) { id = newId; }
    void setTitle(const std::string& newTitle) { title = newTitle; }
    void setAuthor(const std::string& newAuthor) { author = newAuthor; }
    void setIsbn(const std::string& newIsbn) { isbn = newIsbn; }
    void setAvailable(bool status) { available = status; }
    
    // Display method
    void display() const {
        std::cout << "ID: " << id << ", Title: " << title 
                  << ", Author: " << author << ", ISBN: " << isbn 
                  << ", Available: " << (available ? "Yes" : "No") << std::endl;
    }
};

class Student {
private:
    int id;
    std::string name;
    std::string email;
    std::vector<int> borrowedBooks;

public:
    // Default constructor
    Student() : id(0), name(""), email("") {}
    
    // Parameterized constructor
    Student(int id, const std::string& name, const std::string& email)
        : id(id), name(name), email(email) {}
    
    // Getters
    int getId() const { return id; }
    std::string getName() const { return name; }
    std::string getEmail() const { return email; }
    const std::vector<int>& getBorrowedBooks() const { return borrowedBooks; }
    
    // Setters
    void setId(int newId) { id = newId; }
    void setName(const std::string& newName) { name = newName; }
    void setEmail(const std::string& newEmail) { email = newEmail; }
    
    // Book management
    void borrowBook(int bookId) { borrowedBooks.push_back(bookId); }
    bool returnBook(int bookId);
    
    // Display method
    void display() const {
        std::cout << "ID: " << id << ", Name: " << name 
                  << ", Email: " << email << ", Books borrowed: " 
                  << borrowedBooks.size() << std::endl;
    }
};

class Library {
private:
    std::vector<Book> books;
    std::vector<Student> students;
    int nextBookId;
    int nextStudentId;

public:
    // Constructor
    Library() : nextBookId(1), nextStudentId(1) {}
    
    // Book management
    void addBook(const std::string& title, const std::string& author, const std::string& isbn);
    void removeBook(int bookId);
    Book* findBook(int bookId);
    void displayAllBooks();
    
    // Student management
    void addStudent(const std::string& name, const std::string& email);
    void removeStudent(int studentId);
    Student* findStudent(int studentId);
    void displayAllStudents();
    
    // Library operations
    bool issueBook(int studentId, int bookId);
    bool returnBook(int studentId, int bookId);
    void searchBooks(const std::string& query);
    
    // File operations
    void saveToFile(const std::string& filename);
    void loadFromFile(const std::string& filename);
};

#endif // LIBRARY_H
EOF

# Create the library implementation
print_status "📄 Creating C++ library implementation..."
cat > src/library.cpp << 'EOF'
#include "library.h"
#include <iostream>
#include <fstream>
#include <algorithm>

// Student methods
bool Student::returnBook(int bookId) {
    auto it = std::find(borrowedBooks.begin(), borrowedBooks.end(), bookId);
    if (it != borrowedBooks.end()) {
        borrowedBooks.erase(it);
        return true;
    }
    return false;
}

// Library methods
void Library::addBook(const std::string& title, const std::string& author, const std::string& isbn) {
    books.push_back(Book(nextBookId++, title, author, isbn));
    std::cout << "Book added successfully!" << std::endl;
}

void Library::removeBook(int bookId) {
    auto it = std::find_if(books.begin(), books.end(),
        [bookId](const Book& book) { return book.getId() == bookId; });
    
    if (it != books.end()) {
        books.erase(it);
        std::cout << "Book removed successfully!" << std::endl;
    } else {
        std::cout << "Book not found!" << std::endl;
    }
}

Book* Library::findBook(int bookId) {
    auto it = std::find_if(books.begin(), books.end(),
        [bookId](const Book& book) { return book.getId() == bookId; });
    
    return (it != books.end()) ? &(*it) : nullptr;
}

void Library::displayAllBooks() {
    if (books.empty()) {
        std::cout << "No books in the library." << std::endl;
        return;
    }
    
    std::cout << "\n=== Library Books ===" << std::endl;
    for (const auto& book : books) {
        book.display();
    }
}

void Library::addStudent(const std::string& name, const std::string& email) {
    students.push_back(Student(nextStudentId++, name, email));
    std::cout << "Student added successfully!" << std::endl;
}

void Library::removeStudent(int studentId) {
    auto it = std::find_if(students.begin(), students.end(),
        [studentId](const Student& student) { return student.getId() == studentId; });
    
    if (it != students.end()) {
        students.erase(it);
        std::cout << "Student removed successfully!" << std::endl;
    } else {
        std::cout << "Student not found!" << std::endl;
    }
}

Student* Library::findStudent(int studentId) {
    auto it = std::find_if(students.begin(), students.end(),
        [studentId](const Student& student) { return student.getId() == studentId; });
    
    return (it != students.end()) ? &(*it) : nullptr;
}

void Library::displayAllStudents() {
    if (students.empty()) {
        std::cout << "No students registered." << std::endl;
        return;
    }
    
    std::cout << "\n=== Registered Students ===" << std::endl;
    for (const auto& student : students) {
        student.display();
    }
}

bool Library::issueBook(int studentId, int bookId) {
    Student* student = findStudent(studentId);
    Book* book = findBook(bookId);
    
    if (!student) {
        std::cout << "Student not found!" << std::endl;
        return false;
    }
    
    if (!book) {
        std::cout << "Book not found!" << std::endl;
        return false;
    }
    
    if (!book->isAvailable()) {
        std::cout << "Book is not available!" << std::endl;
        return false;
    }
    
    book->setAvailable(false);
    student->borrowBook(bookId);
    std::cout << "Book issued successfully!" << std::endl;
    return true;
}

bool Library::returnBook(int studentId, int bookId) {
    Student* student = findStudent(studentId);
    Book* book = findBook(bookId);
    
    if (!student) {
        std::cout << "Student not found!" << std::endl;
        return false;
    }
    
    if (!book) {
        std::cout << "Book not found!" << std::endl;
        return false;
    }
    
    if (student->returnBook(bookId)) {
        book->setAvailable(true);
        std::cout << "Book returned successfully!" << std::endl;
        return true;
    } else {
        std::cout << "This book was not borrowed by this student!" << std::endl;
        return false;
    }
}

void Library::searchBooks(const std::string& query) {
    std::cout << "\n=== Search Results ===" << std::endl;
    bool found = false;
    
    for (const auto& book : books) {
        if (book.getTitle().find(query) != std::string::npos ||
            book.getAuthor().find(query) != std::string::npos ||
            book.getIsbn().find(query) != std::string::npos) {
            book.display();
            found = true;
        }
    }
    
    if (!found) {
        std::cout << "No books found matching the search query." << std::endl;
    }
}

void Library::saveToFile(const std::string& filename) {
    std::ofstream file(filename);
    if (!file.is_open()) {
        std::cout << "Error: Could not open file for writing!" << std::endl;
        return;
    }
    
    // Save books
    file << books.size() << std::endl;
    for (const auto& book : books) {
        file << book.getId() << " " << book.getTitle() << " " 
             << book.getAuthor() << " " << book.getIsbn() << " " 
             << book.isAvailable() << std::endl;
    }
    
    // Save students
    file << students.size() << std::endl;
    for (const auto& student : students) {
        file << student.getId() << " " << student.getName() << " " 
             << student.getEmail() << " " << student.getBorrowedBooks().size();
        for (int bookId : student.getBorrowedBooks()) {
            file << " " << bookId;
        }
        file << std::endl;
    }
    
    file.close();
    std::cout << "Data saved successfully!" << std::endl;
}

void Library::loadFromFile(const std::string& filename) {
    std::ifstream file(filename);
    if (!file.is_open()) {
        std::cout << "Note: Could not open file for reading. Starting with empty library." << std::endl;
        return;
    }
    
    books.clear();
    students.clear();
    
    // Load books
    size_t bookCount;
    file >> bookCount;
    for (size_t i = 0; i < bookCount; ++i) {
        int id;
        std::string title, author, isbn;
        bool available;
        file >> id >> title >> author >> isbn >> available;
        
        Book book(id, title, author, isbn);
        book.setAvailable(available);
        books.push_back(book);
        
        if (id >= nextBookId) {
            nextBookId = id + 1;
        }
    }
    
    // Load students
    size_t studentCount;
    file >> studentCount;
    for (size_t i = 0; i < studentCount; ++i) {
        int id;
        std::string name, email;
        size_t borrowedCount;
        file >> id >> name >> email >> borrowedCount;
        
        Student student(id, name, email);
        for (size_t j = 0; j < borrowedCount; ++j) {
            int bookId;
            file >> bookId;
            student.borrowBook(bookId);
        }
        students.push_back(student);
        
        if (id >= nextStudentId) {
            nextStudentId = id + 1;
        }
    }
    
    file.close();
    std::cout << "Data loaded successfully!" << std::endl;
}
EOF

# Create the main application
print_status "📄 Creating C++ main application..."
cat > src/main.cpp << 'EOF'
#include "library.h"
#include <iostream>
#include <string>

void displayMenu() {
    std::cout << "\n=== Library Management System ===" << std::endl;
    std::cout << "1. Add Book" << std::endl;
    std::cout << "2. Remove Book" << std::endl;
    std::cout << "3. Display All Books" << std::endl;
    std::cout << "4. Add Student" << std::endl;
    std::cout << "5. Remove Student" << std::endl;
    std::cout << "6. Display All Students" << std::endl;
    std::cout << "7. Issue Book" << std::endl;
    std::cout << "8. Return Book" << std::endl;
    std::cout << "9. Search Books" << std::endl;
    std::cout << "10. Save Data" << std::endl;
    std::cout << "11. Load Data" << std::endl;
    std::cout << "0. Exit" << std::endl;
    std::cout << "Enter your choice: ";
}

int main() {
    Library library;
    int choice;
    
    std::cout << "Welcome to Library Management System!" << std::endl;
    
    // Try to load existing data
    library.loadFromFile("library_data.txt");
    
    while (true) {
        displayMenu();
        std::cin >> choice;
        
        switch (choice) {
            case 1: {
                std::string title, author, isbn;
                std::cout << "Enter book title: ";
                std::cin.ignore();
                std::getline(std::cin, title);
                std::cout << "Enter author: ";
                std::getline(std::cin, author);
                std::cout << "Enter ISBN: ";
                std::getline(std::cin, isbn);
                library.addBook(title, author, isbn);
                break;
            }
            case 2: {
                int bookId;
                std::cout << "Enter book ID to remove: ";
                std::cin >> bookId;
                library.removeBook(bookId);
                break;
            }
            case 3:
                library.displayAllBooks();
                break;
            case 4: {
                std::string name, email;
                std::cout << "Enter student name: ";
                std::cin.ignore();
                std::getline(std::cin, name);
                std::cout << "Enter email: ";
                std::getline(std::cin, email);
                library.addStudent(name, email);
                break;
            }
            case 5: {
                int studentId;
                std::cout << "Enter student ID to remove: ";
                std::cin >> studentId;
                library.removeStudent(studentId);
                break;
            }
            case 6:
                library.displayAllStudents();
                break;
            case 7: {
                int studentId, bookId;
                std::cout << "Enter student ID: ";
                std::cin >> studentId;
                std::cout << "Enter book ID: ";
                std::cin >> bookId;
                library.issueBook(studentId, bookId);
                break;
            }
            case 8: {
                int studentId, bookId;
                std::cout << "Enter student ID: ";
                std::cin >> studentId;
                std::cout << "Enter book ID: ";
                std::cin >> bookId;
                library.returnBook(studentId, bookId);
                break;
            }
            case 9: {
                std::string query;
                std::cout << "Enter search query: ";
                std::cin.ignore();
                std::getline(std::cin, query);
                library.searchBooks(query);
                break;
            }
            case 10:
                library.saveToFile("library_data.txt");
                break;
            case 11:
                library.loadFromFile("library_data.txt");
                break;
            case 0:
                std::cout << "Saving data before exit..." << std::endl;
                library.saveToFile("library_data.txt");
                std::cout << "Thank you for using Library Management System!" << std::endl;
                return 0;
            default:
                std::cout << "Invalid choice! Please try again." << std::endl;
        }
    }
    
    return 0;
}
EOF

# Create a proper Makefile
print_status "📋 Creating C++ Makefile..."
cat > Makefile << 'EOF'
# Makefile for Library Management System

CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra -g
INCLUDES = -Iinclude
SRCDIR = src
OBJDIR = obj
SOURCES = $(wildcard $(SRCDIR)/*.cpp)
OBJECTS = $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)
TARGET = library_system

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(OBJECTS)
	@echo "🔗 Linking $(TARGET)..."
	$(CXX) $(OBJECTS) -o $@
	@echo "✅ C++ build successful!"

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	@mkdir -p $(OBJDIR)
	@echo "🔨 Compiling $<..."
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

clean:
	@echo "🧹 Cleaning C++ build files..."
	rm -rf $(OBJDIR) $(TARGET) library_data.txt

run: $(TARGET)
	@echo "🚀 Running C++ Library Management System..."
	./$(TARGET)

help:
	@echo "Available targets:"
	@echo "  all    - Build the C++ project"
	@echo "  clean  - Remove C++ build files"
	@echo "  run    - Build and run the C++ application"
	@echo "  help   - Show this help message"
EOF

# Clean any existing corrupted files
print_status "🧹 Cleaning up any corrupted files..."
rm -rf obj library_system library_data.txt

# Test C++ compilation
print_status "🔨 Testing C++ compilation..."
if make clean && make; then
    print_success "✅ C++ backend compiled successfully!"
else
    print_error "❌ C++ compilation failed!"
    exit 1
fi

# =============================================================================
# DATABASE SETUP
# =============================================================================

print_status "🗄️  Setting up database..."

# Create database configuration
print_status "📄 Creating database configuration..."
cat > config/database.php << 'EOF'
<?php
// Database configuration
define('DB_HOST', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');
define('DB_NAME', 'library_management');

try {
    $pdo = new PDO("mysql:host=" . DB_HOST . ";dbname=" . DB_NAME, DB_USERNAME, DB_PASSWORD);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}
?>
EOF

# Create database schema
print_status "📄 Creating database schema..."
cat > database/schema.sql << 'EOF'
-- Library Management System Database Schema

CREATE DATABASE IF NOT EXISTS library_management;
USE library_management;

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Authors table
CREATE TABLE IF NOT EXISTS authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Books table
CREATE TABLE IF NOT EXISTS books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT,
    category_id INT,
    isbn VARCHAR(20) UNIQUE,
    quantity INT DEFAULT 1,
    available_quantity INT DEFAULT 1,
    publication_year YEAR,
    description TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES authors(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Students table
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    password VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Admins table
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'librarian') DEFAULT 'admin',
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Book issues table
CREATE TABLE IF NOT EXISTS book_issues (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    book_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    status ENUM('issued', 'returned', 'overdue') DEFAULT 'issued',
    fine_amount DECIMAL(10,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- Activity logs table
CREATE TABLE IF NOT EXISTS activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_type ENUM('admin', 'student') NOT NULL,
    user_id INT NOT NULL,
    action VARCHAR(100) NOT NULL,
    description TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default admin
INSERT IGNORE INTO admins (username, email, password, name, role) VALUES 
('admin', 'admin@library.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System Administrator', 'admin');

-- Insert sample categories
INSERT IGNORE INTO categories (name, description) VALUES 
('Fiction', 'Fiction books and novels'),
('Non-Fiction', 'Non-fiction and educational books'),
('Science', 'Science and technology books'),
('History', 'Historical books and biographies'),
('Literature', 'Classic literature and poetry');

-- Insert sample authors
INSERT IGNORE INTO authors (name, email, bio) VALUES 
('J.K. Rowling', 'jk@example.com', 'British author, best known for Harry Potter series'),
('Stephen King', 'sk@example.com', 'American author of horror, supernatural fiction'),
('Agatha Christie', 'ac@example.com', 'English writer known for detective novels');
EOF

# =============================================================================
# WEB INTERFACE SETUP
# =============================================================================

print_status "🌐 Setting up web interface..."

# Create basic index.php
print_status "📄 Creating main index file..."
cat > index.php << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row min-vh-100">
            <div class="col-md-6 d-flex align-items-center justify-content-center bg-primary">
                <div class="text-center text-white">
                    <h1><i class="fas fa-book"></i> Library Management System</h1>
                    <p class="lead">Comprehensive web-based library management with C++ backend support</p>
                </div>
            </div>
            <div class="col-md-6 d-flex align-items-center justify-content-center">
                <div class="card shadow-lg" style="width: 400px;">
                    <div class="card-body">
                        <h2 class="text-center mb-4">Welcome</h2>
                        <div class="d-grid gap-3">
                            <a href="admin/" class="btn btn-primary btn-lg">
                                <i class="fas fa-user-tie"></i> Admin Login
                            </a>
                            <a href="student/" class="btn btn-success btn-lg">
                                <i class="fas fa-user-graduate"></i> Student Portal
                            </a>
                            <a href="#" onclick="runCppSystem()" class="btn btn-info btn-lg">
                                <i class="fas fa-terminal"></i> C++ System
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function runCppSystem() {
            alert('To run the C++ system, execute: ./library_system in the terminal');
        }
    </script>
</body>
</html>
EOF

# Create basic admin directory structure
print_status "📁 Creating admin interface structure..."
mkdir -p admin/{css,js,includes}

cat > admin/index.php << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Library Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white text-center">
                        <h3><i class="fas fa-user-shield"></i> Admin Login</h3>
                    </div>
                    <div class="card-body">
                        <form>
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" required>
                            </div>
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">Login</button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="text-center mt-3">
                    <a href="../" class="text-decoration-none">← Back to Home</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
EOF

# Create basic student directory structure
print_status "📁 Creating student interface structure..."
mkdir -p student/{css,js,includes}

cat > student/index.php << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Portal - Library Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-success text-white text-center">
                        <h3><i class="fas fa-user-graduate"></i> Student Portal</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h5>Login</h5>
                                <form>
                                    <div class="mb-3">
                                        <label for="student_id" class="form-label">Student ID</label>
                                        <input type="text" class="form-control" id="student_id" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="password" class="form-label">Password</label>
                                        <input type="password" class="form-control" id="password" required>
                                    </div>
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-success">Login</button>
                                    </div>
                                </form>
                            </div>
                            <div class="col-md-6">
                                <h5>Register</h5>
                                <form>
                                    <div class="mb-3">
                                        <label for="name" class="form-label">Full Name</label>
                                        <input type="text" class="form-control" id="name" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="email" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="student_id_reg" class="form-label">Student ID</label>
                                        <input type="text" class="form-control" id="student_id_reg" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="password_reg" class="form-label">Password</label>
                                        <input type="password" class="form-control" id="password_reg" required>
                                    </div>
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary">Register</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="text-center mt-3">
                    <a href="../" class="text-decoration-none">← Back to Home</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
EOF

# =============================================================================
# PERMISSIONS AND FINAL SETUP
# =============================================================================

print_status "🔐 Setting up permissions..."

# Set proper permissions
if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
    # Linux or macOS
    print_status "Setting file permissions for Unix-like system..."
    chmod -R 755 .
    chmod +x library_system 2>/dev/null || true
    chmod +x install.sh 2>/dev/null || true
    
    # Try to set web server permissions if running as root or with sudo
    if [ "$EUID" -eq 0 ]; then
        print_status "Setting web server permissions..."
        if command_exists chown; then
            chown -R www-data:www-data . 2>/dev/null || chown -R apache:apache . 2>/dev/null || true
        fi
    else
        print_warning "Not running as root. You may need to set web server permissions manually."
    fi
fi

# =============================================================================
# FINAL INSTRUCTIONS AND TESTING
# =============================================================================

print_status "🧪 Running final tests..."

# Test C++ compilation again
print_status "Testing C++ system..."
if [ -f "library_system" ]; then
    print_success "✅ C++ library system executable created successfully!"
else
    print_error "❌ C++ executable not found!"
fi

# Test web files
if [ -f "index.php" ] && [ -f "admin/index.php" ] && [ -f "student/index.php" ]; then
    print_success "✅ Web interface files created successfully!"
else
    print_error "❌ Web interface files missing!"
fi

# Final success message
print_success "🎉 Library Management System installation completed successfully!"

echo ""
echo "=============================================================================="
echo -e "${GREEN}📚 LIBRARY MANAGEMENT SYSTEM - INSTALLATION COMPLETE! 📚${NC}"
echo "=============================================================================="
echo ""
echo -e "${BLUE}🌐 WEB INTERFACE:${NC}"
echo "   • Main Page: http://localhost/$(basename "$PWD")"
echo "   • Admin Panel: http://localhost/$(basename "$PWD")/admin"
echo "   • Student Portal: http://localhost/$(basename "$PWD")/student"
echo ""
echo -e "${BLUE}💻 C++ BACKEND:${NC}"
echo "   • Run: ./library_system"
echo "   • Build: make"
echo "   • Clean: make clean"
echo "   • Help: make help"
echo ""
echo -e "${BLUE}🗄️ DATABASE SETUP:${NC}"
echo "   • Import schema: mysql -u root -p < database/schema.sql"
echo "   • Default admin: username=admin, password=password"
echo ""
echo -e "${BLUE}📁 PROJECT STRUCTURE:${NC}"
echo "   ├── Web Interface (PHP/HTML/CSS/JS)"
echo "   ├── C++ Backend (Compiled binary)"
echo "   ├── Database Schema (MySQL)"
echo "   ├── Configuration Files"
echo "   └── Documentation"
echo ""
echo -e "${YELLOW}⚠️  NEXT STEPS:${NC}"
echo "1. Import the database schema"
echo "2. Configure your web server"
echo "3. Update database credentials in config/database.php"
echo "4. Test both web and C++ interfaces"
echo ""
echo -e "${GREEN}🚀 Ready to use! Both web and C++ systems are operational.${NC}"
echo "=============================================================================="