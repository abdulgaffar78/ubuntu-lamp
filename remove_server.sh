#!/bin/bash

# Function to print the message
print_message() {
    echo "---------------------------------"
    echo "$1"
    echo "---------------------------------"
}

# Update package list
print_message "Updating package list"
sudo apt-get update

# Stop Apache2 and MySQL services
print_message "Stopping Apache2 and MySQL services"
sudo service apache2 stop
sudo service mysql stop

# Remove Apache2 and its dependencies
print_message "Removing Apache2 and its dependencies"
sudo apt-get remove --purge -y apache2 apache2-utils apache2-bin apache2.2-common
sudo apt-get autoremove -y
sudo apt-get autoclean

# Remove MySQL and its dependencies
print_message "Removing MySQL and its dependencies"
sudo apt-get remove --purge -y mysql-server mysql-client mysql-common
sudo apt-get autoremove -y
sudo apt-get autoclean
sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql

# Remove PHP 8.1 and its extensions
print_message "Removing PHP 8.1 and its extensions"
sudo apt-get remove --purge -y php8.1 php8.1-cli php8.1-common php8.1-fpm php8.1-mysql php8.1-xml php8.1-mbstring php8.1-curl php8.1-zip php8.1-gd libapache2-mod-php8.1
sudo apt-get autoremove -y
sudo apt-get autoclean
sudo rm -rf /etc/php/8.1

# Remove Adminer
print_message "Removing Adminer"
sudo rm -rf /usr/share/adminer
sudo rm -f /etc/apache2/conf-available/adminer.conf
sudo sudo a2disconf adminer
sudo service apache2 restart

# Clean up any remaining packages and configurations
print_message "Cleaning up remaining packages and configurations"
sudo apt-get autoremove -y
sudo apt-get autoclean

print_message "All specified packages have been removed."
