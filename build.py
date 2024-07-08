import os
import argparse
import subprocess

def test_sudo():
    try:
        subprocess.run(["sudo", "ls"], check=True)
        print("sudo works")
    except subprocess.CalledProcessError as e:
        print(f"sudo error: {e}")

def create_text_file(directory, mode):
    try:
        if mode == "DEBUG":
            debug_directory = os.path.join(directory, "outDEBUG")
            release_directory = os.path.join(directory, "outRELEASE")
            debug_file_name = "outputDEBUG.txt"
            release_file_name = "outputRELEASE.txt"
            debug_content = "Hi hi hi debug!"
            release_content = "Hi hi hi release!"
            
            # Create directories if they don't exist
            os.makedirs(debug_directory, exist_ok=True)
            os.makedirs(release_directory, exist_ok=True)
            print(f"Папки {debug_directory} и {release_directory} были созданы или уже существуют.")
            
            # Define file paths
            debug_file_path = os.path.join(debug_directory, debug_file_name)
            release_file_path = os.path.join(release_directory, release_file_name)
            
            # Create and write to files
            with open(debug_file_path, "w") as debug_file:
                debug_file.write(debug_content)
            with open(release_file_path, "w") as release_file:
                release_file.write(release_content)
            
            print(f"Файлы успешно созданы и сохранены в {debug_file_path} и {release_file_path}")
            
            # Create an additional file next to the outDEBUG directory
            adjacent_file_path = os.path.join(directory, "outputDEBUG_adjacent.txt")
            with open(adjacent_file_path, "w") as adjacent_file:
                adjacent_file.write(debug_content)
                
            print(f"Дополнительный файл успешно создан и сохранен в {adjacent_file_path}")

        elif mode == "RELEASE":
            directory = os.path.join(directory, "outRELEASE")
            file_name = "outputRELEASE.txt"
            content = "Hi hi hi release!"
            os.makedirs(directory, exist_ok=True)
            print(f"Папка {directory} была создана или уже существует.")
            file_path = os.path.join(directory, file_name)
            with open(file_path, "w") as file:
                file.write(content)
            print(f"Файл успешно создан и сохранен в {file_path}")
        else:
            print("Неверный режим. Используйте DEBUG или RELEASE.")
            return

    except Exception as e:
        print(f"Произошла ошибка: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Создание текстового файла с заданным содержимым в указанной папке.")
    parser.add_argument("directory", type=str, help="Путь к папке, в которой будет создан файл.")
    parser.add_argument("mode", type=str, choices=["DEBUG", "RELEASE"], help="Режим работы: DEBUG или RELEASE.")
    
    args = parser.parse_args()
    
    # Выполнение команды sudo apt update перед созданием файла
    test_sudo()
    
    # Создание текстового файла
    create_text_file(args.directory, args.mode)
