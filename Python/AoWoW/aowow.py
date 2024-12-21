import colorama
import git
import hashlib
import os
import pymysql
import requests
import subprocess
import sys

if os.name == 'nt':
    colorama.just_fix_windows_console()

cwd = os.getcwd()
source = f'{cwd}/source'
mysqlcnf = f'{cwd}/mysql.cnf'

options = {
    'database.hostname': '127.0.0.1',
    'database.port': 3306,
    'database.username': 'aowow',
    'database.password': 'aowow',
    'database.aowow': 'aowow',
    'database.world': 'aowow_world',
    'git.use_ssh': True,
    'git.branch.aowow': 'progression',
    'git.branch.azerothcore': 'noisiver',
    'git.repository.aowow': 'noisiver/aowow',
    'git.repository.azerothcore': 'noisiver/azerothcore',
    'telegram.chat_id': 0,
    'telegram.token': 0
}

windows_paths = {
    'mysql': 'C:/Program Files/MySQL/MySQL Server 8.4'
}

folders = [
    f'{cwd}/sql',
    f'{cwd}/sql/world'
]

for folder in folders:
    if not os.path.isdir(folder):
        os.mkdir(folder, 0o777)

def PrintColor(string, color):
    print(f'{color}{string}{colorama.Style.RESET_ALL}')

def PrintHeader(string):
    PrintColor(string, colorama.Fore.GREEN)

def PrintProgress(string):
    PrintColor(string, colorama.Fore.YELLOW)

def PrintError(string):
    PrintColor(string, colorama.Fore.RED)

def PrintArgument(arg, desc):
    print(f'{colorama.Fore.YELLOW}{arg}{colorama.Fore.WHITE}{' ' * int(33 - len(arg))}| {colorama.Fore.BLUE}{desc}{colorama.Style.RESET_ALL}')

def HandleError(msg):
    if options['telegram.chat_id'] != 0 and options['telegram.token'] != 0:
        url = f'https://api.telegram.org/bot{options['telegram.token']}/sendMessage?chat_id={options['telegram.chat_id']}&text=[{options['world.name']} (id: {realm_id})]: {msg}'
        requests.get(url).json()

    if os.path.exists(mysqlcnf):
        os.remove(mysqlcnf)

    PrintError(msg)
    sys.exit(1)

class GitProgress(git.remote.RemoteProgress):
    def line_dropped(self, line):
        print(line)
    def update(self, *args):
        print(self._cur_line)

def ResetSource(path, branch):
    repo = git.Repo(path)
    repo.git.reset('--hard', f'origin/{branch}')

def CloneSource(path, repo, branch):
    git.Repo.clone_from(url=repo, to_path=path, branch=branch, depth=1, progress=GitProgress())

def PullSource(path):
    repo = git.Repo(path)
    repo.remotes.origin.pull(progress=GitProgress())

def HasChanges(path):
    repo = git.Repo(path)
    current = repo.head.commit
    repo.remotes.origin.pull()
    if current == repo.head.commit:
        return False
    else:
        return True

def UpdateSource(path, repo, branch, name):
    if not os.path.exists(path):
        try:
            PrintProgress(f'Downloading the source code for {name}')
            CloneSource(path, repo, branch)
        except Exception as e:
            print(e.stderr)
            HandleError(f'An error occurred while downloading the source code for {name}')
    else:
        if HasChanges(path):
            try:
                PrintProgress(f'Updating the source code for {name}')
                ResetSource(path, branch)
                PullSource(path)
            except Exception as e:
                print(e.stderr)
                HandleError(f'An error occurred while updating the source code for {name}')
        else:
            PrintProgress(f'The source code for {name} is up-to-date')

def DownloadSource():
    PrintHeader('Downloading source code...')

    if options['git.use_ssh']:
        cmd = 'git@github.com:'
    else:
        cmd = 'https://github.com/'

    UpdateSource(f'{source}/azerothcore', f'{cmd}{options['git.repository.azerothcore']}.git', f'{options['git.branch.azerothcore']}', 'azerothcore')
    UpdateSource(f'{source}/aowow', f'{cmd}{options['git.repository.aowow']}.git', f'{options['git.branch.aowow']}', 'aowow')

    PrintHeader('Finished downloading source code...')

def DropTables():
    PrintHeader('Dropping all tables from the database')

    connect = pymysql.connect(host=options['database.hostname'], user=options['database.username'], password=options['database.password'], db=options['database.world'])
    cursor = connect.cursor()
    cursor.execute('SHOW TABLES;')
    tables = []
    for d in cursor.fetchall():
        tables.append(d[0])

    if len(tables) > 0:
        for table in tables:
            PrintProgress(f'Dropping {table}')
            cursor.execute(f'DROP TABLE {table};')

        connect.commit()
    else:
        PrintProgress('Skipping process due to no tables being present')

    cursor.close()
    connect.close()

    PrintHeader('Finished dropping all tables from the database')

