#import psutil
#if os.name == 'nt':
    #for p in psutil.process_iter(attrs=['pid', 'name']):
        #if p.info['name'].lower() == 'authserver.exe' or p.info['name'].lower() == 'worldserver.exe':
            #PrintError('The server is running')
            #exit()

# ALTER USER 'acore'@'127.0.0.1' IDENTIFIED WITH caching_sha2_password BY 'acore';

# Install MySQL Server on Linux:
# wget https://repo.mysql.com/mysql-apt-config_0.8.32-1_all.deb
# dpkg -i mysql-apt-config_0.8.32-1_all.deb
# apt update
# apt install -y mysql-server

# Linux prerequisites:
# apt install python3-git python3-requests python3-tqdm python3-pymysql
# apt install screen cmake make gcc clang g++ libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost1.83-all-dev libmysqlclient-dev mysql-client

# Windows prerequisites:
# pip install colorama gitpython pymysql requests tqdm
# C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat

from settings import gitcmd, settings, modules, windows_paths

from pathlib import Path
from tqdm import tqdm

import colorama
import git
import hashlib
import multiprocessing
import pymysql
import requests
import shutil
import subprocess
import stat
import sys
import time
import os

cwd = os.getcwd()
source = f'{cwd}/source'
build = f'{source}/build'
mysqlcnf = f'{cwd}/mysql.cnf'

if os.name == 'nt':
    colorama.just_fix_windows_console()
    
#######################################################################
# PRINTS
#

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

#
#######################################################################

#######################################################################
# ERRORS
#

def HandleError(msg):
    if settings['telegram.chat_id'] != 0 and settings['telegram.token'] != 0:
        url = f'https://api.telegram.org/bot{settings['telegram.token']}/sendMessage?chat_id={settings['telegram.chat_id']}&text=[{settings['world.name']} (id: {settings['world.id']})]: {msg}'
        requests.get(url).json()

    exit()

#
#######################################################################

#######################################################################
# GIT
#

class GitProgress(git.remote.RemoteProgress):
    def line_dropped(self, line):
        print(line)
    def update(self, *args):
        print(self._cur_line)

#
#######################################################################

#######################################################################
# ARGUMENTS
#

arguments = [
    [ [ 'install', 'setup', 'update' ], 'Downloads the source code, with enabled modules, and compiles it. Also downloads client files' ],
    [ [ 'database', 'db' ], 'Import all files to the specified databases' ],
    [ [ 'config', 'conf', 'cfg', 'settings', 'options' ], 'Updates all config files, including enabled modules, with options specified' ],
    [ 'dbc', 'Copy modified client data files to the proper folder' ],
    [ 'reset', 'Drops all database tables from the world database' ],
    [ 'all', 'Run all parameters listed above, excluding reset but including stop and start (Linux only)' ],
    [ 'start', 'Starts the compiled processes, based off of the choice for compilation (Linux only)' ],
    [ 'stop', 'Stops the compiled processes, based off of the choice for compilation (Linux only)' ],
    [ 'restart', 'Stops and then starts the compiled processes, based off of the choice for compilation (Linux only)' ],
]

def IsValidArgument(arg):
    for argument in arguments:
        if type(argument[0]) == list:
            for sub in argument[0]:
                if sub == arg:
                    return True
        else:
            if argument[0] == arg:
                return True
    return False

def CheckArgument():
    if len(sys.argv) < 2:
        return False
    if not IsValidArgument(sys.argv[1]):
        return False
    return True

def ListArguments():
    PrintHeader('Available arguments')
    for argument in arguments:
        param = argument[0]
        desc = argument[1]
        if type(param) == list:
            param = '/'.join(param)
        PrintArgument(param, desc)

def SelectArgument():
    for argument in arguments:
        if type(argument[0]) == list:
            for sub in argument[0]:
                if sub == sys.argv[1]:
                    return argument[0][0]
        else:
            if argument[0] == sys.argv[1]:
                return argument[0]

#
#######################################################################

#######################################################################
# SOURCE
#

def ResetSource(path, branch):
    repo = git.Repo(path)
    repo.git.reset('--hard', f'origin/{branch}')

def CloneSource(path, repo, branch):
    git.Repo.clone_from(url=repo, to_path=path, branch=branch, depth=1, progress=GitProgress())

def PullSource(path):
    repo = git.Repo(path)
    repo.remotes.origin.pull(progress=GitProgress())

def UpdateSource():
    PrintHeader('Downloading the source code...')

    repo = f'{gitcmd}{settings['git.repository']}.git'
    branch = settings['git.branch']

    if not os.path.exists(source):
        #PrintProgress('Downloading the source code for azerothcore')
        try:
            CloneSource(source, repo, branch)
        except Exception as e:
            print(e.stderr)
            HandleError('An error occured while downloading the source code for azerothcore')
    else:
        #PrintProgress('Updating the source code for azerothcore')
        try:
            ResetSource(source, branch)
            PullSource(source)
        except Exception as e:
            print(e.stderr)
            HandleError('An error occured while updating the source code for azerothcore')

    if settings['build.world']:
        for module in modules:
            enabled = module[1]
            repo = f'{gitcmd}{module[2]}.git'
            branch = module[3]
            name = module[4]
            path = f'{source}/modules/{module[4]}'

            if enabled:
                if not os.path.exists(path):
                    #PrintProgress(f'Downloading the source code for {name}')
                    try:
                        CloneSource(path, repo, branch)
                    except Exception as e:
                        print(e.stderr)
                        HandleError(f'An error occured while downloading the source code for {name}')
                else:
                    #PrintProgress(f'Updating the source code for {name}')
                    try:
                        ResetSource(path, branch)
                        PullSource(path)
                    except Exception as e:
                        print(e.stderr)
                        HandleError(f'An error occured while updating the source code for {name}')
            else:
                if os.path.exists(path) and os.path.isdir(path):
                    git.rmtree(path)

    PrintHeader('Finished downloading the source code...')

def GenerateSource():
    if settings['build.auth'] and settings['build.world']:
        apps = 'all'
    elif settings['build.auth']:
        apps = 'auth-only'
    elif settings['build.world']:
        apps = 'world-only'

    args = [f'-S {source}', f'-B {build}', '-DWITH_WARNINGS=0', '-DSCRIPTS=static', f'-DAPPS_BUILD={apps}']

    if os.name == 'nt':
        args.append(f'-DMYSQL_EXECUTABLE={windows_paths['mysql']}/bin/mysql.exe')
        args.append(f'-DMYSQL_INCLUDE_DIR={windows_paths['mysql']}/include')
        args.append(f'-DMYSQL_LIBRARY={windows_paths['mysql']}/lib/libmysql.lib')
    else:
        args.append(f'-DCMAKE_INSTALL_PREFIX={source}')
        args.append('-DCMAKE_C_COMPILER=/usr/bin/clang')
        args.append('-DCMAKE_CXX_COMPILER=/usr/bin/clang++')
        args.append('-DCMAKE_CXX_FLAGS="-w"')

    subprocess.run([f'{windows_paths['cmake']}/bin/cmake.exe' if os.name == 'nt' else 'cmake', *args], check=True)

def CleanSource():
    if os.name == 'nt':
        args = [f'{build}/AzerothCore.sln', '/t:Clean']
    else:
        args = ['clean']

    subprocess.run([f'{windows_paths['msbuild']}/MSBuild.exe' if os.name == 'nt' else 'make', *args], cwd=build, check=True)

