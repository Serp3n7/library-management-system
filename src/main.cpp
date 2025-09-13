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
