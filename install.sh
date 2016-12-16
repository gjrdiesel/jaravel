#!/usr/bin/env bash

if [ -z "$1" ]
then
    echo "Please specify a project name."
    exit 255
fi

echo "1) Cloning directory.."
git clone git@github.com:gjrdiesel/jaravel.git "$1"
cd "$1"

echo "2) Removing package .git folder"
rm -rf .git

echo "3) Installing packages..."
composer install

echo "4) Copying default .env file..."
sed "s|DB_DATABASE=|DB_DATABASE=$1|" .env.example > .env

echo "5) Generating new application key..."
php artisan key:generate

echo "6) Starting PhpStorm"
/Applications/PhpStorm.app/Contents/MacOS/phpstorm $(pwd)

echo "7) Opening chrome window"
open "http://$1.dev"

echo "8) Installing npm packages..."
yarn install

echo "9) Creating database..."
mysql -u root -p -e "create database $1"

echo "10) Running migrations..."
php artisan migrate

echo "11) Initialising new git repo..."
git init

echo "12) Writing initial commit..."
git add .
git commit -m "Initial commit"

echo -e "\n\n"
echo "Done with the the entire install! Good luck."

rm install.sh