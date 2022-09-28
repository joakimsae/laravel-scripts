#!/usr/bin/bash
echo "Laravel installer."
echo -n "Name of new project? "
read name
echo -n "Tailwind? [y] "
read tailwind
echo -n "Livewire? [y] "
read livewire

if [$name == '']; then
        echo "no name supplied."
else
        echo "Creating new project $name..."
        composer create-project laravel/laravel $name || { echo 'Could not create project!' >&2; exit 1; }
        cd $name
        touch database/database.sqlite || { echo 'Unable to create database.' >&2; exit 1; }
        npm install || { echo 'Unable to install npm.' >&2; exit 1; }
        composer require laravel/breeze --dev || { echo 'Unable to install laravel breeze.' >&2; exit 1; }
        php artisan breeze:install || { echo 'Unable to install laravel breeze 2.' >&2; exit 1; }
        npm install || { echo 'Unable to install npm the second time.' >&2; exit 1; }
        php artisan storage:link || { echo 'Unable to create storage link.' >&2; exit 1; }
        if [$tailwind = ''] || [$tailwind -eq 'y']
        then
                npm install -D tailwindcss postcss autoprefixer
                npx tailwindcss init -p
                echo "TailwindCSS installed! Add the paths to the tailwind.config.js file:"
                echo 'module.exports = { content: [ "./resources/**/*.blade.php", "./resources/**/*.js", "./resources/**/*.vue", ],'
        fi

        if [$livewire = ''] || [$livewire -eq 'y']
        then
                composer require livewire/livewire
                echo "************"
                echo "* Livewire *"
                echo "************"
                echo "Add the javascript on every page that will use livewire: in head: @livewireStyles, at end of body @livewireScripts"
                echo " "
       fi

        echo "*************"
        echo "* Alpine.js *"
        echo "*************"
        echo 'Press any key to edit the layout file and add this to the head tag: <script src="//unpkg.com/alpinejs" defer></script>'
        read yes
        pico resources/views/layouts/app.blade.php
        echo " "


        echo "*************"
        echo "* Database *"
        echo "*************"
        echo "Press any key to edit the .env file. Connect the database by removing all DB_ lines and adding 'DB_CONNECTION=sqlite'"
        read yes
        pico .env
fi