def CompileSource():
    if os.name == 'nt':
        args = [f'{build}/AzerothCore.sln', '/p:Configuration=RelWithDebInfo', '/p:WarningLevel=0']

        if settings['build.auth'] and not settings['build.world']:
            args.append('/target:authserver')
        elif not settings['build.auth'] and settings['build.world']:
            args.append('/target:worldserver')
        else:
            args.append('/target:ALL_BUILD')
    else:
        args = ['-j', str(multiprocessing.cpu_count()), 'install']

    attempts = 0
    while attempts < 3:
        try:
            subprocess.run([f'{windows_paths['msbuild']}/MSBuild.exe' if os.name == 'nt' else 'make', *args], cwd=build, check=True)
            break
        except:
            CleanSource()
            attempts += 1

def CreateScript(name, path, text):
    PrintProgress(f'Creating {name}')
    file = open(f'{path}/{name}', 'w')
    file.write(text)
    file.close()
    f = Path(f'{path}/{name}')
    f.chmod(f.stat().st_mode | stat.S_IEXEC)

def CreateScripts():
    PrintHeader('Creating start and stop scripts...')

    if os.name == 'nt':
        if settings['build.auth']:
            text = '@echo off\ncd source/build/bin/RelWithDebInfo\n:auth\n    authserver.exe\ngoto auth\n'
            CreateScript('auth.bat', cwd, text)

        if settings['build.world']:
            text = '@echo off\ncd source/build/bin/RelWithDebInfo\n:world\n    worldserver.exe\n    if %errorlevel% == 0 (\n        pause\n    )\ngoto world\n'
            CreateScript('world.bat', cwd, text)
    else:
        text = '#!/bin/bash\n'
        if settings['build.auth']:
            text += 'screen -AmdS auth ./auth.sh\n'
        if settings['build.world']:
            text += f'time=$(date +%s)\n'
            text += f'screen -L -Logfile $time.log -AmdS world-{settings['world.id']} ./world.sh\n'
        CreateScript('start.sh', f'{source}/bin', text)

        text = '#!/bin/bash\n'
        if settings['build.auth']:
            text += 'screen -X -S "auth" quit\n'
        if settings['build.world']:
            text += f'screen -X -S "world-{settings['world.id']}" quit\n'
        CreateScript('stop.sh', f'{source}/bin', text)

        if settings['build.auth']:
            text = '#!/bin/bash\nwhile :; do\n    ./authserver\n    sleep 5\ndone\n'
            CreateScript('auth.sh', f'{source}/bin', text)

        if settings['build.world']:
            text = '#!/bin/bash\nwhile :; do\n    nice -n -19 taskset -c 1,2,3 ./worldserver\n    if [[ $? == 0 ]]; then\n      break\n    fi\n    sleep 5\ndone\n'
            CreateScript('world.sh', f'{source}/bin', text)

    PrintHeader('Finished creating start and stop scripts...')

def CopyLibraries():
    libraries = [
        [f'{windows_paths['openssl']}/bin', 'legacy.dll'],
        [f'{windows_paths['openssl']}/bin', 'libcrypto-3-x64.dll'],
        [f'{windows_paths['openssl']}/bin', 'libssl-3-x64.dll'],
        [f'{windows_paths['mysql']}/lib', 'libmysql.dll']
    ]

    PrintHeader('Copying required libraries...')

    for lib in libraries:
        PrintProgress(f'Copying {lib[1]}')
        shutil.copyfile(f'{lib[0]}/{lib[1]}', f'{build}/bin/RelWithDebInfo/{lib[1]}')

    PrintHeader('Finished copying required libraries...')

def BuildSource():
    PrintHeader('Compiling the source code...')
    try:
        GenerateSource()
        CompileSource()
    except:
        HandleError('An error occured while compiling the source code')
    PrintHeader('Finished compiling the source code...')

def DoInstall():
    UpdateSource()
    BuildSource()
    CreateScripts()
    if os.name == 'nt':
        CopyLibraries()
    CreateCustomDirectories()
    try:
        GetClientData()
    except:
        HandleError('An error occured while downloading the client data files')

#
#######################################################################

#######################################################################
# CLIENT DATA
#

def GetLocalDataVersion():
    version = 0
    data_file = f'{GetDataPath()}/data.version'
    if os.path.exists(data_file) and os.path.isfile(data_file):
        file = open(data_file, 'r')
        content = file.read()
        if content.isnumeric():
            version = content
    return version

def GetRemoteDataVersion():
    g = git.cmd.Git()
    list = sorted(g.ls_remote('--tags', 'https://github.com/wowgaming/client-data.git').split('\n'), reverse=True)
    return list[0].rsplit('/', 1)[1].replace('v', '')

def GetDataPath():
    data_dir = settings['world.data_directory']
    binary_path = f'{build}/bin/RelWithDebInfo' if os.name == 'nt' else f'{source}/bin'
    if data_dir == '.':
        target = binary_path
    elif data_dir.startswith('./'):
        target = f'{binary_path}/{data_dir.replace('./', '')}'
    else:
        target = data_dir
    return target

def DeleteClientData():
    data_dir = GetDataPath()
    dirs = [ 'Cameras', 'dbc', 'maps', 'mmaps', 'vmaps' ]
    for dir in dirs:
        if os.path.exists(f'{data_dir}/{dir}'):
            shutil.rmtree(f'{data_dir}/{dir}')

def DownloadClientData(version):
    PrintProgress('Downloading data archive')
    url = f'https://github.com/wowgaming/client-data/releases/download/v{version}/data.zip'
    file_name = f'{cwd}/data.zip'
    response = requests.get(url, stream=True)
    file_size = int(response.headers.get('content-length', 0))
    with open(file_name, 'wb') as file, tqdm(
        total=file_size,
        unit='iB',
        unit_scale=True,
        unit_divisor=1024,
    ) as bar:
        for data in response.iter_content(chunk_size=1024):
            size = file.write(data)
            bar.update(size)

def UnpackDataFiles():
    PrintProgress('Unpacking data archive')
    shutil.unpack_archive(f'{cwd}/data.zip', GetDataPath())

def UpdateDataVersion(version):
    file = open(f'{GetDataPath()}/data.version', 'w')
    file.write(version)
    file.close()

def GetClientData():
    if settings['build.world']:
        local_version = GetLocalDataVersion()
        remote_version = GetRemoteDataVersion()

        if local_version != remote_version:
            PrintHeader('Downloading the client data files...')
            DeleteClientData()
            DownloadClientData(remote_version)
            UnpackDataFiles()
            UpdateDataVersion(remote_version)
            PrintHeader('Finished downloading the client data files...')

        if os.path.exists(f'{cwd}/data.zip'):
            os.remove(f'{cwd}/data.zip')

#
#######################################################################

#######################################################################
# DATABASE
#

def sha1sum(filename):
    with open(filename, 'rb', buffering=0) as f:
        return hashlib.file_digest(f, 'sha1').hexdigest()

def CreateCustomDirectories():
    directories = [ 'dbc', 'sql', 'sql/auth', 'sql/characters', 'sql/world' ]

    for directory in directories:
        path = f'{cwd}/{directory}'
        if not os.path.isdir(path):
            os.mkdir(path, 0o666)

def ImportDatabase(database, path):
    if os.path.isdir(path):
        connect = pymysql.connect(host=settings['database.host'], user=settings['database.username'], password=settings['database.password'], db=database)
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
        connect = pymysql.connect(host=settings['database.host'], user=settings['database.username'], password=settings['database.password'], db=database)
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

