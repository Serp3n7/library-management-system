#include "../include/library.h"
#include <iostream>
#include <string>

void displayMenu() {
    std::cout << "\n=== Library Management System ===" << std::endl;
    std::cout << "1. Add Book" << std::endl;
    std::cout << "2. Remove Book" << std::endl;
    std::cout << "3. Search Books" << std::endl;
    std::cout << "4. Display All Books" << std::endl;
    std::cout << "5. Register Student" << std::endl;
    std::cout << "6. Issue Book" << std::endl;
    std::cout << "7. Return Book" << std::endl;
    std::cout << "8. Display Issued Books" << std::endl;
    std::cout << "9. Save Data" << std::endl;
    std::cout << "10. Load Data" << std::endl;
    std::cout << "0. Exit" << std::endl;
    std::cout << "Enter your choice: ";
}

int main() {
    Library library;
    int choice;
    
    // Load existing data
    library.loadFromFile("data/library.db");
    
    do {
        displayMenu();
        std::cin >> choice;
        std::cin.ignore(); // Clear input buffer
        
        switch (choice) {
            case 1: {
                std::string title, author, isbn;
                std::cout << "Enter book title: ";
                std::getline(std::cin, title);
                std::cout << "Enter author name: ";
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
            
            case 3: {
                std::string query;
                std::cout << "Enter search query: ";
                std::getline(std::cin, query);
                
                auto results = library.searchBooks(query);
                std::cout << "\nSearch Results:" << std::endl;
                for (const auto& book : results) {
                    std::cout << "ID: " << book.getId() 
                              << ", Title: " << book.getTitle()
                              << ", Author: " << book.getAuthor() << std::endl;
                }
                break;
            }
            
            case 4:
                library.displayAllBooks();
                break;
                
            case 5: {
                std::string studentId, name, email;
                std::cout << "Enter student ID: ";
                std::getline(std::cin, studentId);
                std::cout << "Enter student name: ";
                std::getline(std::cin, name);
                std::cout << "Enter email: ";
                std::getline(std::cin, email);
                
                library.registerStudent(studentId, name, email);
                break;
            }
            
            case 6: {
                std::string studentId;
                int bookId;
                std::cout << "Enter student ID: ";
                std::getline(std::cin, studentId);
                std::cout << "Enter book ID: ";
                std::cin >> bookId;
                
                library.issueBook(studentId, bookId);
                break;
            }
            
            case 7: {
                std::string studentId;
                int bookId;
                std::cout << "Enter student ID: ";
                std::getline(std::cin, studentId);
                std::cout << "Enter book ID: ";
                std::cin >> bookId;
                
                library.returnBook(studentId, bookId);
                break;
            }
            
            case 8:
                library.displayIssuedBooks();
                break;
                
            case 9:
                library.saveToFile("data/library.db");
                break;
                
            case 10:
                library.loadFromFile("data/library.db");
                break;
                
            case 0:
                std::cout << "Saving data and exiting..." << std::endl;
                library.saveToFile("data/library.db");
                break;
                
            default:
                std::cout << "Invalid choice! Please try again." << std::endl;
        }
        
    } while (choice != 0);
    
    return 0;
}
