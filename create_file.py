import os
import argparse

def create_text_file(directory):
    try:
        # Создаем папку, если она не существует
        os.makedirs(directory, exist_ok=True)
        print(f"Папка {directory} была создана или уже существует.")
        
        # Путь к файлу
        file_path = os.path.join(directory, "output.txt")
        
        # Записываем текст в файл
        with open(file_path, "w") as file:
            file.write("Hi hi hi!")
        
        print(f"Файл успешно создан и сохранен в {file_path}")
    except Exception as e:
        print(f"Произошла ошибка: {e}")

if __name__ == "__main__":
    # Настраиваем парсер аргументов командной строки
    parser = argparse.ArgumentParser(description="Создание текстового файла с заданным содержимым в указанной папке.")
    parser.add_argument("directory", type=str, help="Путь к папке, в которой будет создан файл.")
    
    # Парсим аргументы
    args = parser.parse_args()
    
    # Вызываем функцию создания файла
    create_text_file(args.directory)
