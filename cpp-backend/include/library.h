#ifndef LIBRARY_H
#define LIBRARY_H

#include <string>
#include <vector>
#include <map>

class Book {
private:
    int id;
    std::string title;
    std::string author;
    std::string isbn;
    bool available;

public:
    Book(int id, const std::string& title, const std::string& author, const std::string& isbn);
    
    // Getters
    int getId() const { return id; }
    std::string getTitle() const { return title; }
    std::string getAuthor() const { return author; }
    std::string getIsbn() const { return isbn; }
    bool isAvailable() const { return available; }
    
    // Setters
    void setAvailable(bool status) { available = status; }
    void setTitle(const std::string& title) { this->title = title; }
    void setAuthor(const std::string& author) { this->author = author; }
};

class Student {
private:
    std::string studentId;
    std::string name;
    std::string email;
    std::vector<int> issuedBooks;

public:
    Student(const std::string& id, const std::string& name, const std::string& email);
    
    // Getters
    std::string getStudentId() const { return studentId; }
    std::string getName() const { return name; }
    std::string getEmail() const { return email; }
    std::vector<int> getIssuedBooks() const { return issuedBooks; }
    
    // Book management
    void issueBook(int bookId);
    void returnBook(int bookId);
    bool hasBook(int bookId) const;
};

class Library {
private:
    std::map<int, Book> books;
    std::map<std::string, Student> students;
    int nextBookId;

public:
    Library();
    
    // Book operations
    void addBook(const std::string& title, const std::string& author, const std::string& isbn);
    void removeBook(int bookId);
    Book* findBook(int bookId);
    std::vector<Book> searchBooks(const std::string& query);
    
    // Student operations
    void registerStudent(const std::string& studentId, const std::string& name, const std::string& email);
    Student* findStudent(const std::string& studentId);
    
    // Issue/Return operations
    bool issueBook(const std::string& studentId, int bookId);
    bool returnBook(const std::string& studentId, int bookId);
    
    // Display functions
    void displayAllBooks();
    void displayIssuedBooks();
    
    // File operations
    void saveToFile(const std::string& filename);
    void loadFromFile(const std::string& filename);
};

#endif