def UpdateRealmlist():
    PrintProgress(f'Adding to the realmlist (id: {settings['world.id']}, name: {settings['world.name']}, address: {settings['world.address']}, localAddress: {settings['world.local_address']}, port: {settings['world.port']})')

    connect = pymysql.connect(host=settings['database.host'], user=settings['database.username'], password=settings['database.password'], db=settings['database.auth'])
    cursor = connect.cursor()
    cursor.execute(f'DELETE FROM realmlist WHERE id={settings['world.id']};')
    cursor.execute(f"INSERT INTO realmlist (id, name, address, localAddress, port) VALUES ({settings['world.id']}, '{settings['world.name']}', '{settings['world.address']}', '{settings['world.local_address']}', {settings['world.port']});")
    connect.commit()
    cursor.close()
    connect.close()

def UpdateMotd():
    PrintProgress(f'Updating message of the day')

    connect = pymysql.connect(host=settings['database.host'], user=settings['database.username'], password=settings['database.password'], db=settings['database.auth'])
    cursor = connect.cursor()
    cursor.execute(f'DELETE FROM motd WHERE realmid={settings['world.id']};')
    cursor.execute(f"INSERT INTO motd (realmid, text) VALUES ({settings['world.id']}, 'Welcome to {settings['world.name']}');")
    connect.commit()
    cursor.close()
    connect.close()

def ImportDatabases():
    PrintHeader('Importing the database files...')

    file = open(mysqlcnf, 'w')
    file.write(f'[client]\nhost="{settings['database.host']}"\nport="{settings['database.port']}"\nuser="{settings['database.username']}"\npassword="{settings['database.password']}"')
    file.close()

    try:
        ImportDatabase(settings['database.auth'], f'{source}/data/sql/base/db_auth')
        UpdateDatabase(settings['database.auth'], f'{source}/data/sql/updates/db_auth', 'RELEASED')
        UpdateDatabase(settings['database.auth'], f'{source}/data/sql/custom/db_auth', 'CUSTOM')
    except:
        HandleError(f'An error occured while trying to import the database files for {settings['database.auth']}')

    if settings['build.world']:
        try:
            ImportDatabase(settings['database.characters'], f'{source}/data/sql/base/db_characters')
            UpdateDatabase(settings['database.characters'], f'{source}/data/sql/updates/db_characters', 'RELEASED')
            UpdateDatabase(settings['database.characters'], f'{source}/data/sql/custom/db_characters', 'CUSTOM')
        except:
            HandleError(f'An error occured while trying to import the database files for {settings['database.characters']}')

        try:
            ImportDatabase(settings['database.world'], f'{source}/data/sql/base/db_world')
            UpdateDatabase(settings['database.world'], f'{source}/data/sql/updates/db_world', 'RELEASED')
            UpdateDatabase(settings['database.world'], f'{source}/data/sql/custom/db_world', 'CUSTOM')
        except:
            HandleError(f'An error occured while trying to import the database files for {settings['database.world']}')

        if settings['module.ah_bot']:
            try:
                UpdateDatabase(settings['database.world'], f'{source}/modules/mod-ah-bot/data/sql/db-world', 'MODULE')
            except:
                HandleError('An error occured while trying to import the database files for mod-ah-bot')

        if settings['module.appreciation']:
            try:
                UpdateDatabase(settings['database.world'], f'{source}/modules/mod-appreciation/data/sql/db-world/base', 'MODULE')
            except:
                HandleError('An error occured while trying to import the database files for mod-appreciation')

        if settings['module.assistant']:
            try:
                UpdateDatabase(settings['database.world'], f'{source}/modules/mod-assistant/sql/world', 'MODULE')
            except:
                HandleError('An error occured while trying to import the database files for mod-assistant')

        if settings['module.groupquests']:
            try:
                UpdateDatabase(settings['database.world'], f'{source}/modules/mod-groupquests/sql/world', 'MODULE')
            except:
                HandleError('An error occured while trying to import the database files for mod-groupquests')

        if settings['module.playerbots']:
            try:
                UpdateDatabase(settings['database.characters'], f'{source}/modules/mod-playerbots/sql/characters', 'MODULE')
                UpdateDatabase(settings['database.world'], f'{source}/modules/mod-playerbots/sql/world', 'MODULE')
                ImportDatabase(settings['database.playerbots'], f'{source}/modules/mod-playerbots/sql/playerbots/base')
                UpdateDatabase(settings['database.playerbots'], f'{source}/modules/mod-playerbots/sql/playerbots/updates', 'RELEASED')
            except:
                HandleError('An error occured while trying to import the database files for mod-playerbots')

        if settings['module.progression']:
            try:
                if settings['module.progression.reset']:
                    connect = pymysql.connect(host=settings['database.host'], user=settings['database.username'], password=settings['database.password'], db=settings['database.world'])
                    cursor = connect.cursor()
                    cursor.execute("DELETE FROM updates WHERE name LIKE 'patch_%'")
                    connect.commit()
                    cursor.close()
                    connect.close()

                if settings['module.progression.patch'] >= 0:
                        UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_00-1_1/sql', 'MODULE')
                if settings['module.progression.patch'] >= 1:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_01-1_2/sql', 'MODULE')
                if settings['module.progression.patch'] >= 2:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_02-1_3/sql', 'MODULE')
                if settings['module.progression.patch'] >= 3:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_03-1_4/sql', 'MODULE')
                if settings['module.progression.patch'] >= 4:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_04-1_5/sql', 'MODULE')
                if settings['module.progression.patch'] >= 5:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_05-1_6/sql', 'MODULE')
                if settings['module.progression.patch'] >= 6:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_06-1_7/sql', 'MODULE')
                if settings['module.progression.patch'] >= 7:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_07-1_8/sql', 'MODULE')
                if settings['module.progression.patch'] >= 8:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_08-1_9/sql', 'MODULE')
                if settings['module.progression.patch'] >= 9:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_09-1_10/sql', 'MODULE')
                if settings['module.progression.patch'] >= 10:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_10-1_11/sql', 'MODULE')
                if settings['module.progression.patch'] >= 11:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_11-1_12/sql', 'MODULE')
                if settings['module.progression.patch'] >= 12:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_12-2_0/sql', 'MODULE')
                if settings['module.progression.patch'] >= 13:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_13-2_1/sql', 'MODULE')
                if settings['module.progression.patch'] >= 14:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_14-2_2/sql', 'MODULE')
                if settings['module.progression.patch'] >= 15:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_15-2_3/sql', 'MODULE')
                if settings['module.progression.patch'] >= 16:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_16-2_4/sql', 'MODULE')
                if settings['module.progression.patch'] >= 17:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_17-3_0/sql', 'MODULE')
                if settings['module.progression.patch'] >= 18:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_18-3_1/sql', 'MODULE')
                if settings['module.progression.patch'] >= 19:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_19-3_2/sql', 'MODULE')
                if settings['module.progression.patch'] >= 20:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_20-3_3/sql', 'MODULE')
                if settings['module.progression.patch'] == 21:
                    UpdateDatabase(settings['database.world'], f'{source}/modules/mod-progression/src/patch_21-3_3_5/sql', 'MODULE')
            except:
                HandleError('An error occured while trying to import the database files for mod-progression')

        if settings['module.recruitafriend']:
            try:
                UpdateDatabase(settings['database.auth'], f'{source}/modules/mod-recruitafriend/sql/auth', 'MODULE')
            except:
                HandleError('An error occured while trying to import the database files for mod-recruitafriend')

        if settings['module.skip_dk_starting_area']:
            try:
                UpdateDatabase(settings['database.world'], f'{source}/modules/mod-skip-dk-starting-area/data/sql/db-world', 'MODULE')
            except:
                HandleError('An error occured while trying to import the database files for mod-skip_dk_starting_area')

    UpdateDatabase(settings['database.auth'], f'{cwd}/sql/auth', 'CUSTOM')
    if settings['build.world']:
        UpdateDatabase(settings['database.characters'], f'{cwd}/sql/characters', 'CUSTOM')
        UpdateDatabase(settings['database.world'], f'{cwd}/sql/world', 'CUSTOM')

    if settings['build.world']:
        UpdateRealmlist()
        UpdateMotd()

    if os.path.exists(mysqlcnf):
        os.remove(mysqlcnf)

    PrintHeader('Finished importing the database files...')

