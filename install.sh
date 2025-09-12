#!/bin/bash

echo "=== Library Management System Installer ==="

# Check if running on WSL
if ! grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    echo "Warning: This installer is optimized for WSL environment"
fi

# Check for required software
command -v apache2 >/dev/null 2>&1 || { 
    echo "Apache2 is required but not installed. Installing..."
    sudo apt update
    sudo apt install apache2 -y
}

command -v mysql >/dev/null 2>&1 || { 
    echo "MySQL is required but not installed. Installing..."
    sudo apt install mysql-server -y
}

command -v php >/dev/null 2>&1 || { 
    echo "PHP is required but not installed. Installing..."
    sudo apt install php libapache2-mod-php php-mysql -y
}

command -v g++ >/dev/null 2>&1 || { 
    echo "G++ is required but not installed. Installing..."
    sudo apt install build-essential -y
}

# Set up directory structure
echo "Setting up directory structure..."
sudo mkdir -p /var/www/html/library-management-system
sudo cp -r * /var/www/html/library-management-system/
sudo chown -R www-data:www-data /var/www/html/library-management-system
sudo chmod -R 755 /var/www/html/library-management-system

# Set up database
echo "Setting up database..."
sudo mysql -e "CREATE DATABASE IF NOT EXISTS library_management;"
sudo mysql library_management < setup.sql

# Compile C++ backend
echo "Compiling C++ backend..."
cd cpp-backend
mkdir -p obj data
make
cd ..

# Start services
echo "Starting services..."
sudo systemctl start apache2
sudo systemctl start mysql
sudo systemctl enable apache2
sudo systemctl enable mysql

echo "=== Installation Complete ==="
echo "Access the application at:"
echo "Admin Panel: http://localhost/library-management-system/admin/"
echo "Student Panel: http://localhost/library-management-system/student/"
echo ""
echo "Default Admin Login:"
echo "Email: admin@library.com"
echo "Password: admin123"