databases = [
    # world
    [options['database.world'], f'{source}/azerothcore/data/sql/base/db_world', False, ''],
    [options['database.world'], f'{source}/azerothcore/data/sql/updates/db_world', True, 'RELEASED'],
    [options['database.world'], f'{source}/azerothcore/data/sql/custom/db_world', True, 'CUSTOM'],
    [options['database.world'], f'{cwd}/azerothcore/sql/world', False, 'CUSTOM']
]

def sha1sum(filename):
    with open(filename, 'rb', buffering=0) as f:
        return hashlib.file_digest(f, 'sha1').hexdigest()

def ImportDatabase(database, path):
    if os.path.isdir(path):
        connect = pymysql.connect(host=options['database.hostname'], user=options['database.username'], password=options['database.password'], db=database)
        cursor = connect.cursor()
        cursor.execute('SHOW TABLES;')
        tables = []
        for d in cursor.fetchall():
            tables.append(d[0])
        cursor.close()
        connect.close()

        files = sorted(os.listdir(path))
        for file in files:
            if os.path.isfile(f'{path}/{file}'):
                if file.endswith('.sql'):
                    short = file.replace('.sql', '')
                    if short in tables:
                        PrintProgress(f'Skipping {file}')
                    else:
                        PrintProgress(f'Importing {file}')
                        subprocess.run(f'{f'"{windows_paths['mysql']}/bin/mysql.exe"' if os.name == 'nt' else 'mysql'} --defaults-extra-file={mysqlcnf} {database} < {path}/{file}', shell=True, check=True)

def UpdateDatabase(database, path, type):
    if os.path.isdir(path):
        connect = pymysql.connect(host=options['database.hostname'], user=options['database.username'], password=options['database.password'], db=database)
        cursor = connect.cursor()
        cursor.execute('SELECT name, hash FROM updates')
        updates = []
        for d in cursor.fetchall():
            updates.append([d[0], d[1]])

        files = sorted(os.listdir(path))
        for file in files:
            if os.path.isfile(f'{path}/{file}'):
                if file.endswith('.sql'):
                    sha = sha1sum(f'{path}/{file}').upper()
                    adv = [ file, sha ]

                    if adv in updates:
                        PrintProgress(f'Skipping {file}')
                    else:
                        PrintProgress(f'Importing {file}')
                        subprocess.run(f'{f'"{windows_paths['mysql']}/bin/mysql.exe"' if os.name == 'nt' else 'mysql'} --defaults-extra-file={mysqlcnf} {database} < {path}/{file}', shell=True, check=True)
                        cursor.execute(f"DELETE FROM updates WHERE name='{file}';")
                        cursor.execute(f"INSERT INTO updates (name, hash, state) VALUES ('{file}', '{sha}', '{type}');")
                        connect.commit()

        cursor.close()
        connect.close()

def UpdateDatabaseFile(database, path, file, type):
    if os.path.isfile(f'{path}/{file}'):
        connect = pymysql.connect(host=options['database.hostname'], user=options['database.username'], password=options['database.password'], db=database)
        cursor = connect.cursor()
        cursor.execute('SELECT name, hash FROM updates')
        updates = []
        for d in cursor.fetchall():
            updates.append([d[0], d[1]])

        sha = sha1sum(f'{path}/{file}').upper()
        adv = [ file, sha ]

        if adv in updates:
            PrintProgress(f'Skipping {file}')
        else:
            PrintProgress(f'Importing {file}')
            subprocess.run(f'{f'"{windows_paths['mysql']}/bin/mysql.exe"' if os.name == 'nt' else 'mysql'} --defaults-extra-file={mysqlcnf} {database} < {path}/{file}', shell=True, check=True)
            cursor.execute(f"DELETE FROM updates WHERE name='{file}';")
            cursor.execute(f"INSERT INTO updates (name, hash, state) VALUES ('{file}', '{sha}', '{type}');")
            connect.commit()

        cursor.close()
        connect.close()

def ImportDatabases():
    PrintHeader('Importing database files...')

    file = open(mysqlcnf, 'w')
    file.write(f'[client]\nhost="{options['database.hostname']}"\nport="{options['database.port']}"\nuser="{options['database.username']}"\npassword="{options['database.password']}"')
    file.close()

    for database in databases:
        db = database[0]
        path = database[1]
        is_update = database[2]
        note = database[3]

        try:
            if not is_update:
                ImportDatabase(db, path)
            else:
                UpdateDatabase(db, path, note)
        except:
            HandleError('An error occurred while importing the database files')

    UpdateDatabaseFile(options['database.world'], f'{cwd}/aowow/setup', 'spell_learn_spell.sql', 'CUSTOM')

    if os.path.exists(mysqlcnf):
        os.remove(mysqlcnf)

    PrintHeader('Finished importing the database files...')

DownloadSource()
DropTables()
ImportDatabases()
