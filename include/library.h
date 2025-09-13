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