def ResetDatabase():
    PrintHeader('Dropping the database tables...')

    if settings['build.world']:
        connect = pymysql.connect(host=settings['database.host'], user=settings['database.username'], password=settings['database.password'], db=settings['database.world'])
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
    else:
        PrintProgress('Skipping process due to world server being disabled')

    PrintHeader('Finished dropping the database tables..')

#
#######################################################################

#######################################################################
# CONFIG
#

def UpdateConfig(config, replacements):
    PrintProgress(f'Updating {config.rsplit('/', 1)[1]}')

    with open(f'{config}.dist', encoding='utf-8') as file:
        lines = file.readlines()

    for count, line in enumerate(lines):
        for replacement in replacements:
            if line.startswith(replacement[0]):
                lines[count] = f'{replacement[1]}\n'

    with open(f'{config}', 'w', encoding='utf-8') as file:
        file.writelines(lines)

def UpdateConfigs():
    PrintHeader('Updating the config files...')

    path = f'{build}/bin/RelWithDebInfo/configs' if os.name == 'nt' else f'{source}/etc'

    if settings['build.auth']:
        replacements = [
            ['LoginDatabaseInfo =', f'LoginDatabaseInfo = "{settings['database.host']};{settings['database.port']};{settings['database.username']};{settings['database.password']};{settings['database.auth']}"'],
            ['Updates.EnableDatabases =', 'Updates.EnableDatabases = 0']
        ]
        UpdateConfig(f'{path}/authserver.conf', replacements)

    if settings['build.world']:
        replacements = [
            ['RealmID =', f'RealmID = {settings['world.id']}'],
            ['WorldServerPort =', f'WorldServerPort = {settings['world.port']}'],
            ['LoginDatabaseInfo     =', f'LoginDatabaseInfo     ="{settings['database.host']};{settings['database.port']};{settings['database.username']};{settings['database.password']};{settings['database.auth']}"'],
            ['WorldDatabaseInfo     =', f'WorldDatabaseInfo     ="{settings['database.host']};{settings['database.port']};{settings['database.username']};{settings['database.password']};{settings['database.world']}"'],
            ['CharacterDatabaseInfo = ', f'CharacterDatabaseInfo = "{settings['database.host']};{settings['database.port']};{settings['database.username']};{settings['database.password']};{settings['database.characters']}"'],
            ['DataDir =', f'DataDir = "{GetDataPath()}"'],
            ['BeepAtStart =', 'BeepAtStart = 0'],
            ['FlashAtStart =', 'FlashAtStart = 0'],
            ['Updates.EnableDatabases =', 'Updates.EnableDatabases = 0'],
            ['GameType =', f'GameType = {settings['world.game_type']}'],
            ['RealmZone =', f'RealmZone = {settings['world.realm_zone']}'],
            ['Expansion =', f'Expansion = {settings['world.expansion']}'],
            ['MinWorldUpdateTime =', 'MinWorldUpdateTime = 10'],
            ['Warden.Enabled =', f'Warden.Enabled = {'1' if settings['world.warden'] else '0'}'],
            ['MapUpdateInterval =', 'MapUpdateInterval = 100'],
            ['MapUpdate.Threads =', f'MapUpdate.Threads = {multiprocessing.cpu_count()}'],
            ['PreloadAllNonInstancedMapGrids =', f'PreloadAllNonInstancedMapGrids = {'1' if settings['world.preload_grids'] else '0'}'],
            ['SetAllCreaturesWithWaypointMovementActive =', f'SetAllCreaturesWithWaypointMovementActive = {'1' if settings['world.set_creatures_active'] else '0'}'],
            ['AllowPlayerCommands =', f'AllowPlayerCommands = {'1' if settings['world.allow_player_commands'] else '0'}'],
            ['Die.Command.Mode =', 'Die.Command.Mode = 0'],
            ['GM.LoginState =', 'GM.LoginState = 1'],
            ['GM.Visible =', 'GM.Visible = 0'],
            ['GM.Chat =', 'GM.Chat = 1'],
            ['GM.WhisperingTo =', 'GM.WhisperingTo = 0'],
            ['GM.InGMList.Level =', 'GM.InGMList.Level = 1'],
            ['GM.InWhoList.Level =', 'GM.InWhoList.Level = 0'],
            ['StrictPlayerNames =', 'StrictPlayerNames = 3'],
            ['StrictPetNames =', 'StrictPetNames = 3'],
            ['CharacterCreating.MinLevelForHeroicCharacter =', 'CharacterCreating.MinLevelForHeroicCharacter = 0'],
            ['DBC.EnforceItemAttributes =', 'DBC.EnforceItemAttributes = 0'],
            ['Quests.IgnoreRaid =', 'Quests.IgnoreRaid = 1'],
            ['Quests.IgnoreAutoAccept =', 'Quests.IgnoreAutoAccept = 1'],
            ['Group.Raid.LevelRestriction =', 'Group.Raid.LevelRestriction = 1'],
            ['DungeonFinder.CastDeserter =', 'DungeonFinder.CastDeserter = 0'],
            ['StrictCharterNames =', 'StrictCharterNames = 3'],
            ['Battleground.CastDeserter =', 'Battleground.CastDeserter = 0'],
            ['StrictChannelNames =', 'StrictChannelNames = 3'],
            ['Minigob.Manabonk.Enable =', 'Minigob.Manabonk.Enable = 0'],
            ['Daze.Enabled =', f'Daze.Enabled = {'1' if settings['world.enable_daze'] else '0'}']
        ]
        UpdateConfig(f'{path}/worldserver.conf', replacements)

        if settings['module.ah_bot']:
            max_item_level = settings['module.ah_bot.max_item_level']
            if settings['module.progression']:
                patch_id = settings['module.progression.patch']
                if patch_id < 6:
                    patch_max_item_level = 66
                elif patch_id < 7:
                    patch_max_item_level = 76
                elif patch_id < 12:
                    patch_max_item_level = 92
                elif patch_id < 13:
                    patch_max_item_level = 120
                elif patch_id < 14:
                    patch_max_item_level = 133
                elif patch_id < 17:
                    patch_max_item_level = 154
                elif patch_id < 18:
                    patch_max_item_level = 213
                elif patch_id < 19:
                    patch_max_item_level = 226
                elif patch_id < 20:
                    patch_max_item_level = 245
                else:
                    patch_max_item_level = 0

                if patch_id < 21:
                    if max_item_level == 0 or max_item_level > patch_max_item_level:
                        settings['module.ah_bot.max_item_level'] = patch_max_item_level

            replacements = [
                ['AuctionHouseBot.EnableSeller =', f'AuctionHouseBot.EnableSeller = {'1' if settings['module.ah_bot.seller.enabled'] else '0'}'],
                ['AuctionHouseBot.EnableBuyer =', f'AuctionHouseBot.EnableBuyer = {'1' if settings['module.ah_bot.buyer.enabled'] else '0'}'],
                ['AuctionHouseBot.UseBuyPriceForSeller =', f'AuctionHouseBot.UseBuyPriceForSeller = {'1' if settings['module.ah_bot.seller.use_buyprice'] else '0'}'],
                ['AuctionHouseBot.UseBuyPriceForBuyer =', f'AuctionHouseBot.UseBuyPriceForBuyer = {'1' if settings['module.ah_bot.buyer.use_buyprice'] else '0'}'],
                ['AuctionHouseBot.Account =', f'AuctionHouseBot.Account = {settings['module.ah_bot.account_id']}'],
                ['AuctionHouseBot.GUID =', f'AuctionHouseBot.GUID = {settings['module.ah_bot.character_guid']}'],
                ['AuctionHouseBot.ItemsPerCycle =', f'AuctionHouseBot.ItemsPerCycle = {settings['module.ah_bot.items_per_cycle']}'],
                ['AuctionHouseBot.DisableItemsAboveLevel =', f'AuctionHouseBot.DisableItemsAboveLevel = {settings['module.ah_bot.max_item_level']}']
            ]
            UpdateConfig(f'{path}/modules/mod_ahbot.conf', replacements)

        if settings['module.appreciation']:
            if settings['module.progression']:
                patch_id = settings['module.progression.patch']
                if patch_id < 12 and settings['module.appreciation.level_boost.level'] > 60:
                    settings['module.appreciation.level_boost.level'] = 60
                elif patch_id < 17 and settings['module.appreciation.level_boost.level'] > 70:
                    settings['module.appreciation.level_boost.level'] = 70

                if patch_id < 12:
                    settings['module.appreciation.unlock_continents.outland'] = False
                if patch_id < 17:
                    settings['module.appreciation.unlock_continents.northrend'] = False

            replacements = [
                ['Appreciation.RequireCertificate.Enabled =', f'Appreciation.RequireCertificate.Enabled = {'1' if settings['module.appreciation.require_certificate'] else '0'}'],
                ['Appreciation.LevelBoost.Enabled =', f'Appreciation.LevelBoost.Enabled = {'1' if settings['module.appreciation.level_boost.enabled'] else '0'}'],
                ['Appreciation.LevelBoost.TargetLevel =', f'Appreciation.LevelBoost.TargetLevel = {settings['module.appreciation.level_boost.level']}'],
                ['Appreciation.LevelBoost.IncludedCopper =', f'Appreciation.LevelBoost.IncludedCopper = {settings['module.appreciation.level_boost.included_copper']}'],
                ['Appreciation.UnlockContinents.Enabled =', f'Appreciation.UnlockContinents.Enabled = {'1' if settings['module.appreciation.unlock_continents.enabled'] else '0'}'],
                ['Appreciation.UnlockContinents.EasternKingdoms.Enabled =', f'Appreciation.UnlockContinents.EasternKingdoms.Enabled = {'1' if settings['module.appreciation.unlock_continents.eastern_kingdoms'] else '0'}'],
                ['Appreciation.UnlockContinents.Kalimdor.Enabled =', f'Appreciation.UnlockContinents.Kalimdor.Enabled = {'1' if settings['module.appreciation.unlock_continents.kalimdor'] else '0'}'],
                ['Appreciation.UnlockContinents.Outland.Enabled =', f'Appreciation.UnlockContinents.Outland.Enabled = {'1' if settings['module.appreciation.unlock_continents.outland'] else '0'}'],
                ['Appreciation.UnlockContinents.Northrend.Enabled =', f'Appreciation.UnlockContinents.Northrend.Enabled = {'1' if settings['module.appreciation.unlock_continents.northrend'] else '0'}'],
                ['Appreciation.RewardAtMaxLevel.Enabled =', f'Appreciation.RewardAtMaxLevel.Enabled = {'1' if settings['module.appreciation.reward_at_max_level'] else '0'}']
            ]
            UpdateConfig(f'{path}/modules/mod_appreciation.conf', replacements)

        if settings['module.assistant']:
            if settings['module.progression']:
                patch_id = settings['module.progression.patch']
                if patch_id < 12:
                    settings['module.assistant.glyphs.enabled'] = False
                    settings['module.assistant.gems.enabled'] = False
                    settings['module.assistant.flightpaths.burning_crusade.enabled'] = False
                    settings['module.assistant.professions.master.enabled'] = False

                if patch_id < 17:
                    settings['module.assistant.heirlooms.enabled'] = False
                    settings['module.assistant.flightpaths.wrath_of_the_lich_king.enabled'] = False
                    settings['module.assistant.professions.grand_master.enabled'] = False

            replacements = [
                ['Assistant.Heirlooms.Enabled  =', f'Assistant.Heirlooms.Enabled  = {'1' if settings['module.assistant.heirlooms.enabled'] else '0'}'],
                ['Assistant.Glyphs.Enabled     =', f'Assistant.Glyphs.Enabled     = {'1' if settings['module.assistant.glyphs.enabled'] else '0'}'],
                ['Assistant.Gems.Enabled       =', f'Assistant.Gems.Enabled       = {'1' if settings['module.assistant.gems.enabled'] else '0'}'],
                ['Assistant.Containers.Enabled =', f'Assistant.Containers.Enabled = {'1' if settings['module.assistant.containers.enabled'] else '0'}'],
                ['Assistant.Utilities.Enabled            =', f'Assistant.Utilities.Enabled            = {'1' if settings['module.assistant.utilities.enabled'] else '0'}'],
                ['Assistant.Utilities.NameChange.Cost    =', f'Assistant.Utilities.NameChange.Cost    = {settings['module.assistant.utilities.name_change.cost']}'],
                ['Assistant.Utilities.Customize.Cost     =', f'Assistant.Utilities.Customize.Cost     = {settings['module.assistant.utilities.customize.cost']}'],
                ['Assistant.Utilities.RaceChange.Cost    =', f'Assistant.Utilities.RaceChange.Cost    = {settings['module.assistant.utilities.race_change.cost']}'],
                ['Assistant.Utilities.FactionChange.Cost =', f'Assistant.Utilities.FactionChange.Cost = {settings['module.assistant.utilities.faction_change.cost']}'],
                ['Assistant.FlightPaths.Vanilla.Enabled                  =', f'Assistant.FlightPaths.Vanilla.Enabled                  = {'1' if settings['module.assistant.flightpaths.vanilla.enabled'] else '0'}'],
                ['Assistant.FlightPaths.Vanilla.RequiredLevel            =', f'Assistant.FlightPaths.Vanilla.RequiredLevel            = {settings['module.assistant.flightpaths.vanilla.required_level']}'],
                ['Assistant.FlightPaths.Vanilla.Cost                     =', f'Assistant.FlightPaths.Vanilla.Cost                     = {settings['module.assistant.flightpaths.vanilla.cost']}'],
                ['Assistant.FlightPaths.BurningCrusade.Enabled           =', f'Assistant.FlightPaths.BurningCrusade.Enabled           = {'1' if settings['module.assistant.flightpaths.burning_crusade.enabled'] else '0'}'],
                ['Assistant.FlightPaths.BurningCrusade.RequiredLevel     =', f'Assistant.FlightPaths.BurningCrusade.RequiredLevel     = {settings['module.assistant.flightpaths.burning_crusade.required_level']}'],
                ['Assistant.FlightPaths.BurningCrusade.Cost              =', f'Assistant.FlightPaths.BurningCrusade.Cost              = {settings['module.assistant.flightpaths.burning_crusade.cost']}'],
                ['Assistant.FlightPaths.WrathOfTheLichKing.Enabled       =', f'Assistant.FlightPaths.WrathOfTheLichKing.Enabled       = {'1' if settings['module.assistant.flightpaths.wrath_of_the_lich_king.enabled'] else '0'}'],
                ['Assistant.FlightPaths.WrathOfTheLichKing.RequiredLevel =', f'Assistant.FlightPaths.WrathOfTheLichKing.RequiredLevel = {settings['module.assistant.flightpaths.wrath_of_the_lich_king.required_level']}'],
                ['Assistant.FlightPaths.WrathOfTheLichKing.Cost          =', f'Assistant.FlightPaths.WrathOfTheLichKing.Cost          = {settings['module.assistant.flightpaths.wrath_of_the_lich_king.cost']}'],
                ['Assistant.Professions.Apprentice.Enabled  =', f'Assistant.Professions.Apprentice.Enabled  = {'1' if settings['module.assistant.professions.apprentice.enabled'] else '0'}'],
                ['Assistant.Professions.Apprentice.Cost     =', f'Assistant.Professions.Apprentice.Cost     = {settings['module.assistant.professions.apprentice.cost']}'],
                ['Assistant.Professions.Journeyman.Enabled  =', f'Assistant.Professions.Journeyman.Enabled  = {'1' if settings['module.assistant.professions.journeyman.enabled'] else '0'}'],
                ['Assistant.Professions.Journeyman.Cost     =', f'Assistant.Professions.Journeyman.Cost     = {settings['module.assistant.professions.journeyman.cost']}'],
                ['Assistant.Professions.Expert.Enabled      =', f'Assistant.Professions.Expert.Enabled      = {'1' if settings['module.assistant.professions.expert.enabled'] else '0'}'],
                ['Assistant.Professions.Expert.Cost         =', f'Assistant.Professions.Expert.Cost         = {settings['module.assistant.professions.expert.cost']}'],
                ['Assistant.Professions.Artisan.Enabled     =', f'Assistant.Professions.Artisan.Enabled     = {'1' if settings['module.assistant.professions.artisan.enabled'] else '0'}'],
                ['Assistant.Professions.Artisan.Cost        =', f'Assistant.Professions.Artisan.Cost        = {settings['module.assistant.professions.artisan.cost']}'],
                ['Assistant.Professions.Master.Enabled      =', f'Assistant.Professions.Master.Enabled      = {'1' if settings['module.assistant.professions.master.enabled'] else '0'}'],
                ['Assistant.Professions.Master.Cost         =', f'Assistant.Professions.Master.Cost         = {settings['module.assistant.professions.master.cost']}'],
                ['Assistant.Professions.GrandMaster.Enabled =', f'Assistant.Professions.GrandMaster.Enabled = {'1' if settings['module.assistant.professions.grand_master.enabled'] else '0'}'],
                ['Assistant.Professions.GrandMaster.Cost    =', f'Assistant.Professions.GrandMaster.Cost    = {settings['module.assistant.professions.grand_master.cost']}'],
                ['Assistant.Instances.Enabled         =', f'Assistant.Instances.Enabled         = {'1' if settings['module.assistant.instances.enabled'] else '0'}'],
                ['Assistant.Instances.Heroic.Enabled  =', f'Assistant.Instances.Heroic.Enabled  = {'1' if settings['module.assistant.instances.heroic.enabled'] else '0'}'],
                ['Assistant.Instances.Heroic.Cost     =', f'Assistant.Instances.Heroic.Cost     = {settings['module.assistant.instances.heroic.cost']}'],
                ['Assistant.Instances.Raid.Enabled    =', f'Assistant.Instances.Raid.Enabled    = {'1' if settings['module.assistant.instances.raid.enabled'] else '0'}'],
                ['Assistant.Instances.Raid.Cost       =', f'Assistant.Instances.Raid.Cost       = {settings['module.assistant.instances.raid.cost']}'],
            ]
            UpdateConfig(f'{path}/modules/mod_assistant.conf', replacements)

        if settings['module.learnspells']:
            replacements = [
                ['LearnSpells.Gamemasters =', f'LearnSpells.Gamemasters = {'1' if settings['module.learnspells.gamemasters'] else '0'}'],
                ['LearnSpells.ClassSpells =', f'LearnSpells.ClassSpells = {'1' if settings['module.learnspells.class_spells'] else '0'}'],
                ['LearnSpells.TalentRanks =', f'LearnSpells.TalentRanks = {'1' if settings['module.learnspells.talent_ranks'] else '0'}'],
                ['LearnSpells.Proficiencies =', f'LearnSpells.Proficiencies = {'1' if settings['module.learnspells.proficiencies'] else '0'}'],
                ['LearnSpells.SpellsFromQuests =', f'LearnSpells.SpellsFromQuests = {'1' if settings['module.learnspells.spells_from_quests'] else '0'}'],
                ['LearnSpells.Riding.Apprentice =', f'LearnSpells.Riding.Apprentice = {'1' if settings['module.learnspells.riding.apprentice'] else '0'}'],
                ['LearnSpells.Riding.Journeyman =', f'LearnSpells.Riding.Journeyman = {'1' if settings['module.learnspells.riding.journeyman'] else '0'}'],
                ['LearnSpells.Riding.Expert =', f'LearnSpells.Riding.Expert = {'1' if settings['module.learnspells.riding.expert'] else '0'}'],
                ['LearnSpells.Riding.Artisan =', f'LearnSpells.Riding.Artisan = {'1' if settings['module.learnspells.riding.artisan'] else '0'}'],
                ['LearnSpells.Riding.ColdWeatherFlying =', f'LearnSpells.Riding.ColdWeatherFlying = {'1' if settings['module.learnspells.riding.cold_weather_flying'] else '0'}'],
            ]
            UpdateConfig(f'{path}/modules/mod_learnspells.conf', replacements)

        if settings['module.playerbots']:
            if settings['module.progression']:
                patch_id = settings['module.progression.patch']
                if patch_id < 12:
                    settings['module.playerbots.random_bots.max_level'] = 60
                    settings['module.playerbots.equipment_persistence.level'] = 60
                    settings['module.playerbots.random_bots.enabled_maps'] = '0,1'
                elif patch_id < 17:
                    settings['module.playerbots.random_bots.max_level'] = 70
                    settings['module.playerbots.equipment_persistence.level'] = 70
                    settings['module.playerbots.random_bots.enabled_maps'] = '0,1,530'

                if patch_id < 17:
                    settings['module.playerbots.random_bots.disable_death_knight'] = False

                if patch_id < 6:
                    settings['module.playerbots.random_bots.autogear_score_limit'] = 63
                elif patch_id < 7:
                    settings['module.playerbots.random_bots.autogear_score_limit'] = 66
                elif patch_id < 12:
                    settings['module.playerbots.random_bots.autogear_score_limit'] = 76
                elif patch_id < 13:
                    settings['module.playerbots.random_bots.autogear_score_limit'] = 110
                elif patch_id < 14:
                    settings['module.playerbots.random_bots.autogear_score_limit'] = 120
                elif patch_id < 17:
                    settings['module.playerbots.random_bots.autogear_score_limit'] = 133
                elif patch_id < 18:
                    settings['module.playerbots.random_bots.autogear_score_limit'] = 200
                elif patch_id < 19:
                    settings['module.playerbots.random_bots.autogear_score_limit'] = 213
                elif patch_id < 20:
                    settings['module.playerbots.random_bots.autogear_score_limit'] = 226
                elif patch_id < 21:
                    settings['module.playerbots.random_bots.autogear_score_limit'] = 245

                if patch_id < 19:
                    settings['module.playerbots.random_bots.autogear_quality_limit'] = 3
                else:
                    settings['module.playerbots.random_bots.autogear_quality_limit'] = 4

            replacements = [
                ['AiPlayerbot.RandomBotAccountCount =', f'AiPlayerbot.RandomBotAccountCount = {settings['module.playerbots.random_bots.accounts']}'],
                ['AiPlayerbot.MinRandomBots =', f'AiPlayerbot.MinRandomBots = {settings['module.playerbots.random_bots.minimum']}'],
                ['AiPlayerbot.MaxRandomBots =', f'AiPlayerbot.MaxRandomBots = {settings['module.playerbots.random_bots.maximum']}'],
                ['AiPlayerbot.MaxAddedBots =', f'AiPlayerbot.MaxAddedBots = {settings['module.playerbots.max_added']}'],
                ['AiPlayerbot.MaxAddedBotsPerClass =', f'AiPlayerbot.MaxAddedBotsPerClass = {settings['module.playerbots.max_added_per_class']}'],
                ['AiPlayerbot.AllowPlayerBots =', f'AiPlayerbot.AllowPlayerBots = {'1' if settings['module.playerbots.allow_player_bots'] else '0'}'],
                ['AiPlayerbot.SelfBotLevel =', f'AiPlayerbot.SelfBotLevel = {settings['module.playerbots.self_bot_level']}'],
                ['AiPlayerbot.AllowSummonInCombat =', f'AiPlayerbot.AllowSummonInCombat = {'1' if settings['module.playerbots.allow_summon_in_combat'] else '0'}'],
                ['AiPlayerbot.AllowSummonWhenMasterIsDead =', f'AiPlayerbot.AllowSummonWhenMasterIsDead = {'1' if settings['module.playerbots.allow_summon_when_master_dead'] else '0'}'],
                ['AiPlayerbot.AllowSummonWhenBotIsDead =', f'AiPlayerbot.AllowSummonWhenBotIsDead = {'1' if settings['module.playerbots.allow_summon_when_bot_dead'] else '0'}'],
                ['AiPlayerbot.ReviveBotWhenSummoned =', f'AiPlayerbot.ReviveBotWhenSummoned = {settings['module.playerbots.revive_when_summoned']}'],
                ['AiPlayerbot.BotRepairWhenSummon =', f'AiPlayerbot.BotRepairWhenSummon = {'1' if settings['module.playerbots.repair_when_summoned'] else '0'}'],
                ['AiPlayerbot.SayWhenCollectingItems =', f'AiPlayerbot.SayWhenCollectingItems = {'1' if settings['module.playerbots.say_when_collecting_items'] else '0'}'],
                ['AiPlayerbot.AutoAvoidAoe =', f'AiPlayerbot.AutoAvoidAoe = {'1' if settings['module.playerbots.auto_avoid_aoe'] else '0'}'],
                ['AiPlayerbot.TellWhenAvoidAoe =', f'AiPlayerbot.TellWhenAvoidAoe = {'1' if settings['module.playerbots.tell_when_avoid_aoe'] else '0'}'],
                ['AiPlayerbot.AutoGearQualityLimit =', f'AiPlayerbot.AutoGearQualityLimit = {settings['module.playerbots.autogear_quality_limit']}'],
                ['AiPlayerbot.AutoGearScoreLimit =', f'AiPlayerbot.AutoGearScoreLimit = {settings['module.playerbots.autogear_score_limit']}'],
                ['AiPlayerbot.RandomBotMinLevel =', f'AiPlayerbot.RandomBotMinLevel = {settings['module.playerbots.random_bots.min_level']}'],
                ['AiPlayerbot.RandomBotMaxLevel =', f'AiPlayerbot.RandomBotMaxLevel = {settings['module.playerbots.random_bots.max_level']}'],
                ['AiPlayerbot.DisableDeathKnightLogin =', f'AiPlayerbot.DisableDeathKnightLogin = {'1' if settings['module.playerbots.random_bots.disable_death_knight'] else '0'}'],
                ['AiPlayerbot.DisableRandomLevels =', f'AiPlayerbot.DisableRandomLevels = {'1' if settings['module.playerbots.random_bots.disable_random_levels'] else '0'}'],
                ['AiPlayerbot.RandombotStartingLevel =', f'AiPlayerbot.RandombotStartingLevel = {settings['module.playerbots.random_bots.starting_level']}'],
                ['AiPlayerbot.RandomGearQualityLimit =', f'AiPlayerbot.RandomGearQualityLimit = {settings['module.playerbots.random_bots.autogear_quality_limit']}'],
                ['AiPlayerbot.RandomGearScoreLimit =', f'AiPlayerbot.RandomGearScoreLimit = {settings['module.playerbots.random_bots.autogear_score_limit']}'],
                ['AiPlayerbot.LimitEnchantExpansion =', f'AiPlayerbot.LimitEnchantExpansion = {'1' if settings['module.playerbots.limit_enchant_by_expansion'] else '0'}'],
                ['AiPlayerbot.LimitGearExpansion =', f'AiPlayerbot.LimitGearExpansion = {'1' if settings['module.playerbots.limit_gear_by_expansion'] else '0'}'],
                ['AiPlayerbot.EquipmentPersistence =', f'AiPlayerbot.EquipmentPersistence = {'1' if settings['module.playerbots.equipment_persistence.enabled'] else '0'}'],
                ['AiPlayerbot.EquipmentPersistenceLevel =', f'AiPlayerbot.EquipmentPersistenceLevel = {settings['module.playerbots.equipment_persistence.level']}'],
                ['AiPlayerbot.RandomBotGroupNearby =', f'AiPlayerbot.RandomBotGroupNearby = {'1' if settings['module.playerbots.random_bots.group_with_nearby'] else '0'}'],
                ['AiPlayerbot.RandomBotMaps =', f'AiPlayerbot.RandomBotMaps = {settings['module.playerbots.random_bots.enabled_maps']}'],
                ['AiPlayerbot.RandomBotAutoJoinBG =', f'AiPlayerbot.RandomBotAutoJoinBG = {'1' if settings['module.playerbots.random_bots.auto_join_battlegrounds'] else '0'}'],
                ['AiPlayerbot.RandomBotArenaTeam2v2Count =', f'AiPlayerbot.RandomBotArenaTeam2v2Count = {settings['module.playerbots.random_bots.arena_teams.2v2']}'],
                ['AiPlayerbot.RandomBotArenaTeam3v3Count =', f'AiPlayerbot.RandomBotArenaTeam3v3Count = {settings['module.playerbots.random_bots.arena_teams.3v3']}'],
                ['AiPlayerbot.RandomBotArenaTeam5v5Count =', f'AiPlayerbot.RandomBotArenaTeam5v5Count = {settings['module.playerbots.random_bots.arena_teams.5v5']}'],
                ['PlayerbotsDatabaseInfo =', f'PlayerbotsDatabaseInfo = "{settings['database.host']};{settings['database.port']};{settings['database.username']};{settings['database.password']};{settings['database.playerbots']}"'],
                ['AiPlayerbot.RandomBotTalk =', 'AiPlayerbot.RandomBotTalk = 0'],
                ['AiPlayerbot.RandomBotSuggestDungeons =', 'AiPlayerbot.RandomBotSuggestDungeons = 0'],
                ['AiPlayerbot.ToxicLinksRepliesChance =', 'AiPlayerbot.ToxicLinksRepliesChance = 0'],
                ['AiPlayerbot.ThunderfuryRepliesChance =', 'AiPlayerbot.ThunderfuryRepliesChance = 0'],
                ['AiPlayerbot.GuildRepliesRate =', 'AiPlayerbot.GuildRepliesRate = 0'],
                ['AIPlayerbot.GuildFeedback =', 'AIPlayerbot.GuildFeedback = 0'],
                ['AiPlayerbot.EnableBroadcasts =', 'AiPlayerbot.EnableBroadcasts = 0'],
                ['AiPlayerbot.DisableDeathKnightLogin =', f'AiPlayerbot.DisableDeathKnightLogin = {'1' if settings['world.expansion'] < 2 or settings['module.progression.patch'] < 17 else '0'}']
            ]

            # ['AiPlayerbot.RandomBotUpdateInterval =', 'AiPlayerbot.RandomBotUpdateInterval = 1'],
            UpdateConfig(f'{path}/modules/playerbots.conf', replacements)

        if settings['module.progression']:
            replacements = [
                ['Progression.Patch =', f'Progression.Patch = {settings['module.progression.patch']}'],
                ['Progression.IcecrownCitadel.Aura =', f'Progression.IcecrownCitadel.Aura = {settings['module.progression.aura']}'],
                ['Progression.Level.Enforced =', 'Progression.Level.Enforced = 1'],
                ['Progression.DungeonFinder.Enforced =', 'Progression.DungeonFinder.Enforced = 1'],
                ['Progression.DualTalent.Enforced =', 'Progression.DualTalent.Enforced = 1' ],
                ['Progression.Multiplier.Damage =', f'Progression.Multiplier.Damage = {settings['module.progression.multiplier.damage']}'],
                ['Progression.Multiplier.Healing =', f'Progression.Multiplier.Healing = {settings['module.progression.multiplier.healing']}'],
                ['Progression.Reset =', f'Progression.Reset = {'1' if settings['module.progression.reset'] else '0'}']
            ]
            UpdateConfig(f'{path}/modules/mod_progression.conf', replacements)

        if settings['module.recruitafriend']:
            replacements = [
                ['RecruitAFriend.Duration =', f'RecruitAFriend.Duration = {settings['module.recruitafriend.duration']}'],
                ['RecruitAFriend.MaxAccountAge =', f'RecruitAFriend.MaxAccountAge = {settings['module.recruitafriend.max_account_age']}'],
                ['RecruitAFriend.Rewards.Days =', f'RecruitAFriend.Rewards.Days = {settings['module.recruitafriend.rewards.days']}'],
                ['RecruitAFriend.Rewards.SwiftZhevra =', f'RecruitAFriend.Rewards.SwiftZhevra = {'1' if settings['module.recruitafriend.rewards.swift_zhevra'] else '0'}'],
                ['RecruitAFriend.Rewards.TouringRocket =', f'RecruitAFriend.Rewards.TouringRocket = {'1' if settings['module.recruitafriend.rewards.touring_rocket'] else '0'}'],
                ['RecruitAFriend.Rewards.CelestialSteed =', f'RecruitAFriend.Rewards.CelestialSteed = {'1' if settings['module.recruitafriend.rewards.celestial_steed'] else '0'}'],
            ]
            UpdateConfig(f'{path}/modules/mod_recruitafriend.conf', replacements)

        if settings['module.skip_dk_starting_area']:
            replacements = [
                ['Skip.Deathknight.Starter.Announce.enable =', 'Skip.Deathknight.Starter.Announce.enable = 0'],
            ]
            UpdateConfig(f'{path}/modules/skip_dk_module.conf', replacements)

    PrintHeader('Finished updating the config files...')

