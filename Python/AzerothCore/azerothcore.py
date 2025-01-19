# ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
# ALTER USER 'acore'@'127.0.0.1' IDENTIFIED WITH caching_sha2_password BY 'acore';

# Install MySQL Server 8.4 on Linux:
# wget https://repo.mysql.com/mysql-apt-config_0.8.32-1_all.deb
# dpkg -i mysql-apt-config_0.8.32-1_all.deb
# apt update
# apt install -y mysql-server

# apt install -y git curl screen cmake make gcc clang g++ libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost1.83-all-dev libmysqlclient-dev mysql-client python3-git python3-requests python3-tqdm python3-pymysql python3-colorama

# Windows prerequisites:
# pip install colorama gitpython pymysql requests tqdm cryptography

from pathlib import Path
from tqdm import tqdm
import colorama
import git
import hashlib
import multiprocessing
import os
import pymysql
import requests
import shutil
import subprocess
import stat
import sys
import time

if os.name == 'nt':
    colorama.just_fix_windows_console()

##################################################

cwd = os.getcwd()
source = f'{cwd}/source'
build = f'{source}/build'
mysqlcnf = f'{cwd}/mysql.cnf'

realm_id = 1
mysql_hostname = '127.0.0.1'
mysql_port = 3306
mysql_username = 'acore'
mysql_password = 'acore'
mysql_database = 'acore_auth'

realm_port = 29724 + realm_id

map_update_threads = multiprocessing.cpu_count()

windows_paths = {
    'msbuild': 'C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/MSBuild/Current/Bin',
    'mysql': 'C:/Program Files/MySQL/MySQL Server 8.4',
    'openssl': 'C:/Program Files/OpenSSL-Win64',
    'cmake': 'C:/Program Files/CMake'
}

##################################################

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

##################################################

