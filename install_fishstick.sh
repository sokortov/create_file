#!/bin/bash

FISHSTICK_PATH="$HOME/Downloads/fishstick-blackband"
FISHSTICK_GIT_URL="https://github.com/Eyelights/fishstick-blackband"
S3_DEPENDENCIES_URLS = [
    "s3://wqerwerwqer/create_file/296/DEBUG.zip",
    "s3://wqerwerwqer/create_file/296/RELEASE.zip"
]

echo "Клонирование репозитория $FISHSTICK_GIT_URL в папку $FISHSTICK_PATH..."
git clone "$FISHSTICK_GIT_URL" "$FISHSTICK_PATH"

echo "Доступные ветки:"
git branch -r
echo "Введите имя ветки для клонирования:"
read -r BRANCH_NAME

git checkout "$BRANCH_NAME"

# Скачивание и распаковка файлов
for s3_url in "${files[@]}"; do
    file_name=$(basename "$S3_DEPENDENCIES_URLS")
    echo "Скачивание $file_name из S3..."
    if ! aws s3 cp "$S3_DEPENDENCIES_URLS" .; then
        echo "Ошибка при скачивании $file_name"
        continue
    fi
    echo "Распаковка $file_name..."
    if ! unzip -o "$file_name" -d .; then
        echo "Ошибка при распаковке $file_name. Возможно, файл поврежден или не является архивом."
    else
        echo "Удаление архива $file_name..."
        rm "$file_name"
    fi
done

echo "Скрипт завершен."
