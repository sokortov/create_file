import os

def create_text_file(directory):
    # Проверяем, существует ли папка, если нет - создаем
    if not os.path.exists(directory):
        os.makedirs(directory)
        print(f"Папка {directory} была создана.")
    else:
        print(f"Папка {directory} уже существует.")
    
    # Путь к файлу
    file_path = os.path.join(directory, "output.txt")
    
    # Записываем текст в файл
    with open(file_path, "w") as file:
        file.write("Hi hi hi!")
    
    print(f"Файл успешно создан и сохранен в {file_path}")

if __name__ == "__main__":
    # Запрашиваем у пользователя путь к папке
    user_directory = input("Введите путь к папке: ")
    create_text_file(user_directory)