arguments = [
    [ [ 'install', 'setup', 'update' ], 'Downloads the source code, with enabled modules, and compiles it. Also downloads client files' ],
    [ [ 'database', 'db' ], 'Import all files to the specified databases' ],
    [ [ 'config', 'conf', 'cfg', 'settings', 'options' ], 'Updates all config files, including enabled modules, with options specified' ],
    [ 'dbc', 'Copy modified client data files to the proper folder' ],
    [ 'lua', 'Copy lua scripts to the proper folder' ],
    [ 'reset', 'Drops all database tables from the world database' ],
    [ 'all', 'Run all parameters listed above, excluding reset but including stop and start' ],
    [ 'start', 'Starts the compiled processes, based off of the choice for compilation' ],
    [ 'stop', 'Stops the compiled processes, based off of the choice for compilation' ],
    [ 'restart', 'Stops and then starts the compiled processes, based off of the choice for compilation' ],
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

##################################################

options = {
    'build.auth': True,
    'build.world': True,
    'database.auth': 'acore_auth',
    'database.characters': 'acore_characters',
    'database.playerbots': 'acore_playerbots',
    'database.world': 'acore_world',
    'git.branch': 'master',
    'git.repository': 'azerothcore/azerothcore-wotlk',
    'git.use_ssh': False,
    'module.ah_bot.enabled': False,
    'module.ah_bot.account_id': 0,
    'module.ah_bot.buyer.enabled': False,
    'module.ah_bot.character_guid': 0,
    'module.ah_bot.seller.enabled': False,
    'module.appreciation.enabled': False,
    'module.assistant.enabled': False,
    'module.eluna.enabled': False,
    'module.fixes.enabled': False,
    'module.gamemaster.enabled': False,
    'module.groupquests.enabled': False,
    'module.junktogold.enabled': False,
    'module.learnspells.enabled': False,
    'module.playerbots.enabled': False,
    'module.playerbots.random_bots.accounts': 200,
    'module.playerbots.random_bots.active_alone': 100,
    'module.playerbots.random_bots.maximum': 50,
    'module.playerbots.random_bots.minimum': 50,
    'module.playerbots.random_bots.smart_scale': False,
    'module.recruitafriend.enabled': False,
    'module.skip_dk_starting_area.enabled': False,
    'module.weekendbonus.enabled': False,
    'telegram.chat_id': 0,
    'telegram.token': 0,
    'world.address': '127.0.0.1',
    'world.data_directory': '.',
    'world.game_type': 0,
    'world.local_address': '127.0.0.1',
    'world.name': 'AzerothCore',
    'world.preload_grids': False,
    'world.progression.aura': 4,
    'world.progression.multiplier.damage': 0.6,
    'world.progression.multiplier.healing': 0.5,
    'world.progression.patch': 21,
    'world.realm_zone': 1,
    'world.set_creatures_active': False,
    'world.warden': True
}

PrintHeader('Loading options from the database...')

try:
    connect = pymysql.connect(host=mysql_hostname, port=mysql_port, user=mysql_username, password=mysql_password, db=mysql_database)
    cursor = connect.cursor()
    cursor.execute(f'WITH s AS (SELECT id, setting, VALUE, ROW_NUMBER() OVER (PARTITION BY setting ORDER BY id DESC) nr FROM realm_settings WHERE (id = {realm_id} OR id = -1)) SELECT setting, value FROM s WHERE nr = 1;')

    settings = []
    for row in cursor.fetchall():
        settings.append([row[0], row[1]])

    cursor.close()
    connect.close()

    for entry in settings:
        if entry[0] in options:
            if entry[1] == 'true':
                options[entry[0]] = True
            elif entry[1] == 'false':
                options[entry[0]] = False
            else:
                options[entry[0]] = entry[1]

        PrintProgress(f'{entry[0]} has been set to {entry[1]}')
except:
    HandleError('An error occurred while fetching options from the database')

PrintHeader('Finished loading options from the database...')

##################################################

modules = [
    ['mod-ah-bot', 'noisiver/mod-ah-bot', 'noisiver', options['module.ah_bot.enabled'], 0],
    ['mod-appreciation', 'noisiver/mod-appreciation', 'master', options['module.appreciation.enabled'], 12],
    ['mod-assistant', 'noisiver/mod-assistant', 'master', options['module.assistant.enabled'], 0],
    ['mod-eluna', 'azerothcore/mod-eluna', 'master', options['module.eluna.enabled'], 0],
    ['mod-fixes', 'noisiver/mod-fixes', 'master', options['module.fixes.enabled'], 17],
    ['mod-gamemaster', 'noisiver/mod-gamemaster', 'master', options['module.gamemaster.enabled'], 0],
    ['mod-groupquests', 'noisiver/mod-groupquests', 'master', options['module.groupquests.enabled'], 0],
    ['mod-junk-to-gold', 'noisiver/mod-junk-to-gold', 'master', options['module.junktogold.enabled'], 0],
    ['mod-learnspells', 'noisiver/mod-learnspells', 'progression', options['module.learnspells.enabled'], 0],
    ['mod-playerbots', 'noisiver/mod-playerbots', 'noisiver', options['module.playerbots.enabled'], 0],
    ['mod-recruitafriend', 'noisiver/mod-recruitafriend', 'master', options['module.recruitafriend.enabled'], 17],
    ['mod-skip-dk-starting-area', 'noisiver/mod-skip-dk-starting-area', 'noisiver', options['module.skip_dk_starting_area.enabled'], 17],
    ['mod-stop-killing-them', 'noisiver/mod-stop-killing-them', 'master', True, 0],
    ['mod-weekendbonus', 'noisiver/mod-weekendbonus', 'master', options['module.weekendbonus.enabled'], 0]
]

folders = [
    [f'{cwd}/dbc', True, True],
    [f'{cwd}/logs', False, True],
    [f'{cwd}/sql', False, True],
    [f'{cwd}/sql/auth', False, True],
    [f'{cwd}/sql/characters', True, True],
    [f'{cwd}/sql/world', True, True],
    [f'{cwd}/lua', True, options['module.eluna.enabled']]
]

for folder in folders:
    name = folder[0]
    world_only = folder[1]
    enabled = folder[2]

    if options['build.auth'] and not options['build.world'] and world_only:
        continue

    if not enabled:
        continue

    if not os.path.isdir(name):
        os.mkdir(name, 0o777)

##################################################

class GitProgress(git.remote.RemoteProgress):
    def line_dropped(self, line):
        print(line)
    def update(self, *args):
        print(self._cur_line)

def ResetSource(path, branch):
    repo = git.Repo(path)
    repo.git.reset('--hard', f'origin/{branch}')

def CloneSource(path, repo, branch):
    git.Repo.clone_from(url=repo, to_path=path, branch=branch, depth=1, single_branch=True, progress=GitProgress())

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

    UpdateSource(source, f'{cmd}{options['git.repository']}.git', f'{options['git.branch']}', 'azerothcore')

    for module in modules:
        path = f'{source}/modules/{module[0]}'
        repo = module[1]
        branch = module[2]
        enabled = module[3]
        patch = module[4]

        if options['build.world'] and enabled and int(options['world.progression.patch']) >= patch:
            UpdateSource(path, f'{cmd}{repo}', branch, module[0])
        else:
            if os.path.exists(path) and os.path.isdir(path):
                git.rmtree(path)

    PrintHeader('Finished downloading source code...')

def GenerateProject():
    PrintHeader('Generating project files...')

    if options['build.auth'] and options['build.world']:
        apps = 'all'
    elif options['build.auth']:
        apps = 'auth-only'
    elif options['build.world']:
        apps = 'world-only'

    args = [
        f'-S {source}',
        f'-B {build}',
        '-DWITH_WARNINGS=0',
        '-DSCRIPTS=static',
        f'-DAPPS_BUILD={apps}'
    ]

    if os.name == 'nt':
        args.append(f'-DMYSQL_EXECUTABLE={windows_paths['mysql']}/bin/mysql.exe')
        args.append(f'-DMYSQL_INCLUDE_DIR={windows_paths['mysql']}/include')
        args.append(f'-DMYSQL_LIBRARY={windows_paths['mysql']}/lib/libmysql.lib')
    else:
        args.append(f'-DCMAKE_INSTALL_PREFIX={source}')
        args.append('-DCMAKE_C_COMPILER=/usr/bin/clang')
        args.append('-DCMAKE_CXX_COMPILER=/usr/bin/clang++')
        args.append('-DCMAKE_CXX_FLAGS="-w"')

    try:
        subprocess.run([f'{windows_paths['cmake']}/bin/cmake.exe' if os.name == 'nt' else 'cmake', *args], check=True)
    except:
        HandleError('An error occurred while generating the project files')

    PrintHeader('Finished generating project files...')

def CleanSource():
    if os.name == 'nt':
        args = [f'{build}/AzerothCore.sln', '/t:Clean']
    else:
        args = ['clean']

    try:
        subprocess.run([f'{windows_paths['msbuild']}/MSBuild.exe' if os.name == 'nt' else 'make', *args], cwd=build, check=True)
    except:
        HandleError('An error occurred while compiling the source code')

def CompileSource():
    PrintHeader('Compiling the source code...')

    if os.name == 'nt':
        args = [f'{build}/AzerothCore.sln', '/p:Configuration=RelWithDebInfo', '/p:WarningLevel=0']

        if options['build.auth'] and not options['build.world']:
            args.append('/target:authserver')
        elif not options['build.auth'] and options['build.world']:
            args.append('/target:worldserver')
        else:
            args.append('/target:ALL_BUILD')
    else:
        args = ['-j', str(multiprocessing.cpu_count()), 'install']

    attempts = 1
    while attempts < 3:
        try:
            subprocess.run([f'{windows_paths['msbuild']}/MSBuild.exe' if os.name == 'nt' else 'make', *args], cwd=build, check=True)
            break
        except:
            CleanSource()
            attempts += 1
            if attempts == 2:
                HandleError('An error occurred while compiling the source code')

    PrintHeader('Finished compiling the source code...')

def CreateScript(name, path, text):
    PrintProgress(f'Creating {name}')
    file = open(f'{path}/{name}', 'w')
    file.write(text)
    file.close()
    f = Path(f'{path}/{name}')
    f.chmod(f.stat().st_mode | stat.S_IEXEC)

def CreateScripts():
    if os.name == 'nt':
        if options['build.auth']:
            text = '@echo off\ncd source/build/bin/RelWithDebInfo\n:auth\n    authserver.exe\ngoto auth\n'
            CreateScript('auth.bat', cwd, text)

        if options['build.world']:
            text = '@echo off\ncd source/build/bin/RelWithDebInfo\n:world\n    worldserver.exe\n    timeout 10\ngoto world\n'
            CreateScript('world.bat', cwd, text)
    else:
        text = '#!/bin/bash\n'
        if options['build.auth']:
            text += 'screen -AmdS auth ./auth.sh\n'
        if options['build.world']:
            text += f'time=$(date +%s)\n'
            text += f'screen -L -Logfile $time.log -AmdS world-{realm_id} ./world.sh\n'
        CreateScript('start.sh', f'{source}/bin', text)

        text = '#!/bin/bash\n'
        if options['build.auth']:
            text += 'screen -X -S "auth" quit\n'
        if options['build.world']:
            text += f'screen -X -S "world-{realm_id}" quit\n'
        CreateScript('stop.sh', f'{source}/bin', text)

        if options['build.auth']:
            text = '#!/bin/bash\nwhile :; do\n    ./authserver\n    sleep 5\ndone\n'
            CreateScript('auth.sh', f'{source}/bin', text)

        if options['build.world']:
            text = '#!/bin/bash\nwhile :; do\n    nice -n -19 ./worldserver\n    if [[ $? == 0 ]]; then\n      break\n    fi\n    sleep 5\ndone\n'
            CreateScript('world.sh', f'{source}/bin', text)

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

def GetDataPath():
    data_dir = options['world.data_directory']
    binary_path = f'{build}/bin/RelWithDebInfo' if os.name == 'nt' else f'{source}/bin'
    if data_dir == '.':
        target = binary_path
    elif data_dir.startswith('./'):
        target = f'{binary_path}/{data_dir.replace('./', '')}'
    else:
        target = data_dir
    return target

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
    try:
        data = sorted(g.ls_remote('--tags', 'https://github.com/wowgaming/client-data.git').split('\n'), reverse=True)
    except Exception as e:
        print(e.stderr)
        HandleError('An error occurred while fetching the latest client data version')
    return data[0].rsplit('/', 1)[1].replace('v', '')

def DeleteClientData():
    dirs = ['Cameras', 'dbc', 'maps', 'mmaps', 'vmaps']
    for dir in dirs:
        if os.path.exists(f'{GetDataPath()}/{dir}'):
            shutil.rmtree(f'{GetDataPath()}/{dir}')

def DownloadClientData(version):
    url = f'https://github.com/wowgaming/client-data/releases/download/v{version}/data.zip'
    file_name = f'{cwd}/data.zip'

    try:
        PrintProgress('Downloading archive')
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
    except:
        HandleError('An error occurred while downloading the client data files')

def UnpackDataFiles():
    try:
        PrintProgress('Unpacking archive')
        shutil.unpack_archive(f'{cwd}/data.zip', GetDataPath())
    except Exception as e:
        print(e.stderr)
        HandleError('An error occurred while unpacking the client data files')

def UpdateDataVersion(version):
    file = open(f'{GetDataPath()}/data.version', 'w')
    file.write(version)
    file.close()

def UpdateClientData():
    if options['build.world']:
        PrintHeader('Downloading client data files...')

        local_version = GetLocalDataVersion()
        remote_version = GetRemoteDataVersion()

        if local_version != remote_version:
            DeleteClientData()
            DownloadClientData(remote_version)
            UnpackDataFiles()
            UpdateDataVersion(remote_version)
        else:
            PrintProgress('The files are up-to-date')

        if os.path.exists(f'{cwd}/data.zip'):
            os.remove(f'{cwd}/data.zip')

        PrintHeader('Finished downloading client data files...')

def CopyDBCFiles():
    if options['build.world']:
        PrintHeader('Copying modified client data files...')

        files = sorted(os.listdir(f'{cwd}/dbc'))
        if len(files) > 0:
            for file in files:
                if os.path.isfile(f'{cwd}/dbc/{file}'):
                    if file.endswith('.dbc'):
                        PrintProgress(f'Copying {file}')
                        shutil.copyfile(f'{cwd}/dbc/{file}', f'{GetDataPath()}/dbc/{file}')
        else:
            PrintProgress('No files found in the directory')

        PrintHeader('Finished copying modified client data files...')

def CopyLuaScripts():
    if options['module.eluna.enabled']:
        PrintHeader('Copying lua scripts...')

        files = sorted(os.listdir(f'{cwd}/lua'))
        if len(files) > 0:
            for file in files:
                if os.path.isfile(f'{cwd}/lua/{file}'):
                    if file.endswith('.lua'):
                        PrintProgress(f'Copying {file}')
                        shutil.copyfile(f'{cwd}/lua/{file}', f'{build}/bin/RelWithDebInfo/lua_scripts/{file}' if os.name == 'nt' else f'{cwd}/bin/lua_scripts/{file}')
        else:
            PrintProgress('No files found in the directory')

        PrintHeader('Finished copying lua scripts...')

def Install():
    DownloadSource()
    GenerateProject()
    CompileSource()
    CreateScripts()
    if os.name == 'nt':
        CopyLibraries()

##################################################

if int(options['world.progression.patch']) < 6:
    ahbot_max_item_level = 63
elif int(options['world.progression.patch']) < 7:
    ahbot_max_item_level = 66
elif int(options['world.progression.patch']) < 12:
    ahbot_max_item_level = 76
elif int(options['world.progression.patch']) < 13:
    ahbot_max_item_level = 110
elif int(options['world.progression.patch']) < 14:
    ahbot_max_item_level = 120
elif int(options['world.progression.patch']) < 17:
    ahbot_max_item_level = 133
elif int(options['world.progression.patch']) < 18:
    ahbot_max_item_level = 200
elif int(options['world.progression.patch']) < 19:
    ahbot_max_item_level = 213
elif int(options['world.progression.patch']) < 20:
    ahbot_max_item_level = 226
elif int(options['world.progression.patch']) < 21:
    ahbot_max_item_level = 245
else:
    ahbot_max_item_level = 0

if int(options['world.progression.patch']) < 12:
    playerbots_starting_level = 50
    playerbots_maps = '0,1'
    playerbots_warrior_glyphs_1 = '0,0,0,0,0,0'
    playerbots_warrior_spec_1_60 = '30220321233351000021-30505300002'
    playerbots_warrior_spec_1_80 = playerbots_warrior_spec_1_60
    playerbots_warrior_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_warrior_spec_2_60 = '30202301233-325000005502310051'
    playerbots_warrior_spec_2_80 = playerbots_warrior_spec_2_60
    playerbots_warrior_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_warrior_spec_3_60 = '352000001-3-05335122500021251'
    playerbots_warrior_spec_3_80 = playerbots_warrior_spec_3_60
    playerbots_paladin_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_paladin_spec_1_60 = '50350152020013251-5002-05202'
    playerbots_paladin_spec_1_80 = playerbots_paladin_spec_1_60
    playerbots_paladin_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_paladin_spec_2_60 = '-0500513520310231-502302500003'
    playerbots_paladin_spec_2_80 = playerbots_paladin_spec_2_60
    playerbots_paladin_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_paladin_spec_3_60 = '-453201002-05232051203331301'
    playerbots_paladin_spec_3_65 = playerbots_paladin_spec_3_60
    playerbots_paladin_spec_3_80 = playerbots_paladin_spec_3_60
    playerbots_hunter_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_hunter_spec_1_60 = '51200201515012241-005305001-5'
    playerbots_hunter_spec_1_80 = playerbots_hunter_spec_1_60
    playerbots_hunter_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_hunter_spec_2_60 = '502-035305231230013231-5000002'
    playerbots_hunter_spec_2_80 = playerbots_hunter_spec_2_60
    playerbots_hunter_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_hunter_spec_3_60 = '-005305101-5000032500033330531'
    playerbots_hunter_spec_3_80 = playerbots_hunter_spec_3_60
    playerbots_rogue_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_rogue_spec_1_60 = '005303005350102501-005005001-502'
    playerbots_rogue_spec_1_80 = playerbots_rogue_spec_1_60
    playerbots_rogue_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_rogue_spec_2_60 = '00532000531-0252051000035015201'
    playerbots_rogue_spec_2_80 = playerbots_rogue_spec_2_60
    playerbots_rogue_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_rogue_spec_3_60 = '3053031-3-5320232030300121051'
    playerbots_rogue_spec_3_80 = playerbots_rogue_spec_3_60
    playerbots_priest_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_priest_spec_1_60 = '050320313030051231-2055100303'
    playerbots_priest_spec_1_80 = playerbots_priest_spec_1_60
    playerbots_priest_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_priest_spec_2_60 = '0503203-23505103030215251'
    playerbots_priest_spec_2_80 = playerbots_priest_spec_2_60
    playerbots_priest_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_priest_spec_3_60 = '05032031--3250230512230102231'
    playerbots_priest_spec_3_80 = playerbots_priest_spec_3_60
    playerbots_shaman_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_shaman_spec_1_60 = '3530001523213351-005050031'
    playerbots_shaman_spec_1_80 = playerbots_shaman_spec_1_60
    playerbots_shaman_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_shaman_spec_2_60 = '053030051-3020503300502133301'
    playerbots_shaman_spec_2_80 = playerbots_shaman_spec_2_60
    playerbots_shaman_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_shaman_spec_3_60 = '-0050503-0500533133531051'
    playerbots_shaman_spec_3_80 = playerbots_shaman_spec_3_60
    playerbots_mage_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_mage_spec_1_60 = '235005030100330150321-03-023023001'
    playerbots_mage_spec_1_80 = playerbots_mage_spec_1_60
    playerbots_mage_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_mage_spec_2_60 = '2300230311-0055032012303330051'
    playerbots_mage_spec_2_80 = playerbots_mage_spec_2_60
    playerbots_mage_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_mage_spec_3_60 = '23000503310003--0533030310233100031'
    playerbots_mage_spec_3_80 = playerbots_mage_spec_3_60
    playerbots_warlock_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_warlock_spec_1_60 = '235002203102351025--55000005'
    playerbots_warlock_spec_1_70 = playerbots_warlock_spec_1_60
    playerbots_warlock_spec_1_80 = playerbots_warlock_spec_1_60
    playerbots_warlock_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_warlock_spec_2_60 = '002-203203301035012531-55000005'
    playerbots_warlock_spec_2_70 = playerbots_warlock_spec_2_60
    playerbots_warlock_spec_2_80 = playerbots_warlock_spec_2_60
    playerbots_warlock_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_warlock_spec_3_60 = '025-03310030003-05203205220031051'
    playerbots_warlock_spec_3_80 = playerbots_warlock_spec_3_60
    playerbots_druid_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_druid_spec_1_60 = '503210312533130321--205003012'
    playerbots_druid_spec_1_80 = playerbots_druid_spec_1_60
    playerbots_druid_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_druid_spec_2_60 = '-5332321323220103531-205'
    playerbots_druid_spec_2_80 = playerbots_druid_spec_2_60
    playerbots_druid_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_druid_spec_3_60 = '05320001--23003331253151251'
    playerbots_druid_spec_3_80 = playerbots_druid_spec_3_60
    playerbots_druid_glyphs_4 = playerbots_warrior_glyphs_1
    playerbots_druid_spec_4_60 = '-5532020323220100531-205003002'
    playerbots_druid_spec_4_80 = playerbots_druid_spec_4_60
elif int(options['world.progression.patch']) < 17:
    playerbots_starting_level = 60
    playerbots_maps = '0,1,530'
    playerbots_warrior_glyphs_1 = '0,0,0,0,0,0'
    playerbots_warrior_spec_1_60 = ''
    playerbots_warrior_spec_1_80 = playerbots_warrior_spec_1_60
    playerbots_warrior_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_warrior_spec_2_60 = ''
    playerbots_warrior_spec_2_80 = playerbots_warrior_spec_2_60
    playerbots_warrior_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_warrior_spec_3_60 = ''
    playerbots_warrior_spec_3_80 = playerbots_warrior_spec_3_60
    playerbots_paladin_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_paladin_spec_1_60 = ''
    playerbots_paladin_spec_1_80 = playerbots_paladin_spec_1_60
    playerbots_paladin_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_paladin_spec_2_60 = ''
    playerbots_paladin_spec_2_80 = playerbots_paladin_spec_2_60
    playerbots_paladin_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_paladin_spec_3_60 = ''
    playerbots_paladin_spec_3_65 = playerbots_paladin_spec_3_60
    playerbots_paladin_spec_3_80 = playerbots_paladin_spec_3_60
    playerbots_hunter_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_hunter_spec_1_60 = ''
    playerbots_hunter_spec_1_80 = playerbots_hunter_spec_1_60
    playerbots_hunter_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_hunter_spec_2_60 = ''
    playerbots_hunter_spec_2_80 = playerbots_hunter_spec_2_60
    playerbots_hunter_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_hunter_spec_3_60 = ''
    playerbots_hunter_spec_3_80 = playerbots_hunter_spec_3_60
    playerbots_rogue_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_rogue_spec_1_60 = ''
    playerbots_rogue_spec_1_80 = playerbots_rogue_spec_1_60
    playerbots_rogue_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_rogue_spec_2_60 = ''
    playerbots_rogue_spec_2_80 = playerbots_rogue_spec_2_60
    playerbots_rogue_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_rogue_spec_3_60 = ''
    playerbots_rogue_spec_3_80 = playerbots_rogue_spec_3_60
    playerbots_priest_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_priest_spec_1_60 = ''
    playerbots_priest_spec_1_80 = playerbots_priest_spec_1_60
    playerbots_priest_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_priest_spec_2_60 = ''
    playerbots_priest_spec_2_80 = playerbots_priest_spec_2_60
    playerbots_priest_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_priest_spec_3_60 = ''
    playerbots_priest_spec_3_80 = playerbots_priest_spec_3_60
    playerbots_shaman_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_shaman_spec_1_60 = ''
    playerbots_shaman_spec_1_80 = playerbots_shaman_spec_1_60
    playerbots_shaman_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_shaman_spec_2_60 = ''
    playerbots_shaman_spec_2_80 = playerbots_shaman_spec_2_60
    playerbots_shaman_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_shaman_spec_3_60 = ''
    playerbots_shaman_spec_3_80 = playerbots_shaman_spec_3_60
    playerbots_mage_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_mage_spec_1_60 = ''
    playerbots_mage_spec_1_80 = playerbots_mage_spec_1_60
    playerbots_mage_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_mage_spec_2_60 = ''
    playerbots_mage_spec_2_80 = playerbots_mage_spec_2_60
    playerbots_mage_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_mage_spec_3_60 = ''
    playerbots_mage_spec_3_80 = playerbots_mage_spec_3_60
    playerbots_warlock_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_warlock_spec_1_60 = ''
    playerbots_warlock_spec_1_70 = playerbots_warlock_spec_1_60
    playerbots_warlock_spec_1_80 = playerbots_warlock_spec_1_60
    playerbots_warlock_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_warlock_spec_2_60 = ''
    playerbots_warlock_spec_2_70 = playerbots_warlock_spec_2_60
    playerbots_warlock_spec_2_80 = playerbots_warlock_spec_2_60
    playerbots_warlock_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_warlock_spec_3_60 = ''
    playerbots_warlock_spec_3_80 = playerbots_warlock_spec_3_60
    playerbots_druid_glyphs_1 = playerbots_warrior_glyphs_1
    playerbots_druid_spec_1_60 = ''
    playerbots_druid_spec_1_80 = playerbots_druid_spec_1_60
    playerbots_druid_glyphs_2 = playerbots_warrior_glyphs_1
    playerbots_druid_spec_2_60 = ''
    playerbots_druid_spec_2_80 = playerbots_druid_spec_2_60
    playerbots_druid_glyphs_3 = playerbots_warrior_glyphs_1
    playerbots_druid_spec_3_60 = ''
    playerbots_druid_spec_3_80 = playerbots_druid_spec_3_60
    playerbots_druid_glyphs_4 = playerbots_warrior_glyphs_1
    playerbots_druid_spec_4_60 = ''
    playerbots_druid_spec_4_80 = playerbots_druid_spec_4_60
else:
    playerbots_starting_level = 70
    playerbots_maps = '0,1,530,571'
    playerbots_warrior_glyphs_1 = '43418,43395,43423,43399,49084,43421'
    playerbots_warrior_spec_1_60 = '3022032023335100002012211231241'
    playerbots_warrior_spec_1_80 = '3022032023335100102012213231251-305-2033'
    playerbots_warrior_glyphs_2 = '43418,43395,43414,43399,49084,43432'
    playerbots_warrior_spec_2_60 = '-305053000500310053120501351'
    playerbots_warrior_spec_2_80 = '32002300233-305053000500310153120511351'
    playerbots_warrior_glyphs_3 = '43424,43395,43425,43399,49084,45793'
    playerbots_warrior_spec_3_60 = '--053351225000210521030113321'
    playerbots_warrior_spec_3_80 = '3500030023-301-053351225000210521030113321'
    playerbots_paladin_glyphs_1 = '41106,43367,45741,43369,43365,41109'
    playerbots_paladin_spec_1_60 = '50350151020013053100515221'
    playerbots_paladin_spec_1_80 = '50350152220013053100515221-503201312'
    playerbots_paladin_glyphs_2 = '41099,43367,43869,43369,43365,45745'
    playerbots_paladin_spec_2_60 = '-05005135203102311333112321'
    playerbots_paladin_spec_2_80 = '-05005135203102311333312321-502302012003'
    playerbots_paladin_glyphs_3 = '41092,43367,41099,43369,43365,43869'
    playerbots_paladin_spec_3_60 = '--05230051203331302133231131'
    playerbots_paladin_spec_3_65 = '-05-05230051203331302133231131'
    playerbots_paladin_spec_3_80 = '050501-05-05232051203331302133231331'
    playerbots_hunter_glyphs_1 = '42912,43350,42902,43351,43338,45732'
    playerbots_hunter_spec_1_60 = '51200201505112243100511351'
    playerbots_hunter_spec_1_80 = '51200201505112253100531351-015305021'
    playerbots_hunter_glyphs_2 = '42912,43350,42914,43351,43338,45732'
    playerbots_hunter_spec_2_60 = '-025315101030013233125031051'
    playerbots_hunter_spec_2_80 = '502-025335101030013233135031351-5000002'
    playerbots_hunter_glyphs_3 = '42912,43350,45731,43351,43338,45732'
    playerbots_hunter_spec_3_60 = '--5000032500033330502135201311'
    playerbots_hunter_spec_3_80 = '-005305101-5000032500033330532135301321'
    playerbots_rogue_glyphs_1 = '45768,43379,45761,43380,43378,45766'
    playerbots_rogue_spec_1_60 = '005323005350100520103331051'
    playerbots_rogue_spec_1_80 = '005323005350100520103331051-005005005003-2'
    playerbots_rogue_glyphs_2 = '42962,43379,45762,43380,43378,42969'
    playerbots_rogue_spec_2_60 = '-0252051000035015223100501251'
    playerbots_rogue_spec_2_80 = '00532000523-0252051000035015223100501251'
    playerbots_rogue_glyphs_3 = '42967,43379,45764,43380,43378,45767'
    playerbots_rogue_spec_3_60 = '--5120122030321121050135031241'
    playerbots_rogue_spec_3_80 = '0053231-2-5120222030321121050135231251'
    playerbots_priest_glyphs_1 = '42408,43371,42400,43374,43342,45756'
    playerbots_priest_spec_1_60 = '0503203130300512301323131051'
    playerbots_priest_spec_1_80 = '0503203130300512331323231251-03520103'
    playerbots_priest_glyphs_2 = '42408,43371,42400,43374,43342,42396'
    playerbots_priest_spec_2_60 = '-035050031301152530000331331'
    playerbots_priest_spec_2_80 = '05032031-235050032302152530000331351'
    playerbots_priest_glyphs_3 = '42406,43371,42407,43374,43342,42415'
    playerbots_priest_spec_3_60 = '--325003041203010323150301351'
    playerbots_priest_spec_3_80 = '0503203--325023051223010323152301351'
    playerbots_shaman_glyphs_1 = '41536,43385,41532,43386,44923,45776'
    playerbots_shaman_spec_1_60 = '4530001520213351102301351'
    playerbots_shaman_spec_1_80 = '3530001523213351322301351-005050031'
    playerbots_shaman_glyphs_2 = '41542,43385,41539,43386,44923,45771'
    playerbots_shaman_spec_2_60 = '-30205033005001333031131131051'
    playerbots_shaman_spec_2_80 = '053030052-30205033005021333031131131051'
    playerbots_shaman_glyphs_3 = '41517,43385,41527,43386,44923,45775'
    playerbots_shaman_spec_3_60 = '--50005301235310501102321251'
    playerbots_shaman_spec_3_80 = '-00502033-50005331335310501122331251'
    playerbots_mage_glyphs_1 = '42735,43339,44955,43364,43361,42751'
    playerbots_mage_spec_1_60 = '23000503110033014032310150532'
    playerbots_mage_spec_1_80 = '23000523310033015032310250532-03-203203001'
    playerbots_mage_glyphs_2 = '42739,43339,45737,43364,44920,42751'
    playerbots_mage_spec_2_60 = '-0055030011302231053120321341'
    playerbots_mage_spec_2_80 = '23000503110003-0055030011302331053120321351'
    playerbots_mage_glyphs_3 = '42742,43339,50045,43364,43361,42751'
    playerbots_mage_spec_3_60 = '--0533030313203100030152231151'
    playerbots_mage_spec_3_80 = '23002303110003--0533030313203100030152231351'
    playerbots_warlock_glyphs_1 = '45785,43390,50077,43394,43393,45779'
    playerbots_warlock_spec_1_60 = '2350022001113510053500131151'
    playerbots_warlock_spec_1_70 = '2350022001113510053500131151--55'
    playerbots_warlock_spec_1_80 = '2350022001113510253500331151--5500000501'
    playerbots_warlock_glyphs_2 = '45785,43390,50077,43394,43393,42459'
    playerbots_warlock_spec_2_60 = '-003203301135112530135201051'
    playerbots_warlock_spec_2_70 = '-003203301135112530135201051-55'
    playerbots_warlock_spec_2_80 = '-003203301135112530135221351-55000005'
    playerbots_warlock_glyphs_3 = '45785,43390,50077,43394,43393,42454'
    playerbots_warlock_spec_3_60 = '--05203205210131051313230341'
    playerbots_warlock_spec_3_80 = '-03310030003-05203205210331051335230351'
    playerbots_druid_glyphs_1 = '40916,43331,40921,43335,44922,40919'
    playerbots_druid_spec_1_60 = '5022203105331003213005301231'
    playerbots_druid_spec_1_80 = '5032203105331303213305301231--205003012'
    playerbots_druid_glyphs_2 = '40897,43331,46372,43335,43332,40899'
    playerbots_druid_spec_2_60 = '-500232130322110353100301310501'
    playerbots_druid_spec_2_80 = '-501232130322110353120303313511-20350001'
    playerbots_druid_glyphs_3 = '40913,43331,40906,43335,44922,45602'
    playerbots_druid_spec_3_60 = '--230033312031500531050113051'
    playerbots_druid_spec_3_80 = '05320031--230033312031501531053313051'
    playerbots_druid_glyphs_4 = '40902,43331,40901,43335,44922,45604'
    playerbots_druid_spec_4_60 = '-552202032322010053100030310501'
    playerbots_druid_spec_4_80 = '-553202032322010053100030310511-205503012'

configs = [
    [
        'authserver.conf', options['build.auth'], False, 0, [
            ['LoginDatabaseInfo =', f'LoginDatabaseInfo = "{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options['database.auth']}"'],
            ['Updates.EnableDatabases =', 'Updates.EnableDatabases = 0'],
            ['LogsDir =', f'LogsDir = "{cwd}/logs"']
        ]
    ],
    [
        'worldserver.conf', options['build.world'], True, 0, [
            ['RealmID =', f'RealmID = {realm_id}'],
            ['WorldServerPort =', f'WorldServerPort = {realm_port}'],
            ['LoginDatabaseInfo     =', f'LoginDatabaseInfo     ="{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options['database.auth']}"'],
            ['WorldDatabaseInfo     =', f'WorldDatabaseInfo     ="{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options['database.world']}"'],
            ['CharacterDatabaseInfo = ', f'CharacterDatabaseInfo = "{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options['database.characters']}"'],
            ['DataDir =', f'DataDir = "{GetDataPath()}"'],
            ['LogsDir =', f'LogsDir = "{cwd}/logs"'],
            ['BeepAtStart =', 'BeepAtStart = 0'],
            ['FlashAtStart =', 'FlashAtStart = 0'],
            ['Updates.EnableDatabases =', 'Updates.EnableDatabases = 0'],
            ['GameType =', f'GameType = {options['world.game_type']}'],
            ['RealmZone =', f'RealmZone = {options['world.realm_zone']}'],
            ['MinWorldUpdateTime =', 'MinWorldUpdateTime = 1'],
            ['MapUpdateInterval =', 'MapUpdateInterval = 100'],
            ['MapUpdate.Threads =', f'MapUpdate.Threads = {map_update_threads}'],
            ['PreloadAllNonInstancedMapGrids =', f'PreloadAllNonInstancedMapGrids = {'1' if options['world.preload_grids'] else '0'}'],
            ['SetAllCreaturesWithWaypointMovementActive =', f'SetAllCreaturesWithWaypointMovementActive = {'1' if options['world.set_creatures_active'] else '0'}'],
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
            ['Daze.Enabled =', 'Daze.Enabled = 0'],
            ['Warden.Enabled =', f'Warden.Enabled = {options['world.warden']}'],
            ['Progression.Patch =', f'Progression.Patch = {int(options['world.progression.patch'])}'],
            ['Progression.IcecrownCitadel.Aura =', f'Progression.IcecrownCitadel.Aura = {options['world.progression.aura']}'],
            ['Progression.Level.Enforced =', 'Progression.Level.Enforced = 1'],
            ['Progression.DungeonFinder.Enforced =', 'Progression.DungeonFinder.Enforced = 0'],
            ['Progression.DualTalent.Enforced =', 'Progression.DualTalent.Enforced = 0' ],
            ['Progression.QuestInfo.Enforced =', 'Progression.QuestInfo.Enforced = 0' ],
            ['Progression.Multiplier.Damage =', f'Progression.Multiplier.Damage = {options['world.progression.multiplier.damage']}'],
            ['Progression.Multiplier.Healing =', f'Progression.Multiplier.Healing = {options['world.progression.multiplier.healing']}'],
            ['Progression.PatchNotes.Enabled =', 'Progression.PatchNotes.Enabled = 1']
        ]
    ],
    [
        'modules/mod_ahbot.conf', options['module.ah_bot.enabled'], True, 0, [
            ['AuctionHouseBot.EnableSeller =', f'AuctionHouseBot.EnableSeller = {'1' if options['module.ah_bot.seller.enabled'] else '0'}'],
            ['AuctionHouseBot.EnableBuyer =', f'AuctionHouseBot.EnableBuyer = {'1' if options['module.ah_bot.buyer.enabled'] else '0'}'],
            ['AuctionHouseBot.Account =', f'AuctionHouseBot.Account = {options['module.ah_bot.account_id']}'],
            ['AuctionHouseBot.GUID =', f'AuctionHouseBot.GUID = {options['module.ah_bot.character_guid']}'],
            ['AuctionHouseBot.DisableItemsAboveLevel =', f'AuctionHouseBot.DisableItemsAboveLevel = {ahbot_max_item_level}'],
        ]
    ],
    [
        'modules/mod_appreciation.conf', options['module.appreciation.enabled'], True, 12, [
            ['Appreciation.RequireCertificate.Enabled =', 'Appreciation.RequireCertificate.Enabled = 0'],
            ['Appreciation.LevelBoost.TargetLevel =', f'Appreciation.LevelBoost.TargetLevel = {'60' if int(options['world.progression.patch']) < 17 else '70'}'],
            ['Appreciation.LevelBoost.IncludedCopper =', f'Appreciation.LevelBoost.IncludedCopper = {'5000000' if int(options['world.progression.patch']) < 17 else '10000000'}'],
            ['Appreciation.UnlockContinents.Enabled =', f'Appreciation.UnlockContinents.Enabled = {'0' if int(options['world.progression.patch']) < 12 else '1'}'],
            ['Appreciation.UnlockContinents.EasternKingdoms.Enabled =', f'Appreciation.UnlockContinents.EasternKingdoms.Enabled = {'0' if int(options['world.progression.patch']) < 12 else '1'}'],
            ['Appreciation.UnlockContinents.Kalimdor.Enabled =', f'Appreciation.UnlockContinents.Kalimdor.Enabled = {'0' if int(options['world.progression.patch']) < 12 else '1'}'],
            ['Appreciation.UnlockContinents.Outland.Enabled =', f'Appreciation.UnlockContinents.Outland.Enabled = {'0' if int(options['world.progression.patch']) < 17 else '1'}']
        ]
    ],
    [
        'modules/mod_assistant.conf', options['module.assistant.enabled'], True, 0, [
            ['Assistant.Heirlooms.Enabled  =', f'Assistant.Heirlooms.Enabled  = {'0' if int(options['world.progression.patch']) < 17 else '1'}'],
            ['Assistant.Glyphs.Enabled     =', f'Assistant.Glyphs.Enabled     = {'0' if int(options['world.progression.patch']) < 17 else '1'}'],
            ['Assistant.Gems.Enabled       =', f'Assistant.Gems.Enabled       = {'0' if int(options['world.progression.patch']) < 17 else '1'}'],
            ['Assistant.Elixirs.Enabled    =', f'Assistant.Elixirs.Enabled    = {'0' if int(options['world.progression.patch']) < 17 else '1'}'],
            ['Assistant.Food.Enabled       =', f'Assistant.Food.Enabled       = {'0' if int(options['world.progression.patch']) < 17 else '1'}'],
            ['Assistant.Enchants.Enabled   =', f'Assistant.Enchants.Enabled   = {'0' if int(options['world.progression.patch']) < 17 else '1'}'],
            ['Assistant.FlightPaths.Vanilla.Enabled                  =', 'Assistant.FlightPaths.Vanilla.Enabled                  = 0'],
            ['Assistant.FlightPaths.BurningCrusade.Enabled           =', 'Assistant.FlightPaths.BurningCrusade.Enabled           = 0'],
            ['Assistant.Professions.Master.Enabled      =', f'Assistant.Professions.Master.Enabled      = {'0' if int(options['world.progression.patch']) < 12 else '1'}'],
            ['Assistant.Professions.GrandMaster.Enabled =', f'Assistant.Professions.GrandMaster.Enabled = {'0' if int(options['world.progression.patch']) < 17 else '1'}'],
            ['Assistant.Instances.Heroic.Enabled  =', f'Assistant.Instances.Heroic.Enabled  = {'0' if int(options['world.progression.patch']) < 12 else '1'}']
        ]
    ],
    [
        'modules/mod_learnspells.conf', options['module.learnspells.enabled'], True, 0, [
            ['LearnSpells.Gamemasters =', 'LearnSpells.Gamemasters = 1'],
            ['LearnSpells.SpellsFromQuests =', 'LearnSpells.SpellsFromQuests = 0'],
            ['LearnSpells.Riding.Apprentice =', f'LearnSpells.Riding.Apprentice = {'0' if int(options['world.progression.patch']) < 17 else '1'}'],
            ['LearnSpells.Riding.Journeyman =', f'LearnSpells.Riding.Journeyman = {'0' if int(options['world.progression.patch']) < 17 else '1'}'],
            ['LearnSpells.Riding.Expert =', f'LearnSpells.Riding.Expert = {'0' if int(options['world.progression.patch']) < 17 else '1'}']
        ]
    ],
    [
        'modules/playerbots.conf', options['module.playerbots.enabled'], True, 0, [
            ['AiPlayerbot.RandomBotAccountCount =', f'AiPlayerbot.RandomBotAccountCount = {options['module.playerbots.random_bots.accounts']}'],
            ['AiPlayerbot.MinRandomBots =', f'AiPlayerbot.MinRandomBots = {options['module.playerbots.random_bots.minimum']}'],
            ['AiPlayerbot.MaxRandomBots =', f'AiPlayerbot.MaxRandomBots = {options['module.playerbots.random_bots.maximum']}'],
            ['AiPlayerbot.AllowPlayerBots =', 'AiPlayerbot.AllowPlayerBots = 1'],
            ['AiPlayerbot.SelfBotLevel =', 'AiPlayerbot.SelfBotLevel = 2'],
            ['AiPlayerbot.SayWhenCollectingItems =', 'AiPlayerbot.SayWhenCollectingItems = 0'],
            ['AiPlayerbot.TellWhenAvoidAoe =', 'AiPlayerbot.TellWhenAvoidAoe = 0'],
            ['AiPlayerbot.AutoGearQualityLimit =', 'AiPlayerbot.AutoGearQualityLimit = 5'],
            ['AiPlayerbot.DisableDeathKnightLogin =', f'AiPlayerbot.DisableDeathKnightLogin = {'1' if int(options['world.progression.patch']) < 17 else '0'}'],
            ['AiPlayerbot.DisableRandomLevels =', 'AiPlayerbot.DisableRandomLevels = 1'],
            ['AiPlayerbot.RandombotStartingLevel =', f'AiPlayerbot.RandombotStartingLevel = {playerbots_starting_level}'],
            ['AiPlayerbot.RandomGearQualityLimit =', 'AiPlayerbot.RandomGearQualityLimit = 5'],
            ['AiPlayerbot.RandomBotGroupNearby =', 'AiPlayerbot.RandomBotGroupNearby = 1'],
            ['AiPlayerbot.RandomBotMaps =', f'AiPlayerbot.RandomBotMaps = {playerbots_maps}'],
            ['PlayerbotsDatabaseInfo =', f'PlayerbotsDatabaseInfo = "{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options['database.playerbots']}"'],
            ['Playerbots.Updates.EnableDatabases =', 'Playerbots.Updates.EnableDatabases = 0'],
            ['AiPlayerbot.RandomBotTalk =', 'AiPlayerbot.RandomBotTalk = 0'],
            ['AiPlayerbot.RandomBotSuggestDungeons =', 'AiPlayerbot.RandomBotSuggestDungeons = 0'],
            ['AiPlayerbot.ToxicLinksRepliesChance =', 'AiPlayerbot.ToxicLinksRepliesChance = 0'],
            ['AiPlayerbot.ThunderfuryRepliesChance =', 'AiPlayerbot.ThunderfuryRepliesChance = 0'],
            ['AiPlayerbot.GuildRepliesRate =', 'AiPlayerbot.GuildRepliesRate = 0'],
            ['AIPlayerbot.GuildFeedback =', 'AIPlayerbot.GuildFeedback = 0'],
            ['AiPlayerbot.EnableBroadcasts =', 'AiPlayerbot.EnableBroadcasts = 0'],
            ['AiPlayerbot.AddClassCommand =', 'AiPlayerbot.AddClassCommand = 0'],
            ['AiPlayerbot.AddClassAccountPoolSize =', 'AiPlayerbot.AddClassAccountPoolSize = 0'],
            ['AiPlayerbot.BotActiveAlone =', f'AiPlayerbot.BotActiveAlone = {options['module.playerbots.random_bots.active_alone']}'],
            ['AiPlayerbot.botActiveAloneSmartScale =', f'AiPlayerbot.botActiveAloneSmartScale = {'1' if options['module.playerbots.random_bots.smart_scale'] else '0'}'],
            ['AiPlayerbot.AutoAvoidAoe =', 'AiPlayerbot.AutoAvoidAoe = 1'],
            ['AiPlayerbot.CommandServerPort =', 'AiPlayerbot.CommandServerPort = 0'],
            ['AiPlayerbot.RandomBotArenaTeam2v2Count =', f'AiPlayerbot.RandomBotArenaTeam2v2Count = {'0' if int(options['world.progression.patch']) < 12 else '15'}'],
            ['AiPlayerbot.RandomBotArenaTeam3v3Count =', f'AiPlayerbot.RandomBotArenaTeam3v3Count = {'0' if int(options['world.progression.patch']) < 12 else '15'}'],
            ['AiPlayerbot.RandomBotArenaTeam5v5Count =', f'AiPlayerbot.RandomBotArenaTeam5v5Count = {'0' if int(options['world.progression.patch']) < 12 else '25'}'],
            ['AiPlayerbot.KillXPRate =', 'AiPlayerbot.KillXPRate = 1'],
            ['AiPlayerbot.AutoEquipUpgradeLoot =', 'AiPlayerbot.AutoEquipUpgradeLoot = 0'],
            ['AiPlayerbot.FreeFood =', 'AiPlayerbot.FreeFood = 1'],
            ['AiPlayerbot.AutoPickReward =', 'AiPlayerbot.AutoPickReward = no'],
            ['AiPlayerbot.AutoTrainSpells =', 'AiPlayerbot.AutoTrainSpells = no'],
            ['AiPlayerbot.EnableNewRpgStrategy =', 'AiPlayerbot.EnableNewRpgStrategy = 1'],
            ['AiPlayerbot.DropObsoleteQuests =', 'AiPlayerbot.DropObsoleteQuests = 0'],
            ['AiPlayerbot.PvpProhibitedZoneIds =', 'AiPlayerbot.PvpProhibitedZoneIds = "2255,656,2361,2362,2363,976,35,2268,3425,392,541,1446,3828,3712,3738,3565,3539,3623,4152,3988,4658,4284,4418,4436,4275,4323,4395,3703,4298,139,4080"'],
            ['AiPlayerbot.PremadeSpecGlyph.1.0 =', f'AiPlayerbot.PremadeSpecGlyph.1.0 = {playerbots_warrior_glyphs_1} '],
            ['AiPlayerbot.PremadeSpecLink.1.0.60 =', f'AiPlayerbot.PremadeSpecLink.1.0.60 = {playerbots_warrior_spec_1_60} '],
            ['AiPlayerbot.PremadeSpecLink.1.0.80 =', f'AiPlayerbot.PremadeSpecLink.1.0.80 = {playerbots_warrior_spec_1_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.1.1 =', f'AiPlayerbot.PremadeSpecGlyph.1.1 = {playerbots_warrior_glyphs_2} '],
            ['AiPlayerbot.PremadeSpecLink.1.1.60 =', f'AiPlayerbot.PremadeSpecLink.1.1.60 = {playerbots_warrior_spec_2_60} '],
            ['AiPlayerbot.PremadeSpecLink.1.1.80 =', f'AiPlayerbot.PremadeSpecLink.1.1.80 = {playerbots_warrior_spec_2_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.1.2 =', f'AiPlayerbot.PremadeSpecGlyph.1.2 = {playerbots_warrior_glyphs_3} '],
            ['AiPlayerbot.PremadeSpecLink.1.2.60 =', f'AiPlayerbot.PremadeSpecLink.1.2.60 = {playerbots_warrior_spec_3_60} '],
            ['AiPlayerbot.PremadeSpecLink.1.2.80 =', f'AiPlayerbot.PremadeSpecLink.1.2.80 = {playerbots_warrior_spec_3_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.2.0 =', f'AiPlayerbot.PremadeSpecGlyph.2.0 = {playerbots_paladin_glyphs_1} '],
            ['AiPlayerbot.PremadeSpecLink.2.0.60 =', f'AiPlayerbot.PremadeSpecLink.2.0.60 = {playerbots_paladin_spec_1_60} '],
            ['AiPlayerbot.PremadeSpecLink.2.0.80 =', f'AiPlayerbot.PremadeSpecLink.2.0.80 = {playerbots_paladin_spec_1_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.2.1 =', f'AiPlayerbot.PremadeSpecGlyph.2.1 = {playerbots_paladin_glyphs_2} '],
            ['AiPlayerbot.PremadeSpecLink.2.1.60 =', f'AiPlayerbot.PremadeSpecLink.2.1.60 = {playerbots_paladin_spec_2_60} '],
            ['AiPlayerbot.PremadeSpecLink.2.1.80 =', f'AiPlayerbot.PremadeSpecLink.2.1.80 = {playerbots_paladin_spec_2_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.2.2 =', f'AiPlayerbot.PremadeSpecGlyph.2.2 = {playerbots_paladin_glyphs_3} '],
            ['AiPlayerbot.PremadeSpecLink.2.2.60 =', f'AiPlayerbot.PremadeSpecLink.2.2.60 = {playerbots_paladin_spec_3_60} '],
            ['AiPlayerbot.PremadeSpecLink.2.2.65 =', f'AiPlayerbot.PremadeSpecLink.2.2.65 = {playerbots_paladin_spec_3_65} '],
            ['AiPlayerbot.PremadeSpecLink.2.2.80 =', f'AiPlayerbot.PremadeSpecLink.2.2.80 = {playerbots_paladin_spec_3_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.3.0 =', f'AiPlayerbot.PremadeSpecGlyph.3.0 = {playerbots_hunter_glyphs_1} '],
            ['AiPlayerbot.PremadeSpecLink.3.0.60 =', f'AiPlayerbot.PremadeSpecLink.3.0.60 = {playerbots_hunter_spec_1_60} '],
            ['AiPlayerbot.PremadeSpecLink.3.0.80 =', f'AiPlayerbot.PremadeSpecLink.3.0.80 = {playerbots_hunter_spec_1_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.3.1 =', f'AiPlayerbot.PremadeSpecGlyph.3.1 = {playerbots_hunter_glyphs_2} '],
            ['AiPlayerbot.PremadeSpecLink.3.1.60 =', f'AiPlayerbot.PremadeSpecLink.3.1.60 = {playerbots_hunter_spec_2_60} '],
            ['AiPlayerbot.PremadeSpecLink.3.1.80 =', f'AiPlayerbot.PremadeSpecLink.3.1.80 = {playerbots_hunter_spec_2_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.3.2 =', f'AiPlayerbot.PremadeSpecGlyph.3.2 = {playerbots_hunter_glyphs_3} '],
            ['AiPlayerbot.PremadeSpecLink.3.2.60 =', f'AiPlayerbot.PremadeSpecLink.3.2.60 = {playerbots_hunter_spec_3_60} '],
            ['AiPlayerbot.PremadeSpecLink.3.2.80 =', f'AiPlayerbot.PremadeSpecLink.3.2.80 = {playerbots_hunter_spec_3_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.4.0 =', f'AiPlayerbot.PremadeSpecGlyph.4.0 = {playerbots_rogue_glyphs_1} '],
            ['AiPlayerbot.PremadeSpecLink.4.0.60 =', f'AiPlayerbot.PremadeSpecLink.4.0.60 = {playerbots_rogue_spec_1_60} '],
            ['AiPlayerbot.PremadeSpecLink.4.0.80 =', f'AiPlayerbot.PremadeSpecLink.4.0.80 = {playerbots_rogue_spec_1_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.4.1 =', f'AiPlayerbot.PremadeSpecGlyph.4.1 = {playerbots_rogue_glyphs_2} '],
            ['AiPlayerbot.PremadeSpecLink.4.1.60 =', f'AiPlayerbot.PremadeSpecLink.4.1.60 = {playerbots_rogue_spec_2_60} '],
            ['AiPlayerbot.PremadeSpecLink.4.1.80 =', f'AiPlayerbot.PremadeSpecLink.4.1.80 = {playerbots_rogue_spec_2_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.4.2 =', f'AiPlayerbot.PremadeSpecGlyph.4.2 = {playerbots_rogue_glyphs_3} '],
            ['AiPlayerbot.PremadeSpecLink.4.2.60 =', f'AiPlayerbot.PremadeSpecLink.4.2.60 = {playerbots_rogue_spec_3_60} '],
            ['AiPlayerbot.PremadeSpecLink.4.2.80 =', f'AiPlayerbot.PremadeSpecLink.4.2.80 = {playerbots_rogue_spec_3_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.5.0 =', f'AiPlayerbot.PremadeSpecGlyph.5.0 = {playerbots_priest_glyphs_1} '],
            ['AiPlayerbot.PremadeSpecLink.5.0.60 =', f'AiPlayerbot.PremadeSpecLink.5.0.60 = {playerbots_priest_spec_1_60} '],
            ['AiPlayerbot.PremadeSpecLink.5.0.80 =', f'AiPlayerbot.PremadeSpecLink.5.0.80 = {playerbots_priest_spec_1_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.5.1 =', f'AiPlayerbot.PremadeSpecGlyph.5.1 = {playerbots_priest_glyphs_2} '],
            ['AiPlayerbot.PremadeSpecLink.5.1.60 =', f'AiPlayerbot.PremadeSpecLink.5.1.60 = {playerbots_priest_spec_2_60} '],
            ['AiPlayerbot.PremadeSpecLink.5.1.80 =', f'AiPlayerbot.PremadeSpecLink.5.1.80 = {playerbots_priest_spec_2_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.5.2 =', f'AiPlayerbot.PremadeSpecGlyph.5.2 = {playerbots_priest_glyphs_3} '],
            ['AiPlayerbot.PremadeSpecLink.5.2.60 =', f'AiPlayerbot.PremadeSpecLink.5.2.60 = {playerbots_priest_spec_3_60} '],
            ['AiPlayerbot.PremadeSpecLink.5.2.80 =', f'AiPlayerbot.PremadeSpecLink.5.2.80 = {playerbots_priest_spec_3_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.7.0 =', f'AiPlayerbot.PremadeSpecGlyph.7.0 = {playerbots_shaman_glyphs_1} '],
            ['AiPlayerbot.PremadeSpecLink.7.0.60 =', f'AiPlayerbot.PremadeSpecLink.7.0.60 = {playerbots_shaman_spec_1_60} '],
            ['AiPlayerbot.PremadeSpecLink.7.0.80 =', f'AiPlayerbot.PremadeSpecLink.7.0.80 = {playerbots_shaman_spec_1_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.7.1 =', f'AiPlayerbot.PremadeSpecGlyph.7.1 = {playerbots_shaman_glyphs_2} '],
            ['AiPlayerbot.PremadeSpecLink.7.1.60 =', f'AiPlayerbot.PremadeSpecLink.7.1.60 = {playerbots_shaman_spec_2_60} '],
            ['AiPlayerbot.PremadeSpecLink.7.1.80 =', f'AiPlayerbot.PremadeSpecLink.7.1.80 = {playerbots_shaman_spec_2_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.7.2 =', f'AiPlayerbot.PremadeSpecGlyph.7.2 = {playerbots_shaman_glyphs_3} '],
            ['AiPlayerbot.PremadeSpecLink.7.2.60 =', f'AiPlayerbot.PremadeSpecLink.7.2.60 = {playerbots_shaman_spec_3_60} '],
            ['AiPlayerbot.PremadeSpecLink.7.2.80 =', f'AiPlayerbot.PremadeSpecLink.7.2.80 = {playerbots_shaman_spec_3_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.8.0 =', f'AiPlayerbot.PremadeSpecGlyph.8.0 = {playerbots_mage_glyphs_1} '],
            ['AiPlayerbot.PremadeSpecLink.8.0.60 =', f'AiPlayerbot.PremadeSpecLink.8.0.60 = {playerbots_mage_spec_1_60} '],
            ['AiPlayerbot.PremadeSpecLink.8.0.80 =', f'AiPlayerbot.PremadeSpecLink.8.0.80 = {playerbots_mage_spec_1_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.8.1 =', f'AiPlayerbot.PremadeSpecGlyph.8.1 = {playerbots_mage_glyphs_2} '],
            ['AiPlayerbot.PremadeSpecLink.8.1.60 =', f'AiPlayerbot.PremadeSpecLink.8.1.60 = {playerbots_mage_spec_2_60} '],
            ['AiPlayerbot.PremadeSpecLink.8.1.80 =', f'AiPlayerbot.PremadeSpecLink.8.1.80 = {playerbots_mage_spec_2_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.8.2 =', f'AiPlayerbot.PremadeSpecGlyph.8.2 = {playerbots_mage_glyphs_3} '],
            ['AiPlayerbot.PremadeSpecLink.8.2.60 =', f'AiPlayerbot.PremadeSpecLink.8.2.60 = {playerbots_mage_spec_3_60} '],
            ['AiPlayerbot.PremadeSpecLink.8.2.80 =', f'AiPlayerbot.PremadeSpecLink.8.2.80 = {playerbots_mage_spec_3_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.9.0 =', f'AiPlayerbot.PremadeSpecGlyph.9.0 = {playerbots_warlock_glyphs_1} '],
            ['AiPlayerbot.PremadeSpecLink.9.0.60 =', f'AiPlayerbot.PremadeSpecLink.9.0.60 = {playerbots_warlock_spec_1_60} '],
            ['AiPlayerbot.PremadeSpecLink.9.0.70 =', f'AiPlayerbot.PremadeSpecLink.9.0.70 = {playerbots_warlock_spec_1_70} '],
            ['AiPlayerbot.PremadeSpecLink.9.0.80 =', f'AiPlayerbot.PremadeSpecLink.9.0.80 = {playerbots_warlock_spec_1_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.9.1 =', f'AiPlayerbot.PremadeSpecGlyph.9.1 = {playerbots_warlock_glyphs_2} '],
            ['AiPlayerbot.PremadeSpecLink.9.1.60 =', f'AiPlayerbot.PremadeSpecLink.9.1.60 = {playerbots_warlock_spec_2_60} '],
            ['AiPlayerbot.PremadeSpecLink.9.1.70 =', f'AiPlayerbot.PremadeSpecLink.9.1.70 = {playerbots_warlock_spec_2_70} '],
            ['AiPlayerbot.PremadeSpecLink.9.1.80 =', f'AiPlayerbot.PremadeSpecLink.9.1.80 = {playerbots_warlock_spec_2_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.9.2 =', f'AiPlayerbot.PremadeSpecGlyph.9.2 = {playerbots_warlock_glyphs_3} '],
            ['AiPlayerbot.PremadeSpecLink.9.2.60 =', f'AiPlayerbot.PremadeSpecLink.9.2.60 = {playerbots_warlock_spec_3_60} '],
            ['AiPlayerbot.PremadeSpecLink.9.2.80 =', f'AiPlayerbot.PremadeSpecLink.9.2.80 = {playerbots_warlock_spec_3_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.11.0 =', f'AiPlayerbot.PremadeSpecGlyph.11.0 = {playerbots_druid_glyphs_1} '],
            ['AiPlayerbot.PremadeSpecLink.11.0.60 =', f'AiPlayerbot.PremadeSpecLink.11.0.60 = {playerbots_druid_spec_1_60} '],
            ['AiPlayerbot.PremadeSpecLink.11.0.80 =', f'AiPlayerbot.PremadeSpecLink.11.0.80 = {playerbots_druid_spec_1_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.11.1 =', f'AiPlayerbot.PremadeSpecGlyph.11.1 = {playerbots_druid_glyphs_2} '],
            ['AiPlayerbot.PremadeSpecLink.11.1.60 =', f'AiPlayerbot.PremadeSpecLink.11.1.60 = {playerbots_druid_spec_2_60} '],
            ['AiPlayerbot.PremadeSpecLink.11.1.80 =', f'AiPlayerbot.PremadeSpecLink.11.1.80 = {playerbots_druid_spec_2_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.11.2 =', f'AiPlayerbot.PremadeSpecGlyph.11.2 = {playerbots_druid_glyphs_3} '],
            ['AiPlayerbot.PremadeSpecLink.11.2.60 =', f'AiPlayerbot.PremadeSpecLink.11.2.60 = {playerbots_druid_spec_3_60} '],
            ['AiPlayerbot.PremadeSpecLink.11.2.80 =', f'AiPlayerbot.PremadeSpecLink.11.2.80 = {playerbots_druid_spec_3_80} '],
            ['AiPlayerbot.PremadeSpecGlyph.11.3 =', f'AiPlayerbot.PremadeSpecGlyph.11.3 = {playerbots_druid_glyphs_4} '],
            ['AiPlayerbot.PremadeSpecLink.11.3.60 =', f'AiPlayerbot.PremadeSpecLink.11.3.60 = {playerbots_druid_spec_4_60} '],
            ['AiPlayerbot.PremadeSpecLink.11.3.80 =', f'AiPlayerbot.PremadeSpecLink.11.3.80 = {playerbots_druid_spec_4_80} ']
        ]
    ],
    [
        'modules/mod_recruitafriend.conf', options['module.recruitafriend.enabled'], True, 17, [
            ['RecruitAFriend.Duration =', 'RecruitAFriend.Duration = 0'],
            ['RecruitAFriend.MaxAccountAge =', 'RecruitAFriend.MaxAccountAge = 0']
        ]
    ],
    [
        'modules/skip_dk_module.conf', options['module.skip_dk_starting_area.enabled'], True, 17, [
            ['Skip.Deathknight.Starter.Announce.enable =', 'Skip.Deathknight.Starter.Announce.enable = 0']
        ]
    ]
]

def UpdateConfig(config, replacements):
    PrintProgress(f'Updating {config.rsplit('/', 1)[1]}')

    try:
        with open(f'{config}.dist', encoding='utf-8') as file:
            lines = file.readlines()

        for count, line in enumerate(lines):
            for replacement in replacements:
                if line.startswith(replacement[0]):
                    lines[count] = f'{replacement[1]}\n'

        with open(f'{config}', 'w', encoding='utf-8') as file:
            file.writelines(lines)
    except:
        HandleError('An error occurred while updating the config files')

def UpdateConfigs():
    PrintHeader('Updating config files...')

    path = f'{build}/bin/RelWithDebInfo/configs' if os.name == 'nt' else f'{source}/etc'

    for config in configs:
        filename = config[0]
        enabled = config[1]
        world_only = config[2]
        patch = config[3]
        replacements = config[4]

        if not enabled:
            continue

        if options['build.auth'] and not options['build.world'] and world_only:
            continue

        if not options['build.auth'] and options['build.world'] and not world_only:
            continue

        if int(options['world.progression.patch']) < patch:
            continue

        UpdateConfig(f'{path}/{filename}', replacements)

    PrintHeader('Finished updating config files...')

##################################################

databases = [
    # auth
    [options['database.auth'], True, False, f'{source}/data/sql/base/db_auth', False, '', 0],
    [options['database.auth'], True, False, f'{source}/data/sql/updates/db_auth', True, 'RELEASED', 0],
    [options['database.auth'], True, False, f'{source}/data/sql/custom/db_auth', True, 'CUSTOM', 0],
    [options['database.auth'], options['module.recruitafriend.enabled'], True, f'{source}/modules/mod-recruitafriend/data/sql/auth', True, 'MODULE', 17],
    [options['database.auth'], True, False, f'{cwd}/sql/auth', False, 'CUSTOM', 0],
    # characters
    [options['database.characters'], True, True, f'{source}/data/sql/base/db_characters', False, '', 0],
    [options['database.characters'], True, True, f'{source}/data/sql/updates/db_characters', True, 'RELEASED', 0],
    [options['database.characters'], True, True, f'{source}/data/sql/custom/db_characters', True, 'CUSTOM', 0],
    [options['database.characters'], options['module.playerbots.enabled'], True, f'{source}/modules/mod-playerbots/data/sql/characters', True, 'MODULE', 0],
    [options['database.characters'], True, True, f'{cwd}/sql/characters', False, 'CUSTOM', 0],
    # playerbots
    [options['database.playerbots'], options['module.playerbots.enabled'], True, f'{source}/modules/mod-playerbots/data/sql/playerbots/base', False, '', 0],
    [options['database.playerbots'], options['module.playerbots.enabled'], True, f'{source}/modules/mod-playerbots/data/sql/playerbots/updates/db_playerbots', True, 'RELEASED', 0],
    [options['database.playerbots'], options['module.playerbots.enabled'], True, f'{source}/modules/mod-playerbots/data/sql/playerbots/custom', True, 'CUSTOM', 0],
    # world
    [options['database.world'], True, True, f'{source}/data/sql/base/db_world', False, '', 0],
    [options['database.world'], True, True, f'{source}/data/sql/updates/db_world', True, 'RELEASED', 0],
    [options['database.world'], True, True, f'{source}/data/sql/custom/db_world', True, 'CUSTOM', 0],
    [options['database.world'], options['module.ah_bot.enabled'], True, f'{source}/modules/mod-ah-bot/data/sql/db-world', True, 'MODULE', 0],
    [options['database.world'], options['module.appreciation.enabled'], True, f'{source}/modules/mod-appreciation/data/sql/world', True, 'MODULE', 12],
    [options['database.world'], options['module.assistant.enabled'], True, f'{source}/modules/mod-assistant/data/sql/world', True, 'MODULE', 0],
    [options['database.world'], options['module.fixes.enabled'], True, f'{source}/modules/mod-fixes/data/sql/world', True, 'MODULE', 17],
    [options['database.world'], options['module.playerbots.enabled'], True, f'{source}/modules/mod-playerbots/data/sql/world', True, 'MODULE', 0],
    [options['database.world'], options['module.skip_dk_starting_area.enabled'], True, f'{source}/modules/mod-skip-dk-starting-area/data/sql/db-world', True, 'MODULE', 17],
    [options['database.world'], True, True, f'{cwd}/sql/world', False, 'CUSTOM', 0]
]

def sha1sum(filename):
    with open(filename, 'rb', buffering=0) as f:
        return hashlib.file_digest(f, 'sha1').hexdigest()

def ImportDatabase(database, path):
    if os.path.isdir(path):
        connect = pymysql.connect(host=mysql_hostname, user=mysql_username, password=mysql_password, db=database)
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
        connect = pymysql.connect(host=mysql_hostname, user=mysql_username, password=mysql_password, db=database)
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

def UpdateRealmList():
    PrintProgress(f'Adding to the realmlist (id: {realm_id}, name: {options['world.name']}, address: {options['world.address']}, localAddress: {options['world.local_address']}, port: {realm_port})')

    try:
        connect = pymysql.connect(host=mysql_hostname, port=mysql_port, user=mysql_username, password=mysql_password, db=options['database.auth'])
        cursor = connect.cursor()
        cursor.execute(f'DELETE FROM realmlist WHERE id={realm_id};')
        cursor.execute(f"INSERT INTO realmlist (id, name, address, localAddress, port) VALUES ({realm_id}, '{options['world.name']}', '{options['world.address']}', '{options['world.local_address']}', {realm_port});")
        connect.commit()
        cursor.close()
        connect.close()
    except:
        HandleError('An error occurred while updating the realmlist')

def UpdateMotd():
    PrintProgress('Updating message of the day')

    try:
        connect = pymysql.connect(host=mysql_hostname, port=mysql_port, user=mysql_username, password=mysql_password, db=options['database.auth'])
        cursor = connect.cursor()
        cursor.execute(f'DELETE FROM motd WHERE realmid={realm_id};')
        cursor.execute(f"INSERT INTO motd (realmid, text) VALUES ({realm_id}, 'Welcome to {options['world.name']}');")
        connect.commit()
        cursor.close()
        connect.close()
    except:
        HandleError('An error occurred while updating message of the day')

def ImportDatabases():
    PrintHeader('Importing database files...')

    file = open(mysqlcnf, 'w')
    file.write(f'[client]\nhost="{mysql_hostname}"\nport="{mysql_port}"\nuser="{mysql_username}"\npassword="{mysql_password}"')
    file.close()

    for database in databases:
        db = database[0]
        enabled = database[1]
        world_only = database[2]
        path = database[3]
        is_update = database[4]
        note = database[5]
        patch = database[6]

        if not enabled:
            continue

        if options['build.auth'] and not options['build.world'] and world_only:
            continue

        if int(options['world.progression.patch']) < patch:
            continue

        try:
            if not is_update:
                ImportDatabase(db, path)
            else:
                UpdateDatabase(db, path, note)
        except:
            HandleError('An error occurred while importing the database files')

    if options['build.world']:
        UpdateRealmList()
        UpdateMotd()

    if os.path.exists(mysqlcnf):
        os.remove(mysqlcnf)

    PrintHeader('Finished importing the database files...')

##################################################

def IsScreenActive(name):
    try:
        subprocess.check_output([f'screen -list | grep -E "{name}"'], shell=True)
        return True
    except subprocess.CalledProcessError:
        return False

def StartProcess(name):
    subprocess.run(f'cd {source}/bin && ./{name}', shell=True)

def SendShutdown():
    subprocess.run(f'screen -S world-{realm_id} -p 0 -X stuff "server shutdown 10^m"', shell=True)

def WaitForShutdown():
    for c in range(1,30):
        if not IsScreenActive(f'world-{realm_id}'):
            return
        time.sleep(1)

def StartServer():
    PrintHeader('Starting the server...')

    if (options['build.auth'] and not IsScreenActive('auth')) or (options['build.world'] and not IsScreenActive(f'world-{realm_id}')):
        StartProcess('start.sh')

        if options['build.auth'] and IsScreenActive('auth'):
            PrintProgress('To access the screen of the authserver, use the command screen -r auth')

        if options['build.world'] and IsScreenActive(f'world-{realm_id}'):
            PrintProgress(f'To access the screen of the worldserver, use the command screen -r world-{realm_id}')
    else:
        PrintError('The server is already running')

    PrintHeader('Finished starting the server...')

def StopServer():
    PrintHeader('Stopping the server...')

    if (options['build.auth'] and IsScreenActive('auth')) or (options['build.world'] and IsScreenActive(f'world-{realm_id}')):
        if options['build.world'] and IsScreenActive(f'world-{realm_id}'):
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

##################################################

os.system('cls' if os.name == 'nt' else 'clear')

if not options['build.auth'] and not options['build.world']:
    PrintError('Auth and world are both disabled in the options')
    sys.exit(1)

if not CheckArgument():
    ListArguments()
    sys.exit(1)

if SelectArgument() == 'install':
    if os.name != 'nt':
        StopServer()
    Install()
    UpdateClientData()
elif SelectArgument() == 'database':
    ImportDatabases()
elif SelectArgument() == 'config':
    UpdateConfigs()
elif SelectArgument() == 'dbc':
    CopyDBCFiles()
elif SelectArgument() == 'lua':
    CopyLuaScripts()
elif SelectArgument() == 'reset':
    if os.name != 'nt':
        StopServer()
    #ResetDatabase()
elif SelectArgument() == 'all':
    if os.name != 'nt':
        StopServer()
    Install()
    UpdateConfigs()
    ImportDatabases()
    UpdateClientData()
    CopyDBCFiles()
    CopyLuaScripts()
    if os.name != 'nt':
        StartServer()
elif SelectArgument() == 'start':
    if os.name == 'nt':
        PrintError('This argument is only available on Linux')
        sys.exit(1)
    StartServer()
elif SelectArgument() == 'stop':
    if os.name == 'nt':
        PrintError('This argument is only available on Linux')
        sys.exit(1)
    StopServer()
elif SelectArgument() == 'restart':
    if os.name == 'nt':
        PrintError('This argument is only available on Linux')
        sys.exit(1)
    StopServer()
    StartServer()