#
#######################################################################

#######################################################################
# DBC
#

def CopyDBCFiles():
    PrintHeader('Copying modified client data files...')

    if settings['build.world']:
        path = f'{cwd}/dbc'
        files = sorted(os.listdir(path))
        if len(files) > 0:
            for file in files:
                if os.path.isfile(f'{path}/{file}'):
                    if file.endswith('.dbc'):
                        PrintProgress(f'Copying {file}')
                        shutil.copyfile(f'{path}/{file}', f'{GetDataPath()}/dbc/{file}')
        else:
            PrintProgress('No files found in the directory')
    else:
        PrintProgress('Skipping process due to world server being disabled')

    PrintHeader('Finished copying modified client data files...')

#
#######################################################################

#######################################################################
# PROCESSES
#

def IsScreenActive(name):
    try:
        subprocess.check_output([f'screen -list | grep -E "{name}"'], shell=True)
        return True
    except subprocess.CalledProcessError:
        return False

def StartProcess(name):
    subprocess.run(f'cd {source}/bin && ./{name}', shell=True)

def SendShutdown():
    subprocess.run(f'screen -S world-{settings['world.id']} -p 0 -X stuff "server shutdown 10^m"', shell=True)

def WaitForShutdown():
    for c in range(1,30):
        if not IsScreenActive(f'world-{settings['world.id']}'):
            return
        time.sleep(1)
        

