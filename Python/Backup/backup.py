##################################################

from datetime import datetime

import colorama
import os
import pymysql
import requests
import shutil
import subprocess
import sys
import time

if os.name == 'nt':
    colorama.just_fix_windows_console()

##################################################

cwd = os.getcwd()
mysqlcnf = f'{cwd}/mysql.cnf'
temp_dir = f'{cwd}/tmp'

mysql_hostname = '127.0.0.1'
mysql_port = 3306
mysql_username = 'backup'
mysql_password = 'backup'

telegram_chat_id = 0
telegram_token = 0

##################################################

windows_paths = {
    '7zip': 'C:/Program Files/7-Zip',
    'mysql': 'C:/Program Files/MySQL/MySQL Server 8.4',
    'megacmd': 'C:/Users/Revision/AppData/Local/MEGAcmd'
}

##################################################

now = datetime.now()
timestamp = now.strftime("%Y-%m-%d_%H-%M")

archives = []

##################################################

def PrintColor(string, color):
    print(f'{color}{string}{colorama.Style.RESET_ALL}')

def PrintHeader(string):
    PrintColor(string, colorama.Fore.GREEN)

def PrintProgress(string):
    PrintColor(string, colorama.Fore.YELLOW)

def PrintError(string):
    PrintColor(string, colorama.Fore.RED)

def HandleError(msg):
    if telegram_chat_id != 0 and telegram_token != 0:
        url = f'https://api.telegram.org/bot{telegram_token}/sendMessage?chat_id={telegram_chat_id}&text=[Backup]: {msg}'
        requests.get(url).json()

    if os.path.exists(mysqlcnf):
        os.remove(mysqlcnf)

    PrintError(msg)
    sys.exit(1)

##################################################

def CreateFolder(folder):
    if not os.path.isdir(folder):
        os.mkdir(folder, 0o777)

def RemoveFolder(dir):
    if os.path.exists(dir):
        shutil.rmtree(dir)

def WriteToFile(file, text):
    file = open(file, 'w')
    file.write(text)
    file.close()

def RemoveFile(file):
    if os.path.exists(file):
        os.remove(file)

def ExportTables():
    connect = pymysql.connect(host=mysql_hostname, user=mysql_username, password=mysql_password, db='information_schema')
    cursor = connect.cursor()
    cursor.execute('SELECT SCHEMA_NAME FROM SCHEMATA WHERE SCHEMA_NAME NOT IN ("information_schema", "mysql", "performance_schema", "sys", "phpmyadmin", "aowow") AND SCHEMA_NAME NOT LIKE "%world%" AND SCHEMA_NAME NOT LIKE "%playerbots%" AND SCHEMA_NAME NOT LIKE "spells_%"')

    databases = []
    for db in cursor.fetchall():
        databases.append(db[0])

    for database in databases:
        PrintHeader(f'Exporting {database}...')
        cursor.execute(f'SHOW TABLES FROM {database}')
        for table in cursor.fetchall():
            name = table[0]
            dir = f'{temp_dir}/{database}'

            CreateFolder(dir)

            PrintProgress(f'Exporting {name}')
            try:
                subprocess.run(f'{f'"{windows_paths['mysql']}/bin/mysqldump.exe"' if os.name == 'nt' else 'mysqldump'} --defaults-extra-file={mysqlcnf} --hex-blob {database} {name} > {dir}/{name}.sql', shell=True, check=True)
            except:
                HandleError(f'An error occurred while exporting the tables for {database}')

        PrintHeader(f'Finished exporting {database}...')

    cursor.close()
    connect.close()

def CreateArchive():
    PrintHeader('Creating archive...')
    PrintProgress(f'Creating {timestamp}.{'7z' if os.name == 'nt' else 'tar.gz'}')
    try:
        subprocess.run(f'"{windows_paths['7zip']}/7z.exe" a -mx9 -md2048m -mmt2 {cwd}/{timestamp}.7z {cwd}/tmp/*' if os.name == 'nt' else f'cd {temp_dir} && tar -czvf {cwd}/{timestamp}.tar.gz * > /dev/null 2>&1', shell=True, check=True)
    except:
        HandleError('An error occurred while creating the archive')
    PrintHeader('Finished creating archive...')

def GetFiles():
    process = subprocess.Popen(f'"{windows_paths['megacmd']}/MEGAclient.exe" ls /backup/database' if os.name == 'nt' else 'mega-ls /backup/database', shell=True, stdin=None, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    result = process.stdout.readlines()
    if len(result) >= 1:
        for line in result:
            archives.append(line.decode('utf-8'))

def UploadToCloud():
    PrintHeader('Uploading archive...')

    PrintProgress(f'Uploading {timestamp}.tar.gz')
    try:
        subprocess.run(f'"{windows_paths['megacmd']}/MEGAclient.exe" put {timestamp}.7z /backup/database' if os.name == 'nt' else f'mega-put {cwd}/{timestamp}.tar.gz /backup/database > /dev/null 2>&1', shell=True, check=True)
    except:
        HandleError('An error occurred while uploading the archive')

    PrintHeader('Finished uploading archive...')

def RemoveOld():
    if len(archives) > 72:
        PrintHeader('Deleting old archives...')
        for i in range(len(archives) - 72):
            PrintProgress(f'Deleting {archives[i]}')
            try:
                subprocess.run(f'"{windows_paths['megacmd']}/MEGAclient.exe" rm -r -f /backup/database/{archives[i]}' if os.name == 'nt' else f'mega-rm -r -f /backup/database/{archives[i]} > /dev/null 2>&1', shell=True, check=True)
            except:
                HandleError('An error occurred while deleting old backups')
        PrintHeader('Finished deleting old archives...')

##################################################

os.system('cls' if os.name == 'nt' else 'clear')
WriteToFile(mysqlcnf, f'[client]\nhost="{mysql_hostname}"\nport="{mysql_port}"\nuser="{mysql_username}"\npassword="{mysql_password}"')
RemoveFolder(temp_dir)
CreateFolder(temp_dir)
ExportTables()
CreateArchive()
UploadToCloud()
GetFiles()
RemoveOld()
RemoveFolder(temp_dir)
RemoveFile(f'{cwd}/{timestamp}.{'7z' if os.name == 'nt' else 'tar.gz'}')
RemoveFile(mysqlcnf)
