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
            directory = os.path.join(directory, "outDEBUG")
            file_name = "outputDEBUG.txt"
            content = "Hi hi hi 1 debug!"
        elif mode == "RELEASE":
            directory = os.path.join(directory, "outRELEASE")
            file_name = "outputRELEASE.txt"
            content = "Hi hi hi 1 release!"
        else:
            print("Неверный режим. Используйте DEBUG или RELEASE.")
            return

        os.makedirs(directory, exist_ok=True)
        print(f"Папка {directory} была создана или уже существует.")
        
        file_path = os.path.join(directory, file_name)
        
        with open(file_path, "w") as file:
            file.write(content)

        print(f"Файл успешно создан и сохранен в {file_path}")
    except Exception as e:
        print(f"Произошла ошибка: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Создание текстового файла с заданным содержимым в указанной папке.")
    parser.add_argument("directory", type=str, help="Путь к папке, в которой будет создан файл.")
    parser.add_argument("mode", type=str, choices=["DEBUG", "RELEASE"], help="Режим работы: DEBUG или RELEASE.")
    
    args = parser.parse_args()
    
    # Выполнение команды sudo apt update перед созданием файла
    run_apt_update()
    
    # Создание текстового файла
    create_text_file(args.directory, args.mode)
