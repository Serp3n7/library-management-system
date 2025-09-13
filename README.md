# 📚 Library Management System

![Library Management System](https://socialify.git.ci/Serp3n7/library-management-system/image?custom_description=A+comprehensive+web-based+library+management+system+with+C%2B%2B+backend+support%2C+built+for+educational+purposes.&custom_language=C%2B%2B&description=1&font=JetBrains+Mono&forks=1&issues=1&language=1&name=1&owner=1&pulls=1&stargazers=1&theme=Dark)

A comprehensive web-based library management system with C++ backend support, designed for educational institutions to efficiently manage books, students, and library operations.

## ✨ Features

### 👨‍💼 Admin Panel
- 📊 **Dashboard** - Statistics and overview of library operations
- 🗂️ **Category Management** - Add, edit, delete, and toggle category status
- ✍️ **Author Management** - Complete author database management
- 📖 **Book Management** - Full book inventory with tracking capabilities
- 🔄 **Issue/Return System** - Streamlined book lending operations
- 👥 **Student Management** - Comprehensive student database with search
- 📝 **Activity Logging** - Detailed reporting and transaction history
- ⚙️ **Profile Management** - Admin profile and password management

### 🎓 Student Panel
- 📝 **Registration & Login** - Secure student account system
- 🏠 **Personal Dashboard** - Individual book statistics and overview
- 📚 **Current Books** - View issued books with due dates
- 📋 **Book History** - Complete transaction history
- 👤 **Profile Management** - Personal information updates
- 🔐 **Password Change** - Secure password modification
- ⚠️ **Overdue Notifications** - Automatic alerts for late returns

### ⚡ C++ Backend
- 🔧 **Object-Oriented Design** - Modern C++ architecture
- 💾 **File-Based Persistence** - Reliable data storage system
- 📚 **Book & Student Management** - Core library operations
- 🔄 **Issue/Return Operations** - Efficient transaction processing
- 🔍 **Search & Filter** - Advanced query capabilities

## 🛠️ Technology Stack

### Frontend
- ![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat-square&logo=html5&logoColor=white) HTML5
- ![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=flat-square&logo=css3&logoColor=white) CSS3
- ![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=javascript&logoColor=black) JavaScript
- ![Bootstrap](https://img.shields.io/badge/Bootstrap-7952B3?style=flat-square&logo=bootstrap&logoColor=white) Bootstrap 5.1.3
- ![Font Awesome](https://img.shields.io/badge/Font_Awesome-528DD7?style=flat-square&logo=fontawesome&logoColor=white) Font Awesome 6.0
- ![PHP](https://img.shields.io/badge/PHP-777BB4?style=flat-square&logo=php&logoColor=white) PHP 7.4+

### Backend
- ![PHP](https://img.shields.io/badge/PHP-777BB4?style=flat-square&logo=php&logoColor=white) PHP with PDO
- ![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white) MySQL/MariaDB
- ![C++](https://img.shields.io/badge/C++-00599C?style=flat-square&logo=cplusplus&logoColor=white) C++ with STL
- ![Apache](https://img.shields.io/badge/Apache-D22128?style=flat-square&logo=apache&logoColor=white) Apache Web Server

## 🚀 Installation

### Prerequisites
-  XAMPP/LAMP stack
- MySQL 5.7+ or MariaDB
- PHP 7.4+
- Apache 2.4+
- G++ compiler
- Make utility

### Setup Steps

1. **Clone the Repository**
   ```bash
   cd /var/www/html
   git clone https://github.com/Serp3n7/library-management-system.git
   cd library-management-system
   ```

2. **Database Setup**
   ```bash
   # Create database and import schema
   mysql -u root -p
   CREATE DATABASE library_management;
   USE library_management;
   SOURCE database/schema.sql;
   ```

3. **Configure Database Connection**
   ```php
   // config/database.php
   $host = 'localhost';
   $dbname = 'library_management';
   $username = 'your_username';
   $password = 'your_password';
   ```

4. **Compile C++ Backend**
   ```bash
   cd cpp-backend
   make
   # or
   g++ -o library_system *.cpp -std=c++11
   ```

5. **Set Permissions**
   ```bash
   sudo chown -R www-data:www-data /var/www/html/library-management-system
   sudo chmod -R 755 /var/www/html/library-management-system
   ```

6. **Start Services**
   ```bash
   sudo systemctl start apache2
   sudo systemctl start mysql
   ```

## 🎯 Usage

### Admin Access
1. Navigate to `http://localhost/library-management-system/admin`
2. Login with admin credentials
3. Access the comprehensive dashboard and management tools

### Student Access
1. Visit `http://localhost/library-management-system/student`
2. Register for a new account or login
3. Browse books, view issued items, and manage profile

## 📁 Project Structure

```
library-management-system/
├── admin/                 # Admin panel files
│   ├── dashboard.php
│   ├── books/
│   ├── students/
│   └── reports/
├── student/              # Student interface
│   ├── dashboard.php
│   ├── profile.php
│   └── books.php
├── cpp-backend/          # C++ backend system
│   ├── src/
│   ├── headers/
│   └── Makefile
├── config/               # Configuration files
├── database/             # Database schemas
├── assets/              # CSS, JS, images
└── includes/            # Common PHP includes
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built for educational purposes
- Inspired by real-world library management needs
- Thanks to all contributors and the open-source community

## 📞 Support

If you encounter any issues or have questions:

- 🐛 [Report Bug](https://github.com/Serp3n7/library-management-system/issues)
- 💡 [Request Feature](https://github.com/Serp3n7/library-management-system/issues)
- 📧 Contact: [Sumit Patil](sumitmpatil19@gmail.com)

---

<div align="center">

**⭐ Star this repository if you found it helpful!**

Made with ❤️ by [Sumit Patil](https://github.com/Serp3n7)

</div>
