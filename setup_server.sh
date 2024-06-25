#!/bin/bash
#
# Script Name: setup_server.sh
# Description: This script installs all the necessary packages and extensions for LAMP.
# Author: Abdul Gaffar
# Contact: abdul.nawab@datamatics.com
# Date: June 25, 2024
#

# Function to print the message
print_message() {
    echo "---------------------------------"
    echo "$1"
    echo "---------------------------------"
}

# Function to prompt for input
prompt_for_input() {
    read -p "$1: " input
    echo $input
}

# Update package list
print_message "Updating package list"
sudo apt-get update

# Install Apache2
print_message "Installing Apache2"
sudo apt-get install -y apache2

# Add PHP repository and install PHP 8.1
print_message "Installing PHP-8.1 and required extensions"
sudo add-apt-repository ppa:ondrej/php -y

# sudo add-apt-repository --keyserver keyserver.ubuntu.com:80 ppa:ondrej/apache -y
# echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list

sudo apt-get update
sudo apt-get install -y php8.1 php8.1-cli php8.1-common php8.1-fpm php8.1-mysql php8.1-xml php8.1-mbstring php8.1-curl php8.1-zip php8.1-gd libapache2-mod-php8.1

# Install MySQL
print_message "Installing MySQL"
sudo apt-get install -y mysql-server

# Start MySQL
sudo service mysql start
# Secure MySQL installation (interactive)
# Run mysql_secure_installation using expect script
# print_message "Running mysql_secure_installation, Please select the appropriate options"
# sudo mysql_secure_installation

# Install Adminer
print_message "Installing Adminer"
sudo mkdir -p /usr/share/adminer
sudo wget -O /usr/share/adminer/adminer.php https://www.adminer.org/latest.php
echo "Alias /adminer.php /usr/share/adminer/adminer.php" | sudo tee /etc/apache2/conf-available/adminer.conf
sudo a2enconf adminer.conf
print_message "Restarting Apache2 to apply changes"
sudo service apache2 restart

# Enable necessary Apache modules and restart Apache
sudo a2enmod php8.1
sudo service apache2 restart

# Function to install Terminus
install_terminus() {
  print_message "Installing Terminus..."
  # Add your Terminus installation commands here
  mkdir ~/terminus
  curl -L https://github.com/pantheon-systems/terminus/releases/download/3.1.4/terminus.phar --output ~/terminus/terminus
  chmod +x ~/terminus/terminus
  ln -s ~/terminus/terminus /usr/local/bin/terminus
  echo "Terminus installed successfully."
  # Prompt for machine token
  read -p "Please enter your Terminus machine token: " machine_token
  terminus auth:login --machine-token=$machine_token
  echo "Authenticated with Terminus."
}

# Prompt the user
read -p "Do you want to install Terminus? (yes/no): " user_input

# Check user input
if [[ "$user_input" == "yes" || "$user_input" == "y" ]]; then
  install_terminus
else
  echo "Skipping Terminus installation."
fi

# Install Drush globally
print_message "Installing Drush globally"
# Install Drush using Composer.
composer global require drush/drush
# Making drush as global command
sudo ln -s ~/.config/composer/vendor/bin/drush /usr/local/bin/drush


print_message "Setup Completed!."
echo "You can now access Adminer at http://your_server_ip/adminer.php"
echo "Feel free to connect: abdul.nawab@datamatics.com"

# chmod +x setup_server.sh
# ./setup_server.sh