def StartServer():
    PrintHeader('Starting the server...')

    if (settings['build.auth'] and not IsScreenActive('auth')) or (settings['build.world'] and not IsScreenActive(f'world-{settings['world.id']}')):
        StartProcess('start.sh')

        if settings['build.auth'] and IsScreenActive('auth'):
            PrintProgress('To access the screen of the authserver, use the command screen -r auth')

        if settings['build.world'] and IsScreenActive(f'world-{settings['world.id']}'):
            PrintProgress(f'To access the screen of the worldserver, use the command screen -r world-{settings['world.id']}')
    else:
        PrintError('The server is already running')

    PrintHeader('Finished starting the server...')

def StopServer():
    PrintHeader('Stopping the server...')

    if (settings['build.auth'] and IsScreenActive('auth')) or (settings['build.world'] and IsScreenActive(f'world-{settings['world.id']}')):
        if settings['build.world'] and IsScreenActive(f'world-{settings['world.id']}'):
            PrintProgress('Telling the world server to shut down')
            SendShutdown()
            WaitForShutdown()

        StartProcess('stop.sh')
    else:
        PrintError('The server is not running')

    PrintHeader('Finished stopping the server...')

def RestartServer():
    StopServer()
    StartServer()

#
#######################################################################

#######################################################################
# INIT
#

