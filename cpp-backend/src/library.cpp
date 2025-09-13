#include "../include/library.h"
#include <iostream>
#include <fstream>
#include <algorithm>
#include <sstream>

// Book implementation
Book::Book(int id, const std::string& title, const std::string& author, const std::string& isbn)
    : id(id), title(title), author(author), isbn(isbn), available(true) {}

// Student implementation
Student::Student(const std::string& id, const std::string& name, const std::string& email)
    : studentId(id), name(name), email(email) {}

void Student::issueBook(int bookId) {
    issuedBooks.push_back(bookId);
}

void Student::returnBook(int bookId) {
    auto it = std::find(issuedBooks.begin(), issuedBooks.end(), bookId);
    if (it != issuedBooks.end()) {
        issuedBooks.erase(it);
    }
}

bool Student::hasBook(int bookId) const {
    return std::find(issuedBooks.begin(), issuedBooks.end(), bookId) != issuedBooks.end();
}

// Library implementation
Library::Library() : nextBookId(1) {}

void Library::addBook(const std::string& title, const std::string& author, const std::string& isbn) {
    books[nextBookId] = Book(nextBookId, title, author, isbn);
    std::cout << "Book added with ID: " << nextBookId << std::endl;
    nextBookId++;
}

void Library::removeBook(int bookId) {
    auto it = books.find(bookId);
    if (it != books.end()) {
        books.erase(it);
        std::cout << "Book removed successfully." << std::endl;
    } else {
        std::cout << "Book not found." << std::endl;
    }
}

Book* Library::findBook(int bookId) {
    auto it = books.find(bookId);
    return (it != books.end()) ? &(it->second) : nullptr;
}

std::vector<Book> Library::searchBooks(const std::string& query) {
    std::vector<Book> results;
    for (const auto& pair : books) {
        const Book& book = pair.second;
        if (book.getTitle().find(query) != std::string::npos ||
            book.getAuthor().find(query) != std::string::npos) {
            results.push_back(book);
        }
    }
    return results;
}

void Library::registerStudent(const std::string& studentId, const std::string& name, const std::string& email) {
    students[studentId] = Student(studentId, name, email);
    std::cout << "Student registered successfully with ID: " << studentId << std::endl;
}

Student* Library::findStudent(const std::string& studentId) {
    auto it = students.find(studentId);
    return (it != students.end()) ? &(it->second) : nullptr;
}

bool Library::issueBook(const std::string& studentId, int bookId) {
    Book* book = findBook(bookId);
    Student* student = findStudent(studentId);
    
    if (book && student && book->isAvailable()) {
        book->setAvailable(false);
        student->issueBook(bookId);
        std::cout << "Book issued successfully to " << student->getName() << std::endl;
        return true;
    }
    
    std::cout << "Failed to issue book. Check availability and student ID." << std::endl;
    return false;
}

bool Library::returnBook(const std::string& studentId, int bookId) {
    Book* book = findBook(bookId);
    Student* student = findStudent(studentId);
    
    if (book && student && student->hasBook(bookId)) {
        book->setAvailable(true);
        student->returnBook(bookId);
        std::cout << "Book returned successfully." << std::endl;
        return true;
    }
    
    std::cout << "Failed to return book. Check book ID and student records." << std::endl;
    return false;
}

void Library::displayAllBooks() {
    std::cout << "\n=== All Books ===" << std::endl;
    std::cout << "ID\tTitle\t\tAuthor\t\tISBN\t\tStatus" << std::endl;
    std::cout << "--------------------------------------------------------" << std::endl;
    
    for (const auto& pair : books) {
        const Book& book = pair.second;
        std::cout << book.getId() << "\t" 
                  << book.getTitle() << "\t\t"
                  << book.getAuthor() << "\t\t"
                  << book.getIsbn() << "\t\t"
                  << (book.isAvailable() ? "Available" : "Issued") << std::endl;
    }
}

void Library::displayIssuedBooks() {
    std::cout << "\n=== Issued Books ===" << std::endl;
    
    for (const auto& studentPair : students) {
        const Student& student = studentPair.second;
        auto issuedBooks = student.getIssuedBooks();
        
        if (!issuedBooks.empty()) {
            std::cout << "Student: " << student.getName() << " (ID: " << student.getStudentId() << ")" << std::endl;
            for (int bookId : issuedBooks) {
                Book* book = findBook(bookId);
                if (book) {
                    std::cout << "  - " << book->getTitle() << " by " << book->getAuthor() << std::endl;
                }
            }
            std::cout << std::endl;
        }
    }
}

void Library::saveToFile(const std::string& filename) {
    std::ofstream file(filename);
    if (file.is_open()) {
        // Save books
        file << "BOOKS" << std::endl;
        for (const auto& pair : books) {
            const Book& book = pair.second;
            file << book.getId() << "|" << book.getTitle() << "|" 
                 << book.getAuthor() << "|" << book.getIsbn() << "|" 
                 << book.isAvailable() << std::endl;
        }
        
        // Save students
        file << "STUDENTS" << std::endl;
        for (const auto& pair : students) {
            const Student& student = pair.second;
            file << student.getStudentId() << "|" << student.getName() << "|" 
                 << student.getEmail();
            
            auto issuedBooks = student.getIssuedBooks();
            for (int bookId : issuedBooks) {
                file << "|" << bookId;
            }
            file << std::endl;
        }
        
        file.close();
        std::cout << "Data saved to " << filename << std::endl;
    }
}

void Library::loadFromFile(const std::string& filename) {
    std::ifstream file(filename);
    if (file.is_open()) {
        std::string line;
        std::string section;
        
        while (std::getline(file, line)) {
            if (line == "BOOKS" || line == "STUDENTS") {
                section = line;
                continue;
            }
            
            if (section == "BOOKS") {
                std::istringstream iss(line);
                std::string token;
                std::vector<std::string> tokens;
                
                while (std::getline(iss, token, '|')) {
                    tokens.push_back(token);
                }
                
                if (tokens.size() >= 5) {
                    int id = std::stoi(tokens[0]);
                    books[id] = Book(id, tokens[1], tokens[2], tokens[3]);
                    books[id].setAvailable(tokens[4] == "1");
                    nextBookId = std::max(nextBookId, id + 1);
                }
            } else if (section == "STUDENTS") {
                std::istringstream iss(line);
                std::string token;
                std::vector<std::string> tokens;
                
                while (std::getline(iss, token, '|')) {
                    tokens.push_back(token);
                }
                
                if (tokens.size() >= 3) {
                    Student student(tokens[0], tokens[1], tokens[2]);
                    
                    // Load issued books
                    for (size_t i = 3; i < tokens.size(); i++) {
                        student.issueBook(std::stoi(tokens[i]));
                    }
                    
                    students[tokens[0]] = student;
                }
            }
        }
        
        file.close();
        std::cout << "Data loaded from " << filename << std::endl;
    }
}
