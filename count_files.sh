#!/bin/bash
# Скрипт для підрахунку кількості файлів у директорії /etc, виключаючи каталоги та посилання.

file_count=$(find /etc -type f | wc -l)

# Виводимо результат
echo "Кількість файлів у директорії /etc: $file_count"
