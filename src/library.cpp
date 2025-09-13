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