os.system('cls' if os.name == 'nt' else 'clear')

if not settings['build.auth'] and not settings['build.world']:
    PrintError('Auth and world are both disabled in the settings')
    exit()

if not CheckArgument():
    ListArguments()
    exit()

#
#######################################################################

if SelectArgument() == 'install':
    if os.name != 'nt':
        StopServer()
    DoInstall()
elif SelectArgument() == 'database':
    ImportDatabases()
elif SelectArgument() == 'config':
    UpdateConfigs()
elif SelectArgument() == 'dbc':
    CopyDBCFiles()
elif SelectArgument() == 'reset':
    if os.name != 'nt':
        StopServer()
    ResetDatabase()
elif SelectArgument() == 'all':
    if os.name != 'nt':
        StopServer()
    DoInstall()
    ImportDatabases()
    UpdateConfigs()
    CopyDBCFiles()
    if os.name != 'nt':
        StartServer()
elif SelectArgument() == 'start':
    if os.name == 'nt':
        PrintError('This argument is only available on Linux')
        exit()
    StartServer()
elif SelectArgument() == 'stop':
    if os.name == 'nt':
        PrintError('This argument is only available on Linux')
        exit()
    StopServer()
elif SelectArgument() == 'restart':
    if os.name == 'nt':
        PrintError('This argument is only available on Linux')
        exit()
    StopServer()
    StartServer()
