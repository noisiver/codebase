# ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
# ALTER USER 'acore'@'127.0.0.1' IDENTIFIED WITH caching_sha2_password BY 'acore';

# Install MySQL Server 8.4 on Linux:
# wget https://repo.mysql.com/mysql-apt-config_0.8.34-1_all.deb
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
    'module.ah_bot.buyer.enabled': False,
    'module.ah_bot.character_guids': 0,
    'module.ah_bot.seller.enabled': False,
    'module.appreciation.enabled': False,
    'module.assistant.enabled': False,
    'module.eluna.enabled': False,
    'module.fixes.enabled': False,
    'module.gamemaster.enabled': False,
    'module.junktogold.enabled': False,
    'module.learnspells.enabled': False,
    'module.playerbots.enabled': False,
    'module.playerbots.random_bots.active_alone': 100,
    'module.playerbots.random_bots.maximum': 50,
    'module.playerbots.random_bots.minimum': 50,
    'module.playerbots.random_bots.smart_scale': False,
    'module.playerbots_level_brackets.dynamic_distribution': False,
    'module.playerbots_level_brackets.enabled': False,
    'module.progression.aura': 4,
    'module.progression.enabled': False,
    'module.progression.multiplier.damage': 0.6,
    'module.progression.multiplier.healing': 0.5,
    'module.progression.patch': 21,
    'module.progression.reset': False,
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
    'world.realm_zone': 1,
    'world.set_creatures_active': False,
    'world.warden': True
}

PrintHeader('Loading options from the database...')

try:
    connect = pymysql.connect(host=mysql_hostname, port=mysql_port, user=mysql_username, password=mysql_password, db=mysql_database)
    cursor = connect.cursor()
    cursor.execute(f'WITH s AS (SELECT `id`, `setting`, `VALUE`, ROW_NUMBER() OVER (PARTITION BY `setting` ORDER BY `id` DESC) nr FROM `realm_settings` WHERE (`id` = {realm_id} OR `id` = -1)) SELECT `setting`, `value` FROM s WHERE nr = 1;')

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
    ['mod-junk-to-gold', 'noisiver/mod-junk-to-gold', 'master', options['module.junktogold.enabled'], 0],
    ['mod-learnspells', 'noisiver/mod-learnspells', 'progression', options['module.learnspells.enabled'], 0],
    ['mod-playerbots', 'noisiver/mod-playerbots', 'noisiver', options['module.playerbots.enabled'], 0],
    ['mod-player-bot-level-brackets', 'DustinHendrickson/mod-player-bot-level-brackets', 'main', options['module.playerbots_level_brackets.enabled'], 0],
    ['mod-progression', 'noisiver/mod-progression', 'master', options['module.progression.enabled'], 0],
    ['mod-skip-dk-starting-area', 'noisiver/mod-skip-dk-starting-area', 'noisiver', options['module.skip_dk_starting_area.enabled'], 17],
    ['mod-stop-killing-them', 'noisiver/mod-stop-killing-them', 'master', True, 12],
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
        try:
            PrintProgress(f'Updating the source code for {name}')
            ResetSource(path, branch)
            PullSource(path)
        except Exception as e:
            print(e.stderr)
            HandleError(f'An error occurred while updating the source code for {name}')

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

        if options['build.world'] and enabled and int(options['module.progression.patch']) >= patch:
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

if int(options['module.progression.patch']) < 12:
    playerbots_max_level = 60
    playerbots_starting_level = 1
    playerbots_maps = '0,1'
elif int(options['module.progression.patch']) < 17:
    playerbots_max_level = 70
    playerbots_starting_level = 60
    playerbots_maps = '0,1,530'
else:
    playerbots_max_level = 80
    playerbots_starting_level = 70
    playerbots_maps = '0,1,530,571'

if int(options['module.progression.patch']) < 16:
    playerbots_apprentice_riding = 40
elif int(options['module.progression.patch']) < 19:
    playerbots_apprentice_riding = 30
else:
    playerbots_apprentice_riding = 20

if int(options['module.progression.patch']) < 19:
    playerbots_journeyman_riding = 60
    playerbots_expert_riding = 70
else:
    playerbots_journeyman_riding = 40
    playerbots_expert_riding = 60

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
            ['LoginDatabaseInfo     =', f'LoginDatabaseInfo     = "{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options['database.auth']}"'],
            ['WorldDatabaseInfo     =', f'WorldDatabaseInfo     = "{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options['database.world']}"'],
            ['CharacterDatabaseInfo = ', f'CharacterDatabaseInfo = "{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options['database.characters']}"'],
            ['LoginDatabase.SynchThreads     =', 'LoginDatabase.SynchThreads     = 2'],
            ['WorldDatabase.SynchThreads     =', 'WorldDatabase.SynchThreads     = 2'],
            ['CharacterDatabase.SynchThreads =', 'CharacterDatabase.SynchThreads = 2'],
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
            ['Warden.Enabled =', f'Warden.Enabled = {options['world.warden']}']
        ]
    ],
    [
        'modules/mod_ahbot.conf', options['module.ah_bot.enabled'], True, 0, [
            ['AuctionHouseBot.EnableSeller =', f'AuctionHouseBot.EnableSeller = {'1' if options['module.ah_bot.seller.enabled'] else '0'}'],
            ['AuctionHouseBot.EnableBuyer =', f'AuctionHouseBot.EnableBuyer = {'1' if options['module.ah_bot.buyer.enabled'] else '0'}'],
            ['AuctionHouseBot.GUIDs =', f'AuctionHouseBot.GUIDs = {options['module.ah_bot.character_guids']}'],
            ['AuctionHouseBot.ItemsPerCycle =', 'AuctionHouseBot.ItemsPerCycle = 250' ],
            ['AuctionHouseBot.Alliance.MinItems =', 'AuctionHouseBot.Alliance.MinItems = 100000'],
            ['AuctionHouseBot.Alliance.MaxItems =', 'AuctionHouseBot.Alliance.MaxItems = 100000'],
            ['AuctionHouseBot.Horde.MinItems =', 'AuctionHouseBot.Horde.MinItems = 100000'],
            ['AuctionHouseBot.Horde.MaxItems =', 'AuctionHouseBot.Horde.MaxItems = 100000'],
            ['AuctionHouseBot.Neutral.MinItems =', 'AuctionHouseBot.Neutral.MinItems = 100000'],
            ['AuctionHouseBot.Neutral.MaxItems =', 'AuctionHouseBot.Neutral.MaxItems = 100000']
        ]
    ],
    [
        'modules/mod_appreciation.conf', options['module.appreciation.enabled'], True, 12, [
            ['Appreciation.RequireCertificate.Enabled =', 'Appreciation.RequireCertificate.Enabled = 0'],
            ['Appreciation.LevelBoost.TargetLevel =', f'Appreciation.LevelBoost.TargetLevel = {'60' if int(options['module.progression.patch']) < 17 else '70'}'],
            ['Appreciation.LevelBoost.IncludedCopper =', f'Appreciation.LevelBoost.IncludedCopper = {'5000000' if int(options['module.progression.patch']) < 17 else '10000000'}'],
            ['Appreciation.UnlockContinents.Enabled =', f'Appreciation.UnlockContinents.Enabled = {'0' if int(options['module.progression.patch']) < 12 else '1'}'],
            ['Appreciation.UnlockContinents.EasternKingdoms.Enabled =', f'Appreciation.UnlockContinents.EasternKingdoms.Enabled = {'0' if int(options['module.progression.patch']) < 12 else '1'}'],
            ['Appreciation.UnlockContinents.Kalimdor.Enabled =', f'Appreciation.UnlockContinents.Kalimdor.Enabled = {'0' if int(options['module.progression.patch']) < 12 else '1'}'],
            ['Appreciation.UnlockContinents.Outland.Enabled =', f'Appreciation.UnlockContinents.Outland.Enabled = {'0' if int(options['module.progression.patch']) < 17 else '1'}']
        ]
    ],
    [
        'modules/mod_assistant.conf', options['module.assistant.enabled'], True, 0, [
            ['Assistant.Heirlooms.Enabled  =', f'Assistant.Heirlooms.Enabled  = {'0' if int(options['module.progression.patch']) < 17 else '1'}'],
            ['Assistant.Glyphs.Enabled     =', f'Assistant.Glyphs.Enabled     = {'0' if int(options['module.progression.patch']) < 17 else '1'}'],
            ['Assistant.Gems.Enabled       =', f'Assistant.Gems.Enabled       = {'0' if int(options['module.progression.patch']) < 17 else '1'}'],
            ['Assistant.Elixirs.Enabled    =', f'Assistant.Elixirs.Enabled    = {'0' if int(options['module.progression.patch']) < 17 else '1'}'],
            ['Assistant.Food.Enabled       =', f'Assistant.Food.Enabled       = {'0' if int(options['module.progression.patch']) < 17 else '1'}'],
            ['Assistant.Enchants.Enabled   =', f'Assistant.Enchants.Enabled   = {'0' if int(options['module.progression.patch']) < 17 else '1'}'],
            ['Assistant.FlightPaths.Vanilla.Enabled                  =', 'Assistant.FlightPaths.Vanilla.Enabled                  = 0'],
            ['Assistant.FlightPaths.BurningCrusade.Enabled           =', 'Assistant.FlightPaths.BurningCrusade.Enabled           = 0'],
            ['Assistant.Professions.Apprentice.Cost     =', f'Assistant.Professions.Apprentice.Cost     = {'100000' if int(options['module.progression.patch']) < 17 else '1000000'}'],
            ['Assistant.Professions.Journeyman.Cost     =', f'Assistant.Professions.Journeyman.Cost     = {'250000' if int(options['module.progression.patch']) < 17 else '2500000'}'],
            ['Assistant.Professions.Expert.Cost         =', f'Assistant.Professions.Expert.Cost         = {'500000' if int(options['module.progression.patch']) < 17 else '5000000'}'],
            ['Assistant.Professions.Artisan.Cost        =', f'Assistant.Professions.Artisan.Cost        = {'750000' if int(options['module.progression.patch']) < 17 else '7500000'}'],
            ['Assistant.Professions.Master.Enabled      =', f'Assistant.Professions.Master.Enabled      = {'0' if int(options['module.progression.patch']) < 12 else '1'}'],
            ['Assistant.Professions.Master.Cost         =', f'Assistant.Professions.Master.Cost         = {'1250000' if int(options['module.progression.patch']) < 17 else '12500000'}'],
            ['Assistant.Professions.GrandMaster.Enabled =', f'Assistant.Professions.GrandMaster.Enabled = {'0' if int(options['module.progression.patch']) < 17 else '1'}'],
            ['Assistant.Instances.Heroic.Enabled  =', f'Assistant.Instances.Heroic.Enabled  = {'0' if int(options['module.progression.patch']) < 12 else '1'}']
        ]
    ],
    [
        'modules/mod_learnspells.conf', options['module.learnspells.enabled'], True, 0, [
            ['LearnSpells.Gamemasters =', 'LearnSpells.Gamemasters = 1'],
            ['LearnSpells.SpellsFromQuests =', 'LearnSpells.SpellsFromQuests = 1'],
            ['LearnSpells.Riding.Apprentice =', f'LearnSpells.Riding.Apprentice = {'0' if int(options['module.progression.patch']) < 17 else '1'}'],
            ['LearnSpells.Riding.Journeyman =', f'LearnSpells.Riding.Journeyman = {'0' if int(options['module.progression.patch']) < 17 else '1'}'],
            ['LearnSpells.Riding.Expert =', f'LearnSpells.Riding.Expert = {'0' if int(options['module.progression.patch']) < 17 else '1'}']
        ]
    ],
    [
        'modules/playerbots.conf', options['module.playerbots.enabled'], True, 0, [
            ['AiPlayerbot.MinRandomBots =', f'AiPlayerbot.MinRandomBots = {options['module.playerbots.random_bots.minimum']}'],
            ['AiPlayerbot.MaxRandomBots =', f'AiPlayerbot.MaxRandomBots = {options['module.playerbots.random_bots.maximum']}'],
            ['AiPlayerbot.AllowPlayerBots =', 'AiPlayerbot.AllowPlayerBots = 1'],
            ['AiPlayerbot.SelfBotLevel =', 'AiPlayerbot.SelfBotLevel = 2'],
            ['AiPlayerbot.SayWhenCollectingItems =', 'AiPlayerbot.SayWhenCollectingItems = 0'],
            ['AiPlayerbot.TellWhenAvoidAoe =', 'AiPlayerbot.TellWhenAvoidAoe = 0'],
            ['AiPlayerbot.AutoGearQualityLimit =', 'AiPlayerbot.AutoGearQualityLimit = 5'],
            ['AiPlayerbot.DisableDeathKnightLogin =', f'AiPlayerbot.DisableDeathKnightLogin = {'1' if int(options['module.progression.patch']) < 17 else '0'}'],
            ['AiPlayerbot.DisableRandomLevels =', f'AiPlayerbot.DisableRandomLevels = {'0' if options['module.playerbots_level_brackets.enabled'] else '1'}'],
            ['AiPlayerbot.RandomBotMaxLevel =', f'AiPlayerbot.RandomBotMaxLevel = {playerbots_max_level}'],
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
            ['AiPlayerbot.CommandServerPort =', 'AiPlayerbot.CommandServerPort = 0'],
            ['AiPlayerbot.RandomBotArenaTeam2v2Count =', f'AiPlayerbot.RandomBotArenaTeam2v2Count = {'0' if int(options['module.progression.patch']) < 12 else '15'}'],
            ['AiPlayerbot.RandomBotArenaTeam3v3Count =', f'AiPlayerbot.RandomBotArenaTeam3v3Count = {'0' if int(options['module.progression.patch']) < 12 else '15'}'],
            ['AiPlayerbot.RandomBotArenaTeam5v5Count =', f'AiPlayerbot.RandomBotArenaTeam5v5Count = {'0' if int(options['module.progression.patch']) < 12 else '25'}'],
            ['AiPlayerbot.AutoEquipUpgradeLoot =', 'AiPlayerbot.AutoEquipUpgradeLoot = 0'],
            ['AiPlayerbot.AutoPickReward =', 'AiPlayerbot.AutoPickReward = no'],
            ['AiPlayerbot.AutoTrainSpells =', 'AiPlayerbot.AutoTrainSpells = no'],
            ['AiPlayerbot.EnableNewRpgStrategy =', 'AiPlayerbot.EnableNewRpgStrategy = 1'],
            ['AiPlayerbot.DropObsoleteQuests =', 'AiPlayerbot.DropObsoleteQuests = 0'],
            ['PlayerbotsDatabase.WorkerThreads =', 'PlayerbotsDatabase.WorkerThreads = 4'],
            ['AiPlayerbot.UseGroundMountAtMinLevel =', f'AiPlayerbot.UseGroundMountAtMinLevel = {playerbots_apprentice_riding}'],
            ['AiPlayerbot.UseFastGroundMountAtMinLevel =', f'AiPlayerbot.UseFastGroundMountAtMinLevel = {playerbots_journeyman_riding}'],
            ['AiPlayerbot.UseFlyMountAtMinLevel =', f'AiPlayerbot.UseFlyMountAtMinLevel = {playerbots_expert_riding}'],
            ['AiPlayerbot.NonCombatStrategies =', 'AiPlayerbot.NonCombatStrategies = "+worldbuff,-food"']
        ]
    ],
    [
        'modules/mod_player_bot_level_brackets.conf', options['module.playerbots_level_brackets.enabled'], True, 0, [
            ['BotLevelBrackets.Dynamic.UseDynamicDistribution =', f'BotLevelBrackets.Dynamic.UseDynamicDistribution = {'1' if options['module.playerbots_level_brackets.dynamic_distribution'] else '0'}']
        ]
    ],
    [
        'modules/mod_progression.conf', options['module.progression.enabled'], True, 0, [
            ['Progression.Patch =', f'Progression.Patch = {options['module.progression.patch']}'],
            ['Progression.IcecrownCitadel.Aura =', f'Progression.IcecrownCitadel.Aura = {options['module.progression.aura']}'],
            ['Progression.TradableBindsOnPickup.Enforced =', 'Progression.TradableBindsOnPickup.Enforced = 0'],
            ['Progression.QuestInfo.Enforced =', 'Progression.QuestInfo.Enforced = 0'],
            ['Progression.Achievements.Enforced =', 'Progression.Achievements.Enforced = 0'],
            ['Progression.Multiplier.Damage =', f'Progression.Multiplier.Damage = {options['module.progression.multiplier.damage']}'],
            ['Progression.Multiplier.Healing =', f'Progression.Multiplier.Healing = {options['module.progression.multiplier.healing']}'],
            ['Progression.WarEffort.CopperBar.Required          =', 'Progression.WarEffort.CopperBar.Required          = 90'],
            ['Progression.WarEffort.IronBar.Required            =', 'Progression.WarEffort.IronBar.Required            = 28'],
            ['Progression.WarEffort.ThoriumBar.Required         =', 'Progression.WarEffort.ThoriumBar.Required         = 24'],
            ['Progression.WarEffort.TinBar.Required             =', 'Progression.WarEffort.TinBar.Required             = 22'],
            ['Progression.WarEffort.MithrilBar.Required         =', 'Progression.WarEffort.MithrilBar.Required         = 18'],
            ['Progression.WarEffort.Stranglekelp.Required       =', 'Progression.WarEffort.Stranglekelp.Required       = 33'],
            ['Progression.WarEffort.PurpleLotus.Required        =', 'Progression.WarEffort.PurpleLotus.Required        = 26'],
            ['Progression.WarEffort.ArthasTears.Required        =', 'Progression.WarEffort.ArthasTears.Required        = 20'],
            ['Progression.WarEffort.Peacebloom.Required         =', 'Progression.WarEffort.Peacebloom.Required         = 96'],
            ['Progression.WarEffort.Firebloom.Required          =', 'Progression.WarEffort.Firebloom.Required          = 19'],
            ['Progression.WarEffort.LightLeather.Required       =', 'Progression.WarEffort.LightLeather.Required       = 180'],
            ['Progression.WarEffort.MediumLeather.Required      =', 'Progression.WarEffort.MediumLeather.Required      = 110'],
            ['Progression.WarEffort.ThickLeather.Required       =', 'Progression.WarEffort.ThickLeather.Required       = 80'],
            ['Progression.WarEffort.HeavyLeather.Required       =', 'Progression.WarEffort.HeavyLeather.Required       = 60'],
            ['Progression.WarEffort.RuggedLeather.Required      =', 'Progression.WarEffort.RuggedLeather.Required      = 60'],
            ['Progression.WarEffort.LinenBandage.Required       =', 'Progression.WarEffort.LinenBandage.Required       = 800'],
            ['Progression.WarEffort.SilkBandage.Required        =', 'Progression.WarEffort.SilkBandage.Required        = 600'],
            ['Progression.WarEffort.RuneclothBandage.Required   =', 'Progression.WarEffort.RuneclothBandage.Required   = 400'],
            ['Progression.WarEffort.WoolBandage.Required        =', 'Progression.WarEffort.WoolBandage.Required        = 250'],
            ['Progression.WarEffort.MageweaveBandage.Required   =', 'Progression.WarEffort.MageweaveBandage.Required   = 250'],
            ['Progression.WarEffort.RainbowFinAlbacore.Required =', 'Progression.WarEffort.RainbowFinAlbacore.Required = 14'],
            ['Progression.WarEffort.RoastRaptor.Required        =', 'Progression.WarEffort.RoastRaptor.Required        = 20'],
            ['Progression.WarEffort.SpottedYellowtail.Required  =', 'Progression.WarEffort.SpottedYellowtail.Required  = 17'],
            ['Progression.WarEffort.LeanWolfSteak.Required      =', 'Progression.WarEffort.LeanWolfSteak.Required      = 10'],
            ['Progression.WarEffort.BakedSalmon.Required        =', 'Progression.WarEffort.BakedSalmon.Required        = 10']
        ]
    ],
    [
        'modules/skip_dk_module.conf', options['module.skip_dk_starting_area.enabled'], True, 17, [
            ['Skip.Deathknight.Starter.Announce.enable =', 'Skip.Deathknight.Starter.Announce.enable = 0']
        ]
    ],
    [
        'modules/mod_weekendbonus.conf', options['module.weekendbonus.enabled'], True, 0, [
            ['WeekendBonus.Multiplier.Experience =', 'WeekendBonus.Multiplier.Experience = 2.0'],
            ['WeekendBonus.Multiplier.Money =', 'WeekendBonus.Multiplier.Money = 2.0'],
            ['WeekendBonus.Multiplier.Professions =', 'WeekendBonus.Multiplier.Professions = 2'],
            ['WeekendBonus.Multiplier.Reputation =', 'WeekendBonus.Multiplier.Reputation = 2.0'],
            ['WeekendBonus.Multiplier.Proficiencies =', 'WeekendBonus.Multiplier.Proficiencies = 2'],
            ['WeekendBonus.Multiplier.Honor =', 'WeekendBonus.Multiplier.Honor = 2.0']
        ]
    ]
]

if int(options['module.progression.patch']) < 17:
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.1.0 =', 'AiPlayerbot.PremadeSpecGlyph.1.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.1.1 =', 'AiPlayerbot.PremadeSpecGlyph.1.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.1.2 =', 'AiPlayerbot.PremadeSpecGlyph.1.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.2.0 =', 'AiPlayerbot.PremadeSpecGlyph.2.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.2.1 =', 'AiPlayerbot.PremadeSpecGlyph.2.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.2.2 =', 'AiPlayerbot.PremadeSpecGlyph.2.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.3.0 =', 'AiPlayerbot.PremadeSpecGlyph.3.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.3.1 =', 'AiPlayerbot.PremadeSpecGlyph.3.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.3.2 =', 'AiPlayerbot.PremadeSpecGlyph.3.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.4.0 =', 'AiPlayerbot.PremadeSpecGlyph.4.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.4.1 =', 'AiPlayerbot.PremadeSpecGlyph.4.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.4.2 =', 'AiPlayerbot.PremadeSpecGlyph.4.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.5.0 =', 'AiPlayerbot.PremadeSpecGlyph.5.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.5.1 =', 'AiPlayerbot.PremadeSpecGlyph.5.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.5.2 =', 'AiPlayerbot.PremadeSpecGlyph.5.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.7.0 =', 'AiPlayerbot.PremadeSpecGlyph.7.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.7.1 =', 'AiPlayerbot.PremadeSpecGlyph.7.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.7.2 =', 'AiPlayerbot.PremadeSpecGlyph.7.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.8.0 =', 'AiPlayerbot.PremadeSpecGlyph.8.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.8.1 =', 'AiPlayerbot.PremadeSpecGlyph.8.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.8.2 =', 'AiPlayerbot.PremadeSpecGlyph.8.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.8.3 =', 'AiPlayerbot.PremadeSpecGlyph.8.3 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.9.0 =', 'AiPlayerbot.PremadeSpecGlyph.9.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.9.1 =', 'AiPlayerbot.PremadeSpecGlyph.9.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.9.2 =', 'AiPlayerbot.PremadeSpecGlyph.9.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.11.0 =', 'AiPlayerbot.PremadeSpecGlyph.11.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.11.1 =', 'AiPlayerbot.PremadeSpecGlyph.11.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.11.2 =', 'AiPlayerbot.PremadeSpecGlyph.11.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.11.3 =', 'AiPlayerbot.PremadeSpecGlyph.11.3 = 0,0,0,0,0,0'])

if int(options['module.progression.patch']) < 17:
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.1.0 =', f'AiPlayerbot.PremadeSpecGlyph.1.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.1.1 =', f'AiPlayerbot.PremadeSpecGlyph.1.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.1.2 =', f'AiPlayerbot.PremadeSpecGlyph.1.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.2.0 =', f'AiPlayerbot.PremadeSpecGlyph.2.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.2.1 =', f'AiPlayerbot.PremadeSpecGlyph.2.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.2.2 =', f'AiPlayerbot.PremadeSpecGlyph.2.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.3.0 =', f'AiPlayerbot.PremadeSpecGlyph.3.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.3.1 =', f'AiPlayerbot.PremadeSpecGlyph.3.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.3.2 =', f'AiPlayerbot.PremadeSpecGlyph.3.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.4.0 =', f'AiPlayerbot.PremadeSpecGlyph.4.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.4.1 =', f'AiPlayerbot.PremadeSpecGlyph.4.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.4.2 =', f'AiPlayerbot.PremadeSpecGlyph.4.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.5.0 =', f'AiPlayerbot.PremadeSpecGlyph.5.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.5.1 =', f'AiPlayerbot.PremadeSpecGlyph.5.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.5.2 =', f'AiPlayerbot.PremadeSpecGlyph.5.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.7.0 =', f'AiPlayerbot.PremadeSpecGlyph.7.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.7.1 =', f'AiPlayerbot.PremadeSpecGlyph.7.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.7.2 =', f'AiPlayerbot.PremadeSpecGlyph.7.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.8.0 =', f'AiPlayerbot.PremadeSpecGlyph.8.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.8.1 =', f'AiPlayerbot.PremadeSpecGlyph.8.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.8.2 =', f'AiPlayerbot.PremadeSpecGlyph.8.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.8.3 =', f'AiPlayerbot.PremadeSpecGlyph.8.3 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.9.0 =', f'AiPlayerbot.PremadeSpecGlyph.9.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.9.1 =', f'AiPlayerbot.PremadeSpecGlyph.9.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.9.2 =', f'AiPlayerbot.PremadeSpecGlyph.9.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.11.0 =', f'AiPlayerbot.PremadeSpecGlyph.11.0 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.11.1 =', f'AiPlayerbot.PremadeSpecGlyph.11.1 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.11.2 =', f'AiPlayerbot.PremadeSpecGlyph.11.2 = 0,0,0,0,0,0'])
    configs[6][4].append(['AiPlayerbot.PremadeSpecGlyph.11.3 =', f'AiPlayerbot.PremadeSpecGlyph.11.3 = 0,0,0,0,0,0'])

if int(options['module.progression.patch']) < 12:
    configs[7][4].append(['BotLevelBrackets.NumRanges =', 'BotLevelBrackets.NumRanges = 7'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range1.Pct   =', 'BotLevelBrackets.Alliance.Range1.Pct   = 0'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range2.Pct   =', 'BotLevelBrackets.Alliance.Range2.Pct   = 14'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range3.Pct   =', 'BotLevelBrackets.Alliance.Range3.Pct   = 14'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range4.Pct   =', 'BotLevelBrackets.Alliance.Range4.Pct   = 14'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range5.Pct   =', 'BotLevelBrackets.Alliance.Range5.Pct   = 14'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range6.Pct   =', 'BotLevelBrackets.Alliance.Range6.Pct   = 14'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range7.Upper =', 'BotLevelBrackets.Alliance.Range7.Upper = 60'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range7.Pct   =', 'BotLevelBrackets.Alliance.Range7.Pct   = 30'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range8.Pct   =', 'BotLevelBrackets.Alliance.Range8.Pct   = 0'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range9.Pct   =', 'BotLevelBrackets.Alliance.Range9.Pct   = 0'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range1.Pct   =', 'BotLevelBrackets.Horde.Range1.Pct   = 0'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range2.Pct   =', 'BotLevelBrackets.Horde.Range2.Pct   = 14'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range3.Pct   =', 'BotLevelBrackets.Horde.Range3.Pct   = 14'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range4.Pct   =', 'BotLevelBrackets.Horde.Range4.Pct   = 14'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range5.Pct   =', 'BotLevelBrackets.Horde.Range5.Pct   = 14'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range6.Pct   =', 'BotLevelBrackets.Horde.Range6.Pct   = 14'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range7.Upper =', 'BotLevelBrackets.Horde.Range7.Upper = 60'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range7.Pct   =', 'BotLevelBrackets.Horde.Range7.Pct   = 30'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range8.Pct   =', 'BotLevelBrackets.Horde.Range8.Pct   = 0'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range9.Pct   =', 'BotLevelBrackets.Horde.Range9.Pct   = 0'])
elif int(options['module.progression.patch']) < 17:
    configs[7][4].append(['BotLevelBrackets.NumRanges =', 'BotLevelBrackets.NumRanges = 8'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range1.Pct   =', 'BotLevelBrackets.Alliance.Range1.Pct   = 0'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range2.Pct   =', 'BotLevelBrackets.Alliance.Range2.Pct   = 12'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range3.Pct   =', 'BotLevelBrackets.Alliance.Range3.Pct   = 12'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range4.Pct   =', 'BotLevelBrackets.Alliance.Range4.Pct   = 12'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range5.Pct   =', 'BotLevelBrackets.Alliance.Range5.Pct   = 12'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range6.Pct   =', 'BotLevelBrackets.Alliance.Range6.Pct   = 12'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range7.Pct   =', 'BotLevelBrackets.Alliance.Range7.Pct   = 12'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range8.Upper =', 'BotLevelBrackets.Alliance.Range8.Upper = 70'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range8.Pct   =', 'BotLevelBrackets.Alliance.Range8.Pct   = 28'])
    configs[7][4].append(['BotLevelBrackets.Alliance.Range9.Pct   =', 'BotLevelBrackets.Alliance.Range9.Pct   = 0'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range1.Pct   =', 'BotLevelBrackets.Horde.Range1.Pct   = 0'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range2.Pct   =', 'BotLevelBrackets.Horde.Range2.Pct   = 12'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range3.Pct   =', 'BotLevelBrackets.Horde.Range3.Pct   = 12'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range4.Pct   =', 'BotLevelBrackets.Horde.Range4.Pct   = 12'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range5.Pct   =', 'BotLevelBrackets.Horde.Range5.Pct   = 12'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range6.Pct   =', 'BotLevelBrackets.Horde.Range6.Pct   = 12'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range7.Pct   =', 'BotLevelBrackets.Horde.Range7.Pct   = 12'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range8.Upper =', 'BotLevelBrackets.Horde.Range8.Upper = 70'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range8.Pct   =', 'BotLevelBrackets.Horde.Range8.Pct   = 28'])
    configs[7][4].append(['BotLevelBrackets.Horde.Range9.Pct   =', 'BotLevelBrackets.Horde.Range9.Pct   = 0'])

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

        if int(options['module.progression.patch']) < patch:
            continue

        UpdateConfig(f'{path}/{filename}', replacements)

    PrintHeader('Finished updating config files...')

##################################################

databases = [
    # auth
    [options['database.auth'], True, False, f'{source}/data/sql/base/db_auth', False, '', 0],
    [options['database.auth'], True, False, f'{source}/data/sql/updates/db_auth', True, 'RELEASED', 0],
    [options['database.auth'], True, False, f'{source}/data/sql/custom/db_auth', True, 'CUSTOM', 0],
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
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_00-1_1/sql', not options['module.progression.reset'], 'MODULE', 0],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_01-1_2/sql', not options['module.progression.reset'], 'MODULE', 1],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_02-1_3/sql', not options['module.progression.reset'], 'MODULE', 2],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_03-1_4/sql', not options['module.progression.reset'], 'MODULE', 3],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_04-1_5/sql', not options['module.progression.reset'], 'MODULE', 4],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_05-1_6/sql', not options['module.progression.reset'], 'MODULE', 5],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_06-1_7/sql', not options['module.progression.reset'], 'MODULE', 6],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_07-1_8/sql', not options['module.progression.reset'], 'MODULE', 7],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_08-1_9/sql', not options['module.progression.reset'], 'MODULE', 8],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_09-1_10/sql', not options['module.progression.reset'], 'MODULE', 9],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_10-1_11/sql', not options['module.progression.reset'], 'MODULE', 10],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_11-1_12/sql', not options['module.progression.reset'], 'MODULE', 11],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_12-2_0/sql', not options['module.progression.reset'], 'MODULE', 12],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_13-2_1/sql', not options['module.progression.reset'], 'MODULE', 13],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_14-2_2/sql', not options['module.progression.reset'], 'MODULE', 14],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_15-2_3/sql', not options['module.progression.reset'], 'MODULE', 15],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_16-2_4/sql', not options['module.progression.reset'], 'MODULE', 16],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_17-3_0/sql', not options['module.progression.reset'], 'MODULE', 17],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_18-3_1/sql', not options['module.progression.reset'], 'MODULE', 18],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_19-3_2/sql', not options['module.progression.reset'], 'MODULE', 19],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_20-3_3/sql', not options['module.progression.reset'], 'MODULE', 20],
    [options['database.world'], options['module.progression.enabled'], True, f'{source}/modules/mod-progression/src/patch_21-3_3_5/sql', not options['module.progression.reset'], 'MODULE', 21],
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
        cursor.execute('SELECT `name`, `hash` FROM `updates`')
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
                        cursor.execute(f"DELETE FROM `updates` WHERE `name` = '{file}';")
                        cursor.execute(f"INSERT INTO `updates` (`name`, `hash`, `state`) VALUES ('{file}', '{sha}', '{type}');")
                        connect.commit()

        cursor.close()
        connect.close()

def UpdateRealmList():
    PrintProgress(f'Adding to the realmlist (id: {realm_id}, name: {options['world.name']}, address: {options['world.address']}, localAddress: {options['world.local_address']}, port: {realm_port})')

    try:
        connect = pymysql.connect(host=mysql_hostname, port=mysql_port, user=mysql_username, password=mysql_password, db=options['database.auth'])
        cursor = connect.cursor()
        cursor.execute(f'DELETE FROM `realmlist` WHERE `id` = {realm_id};')
        cursor.execute(f"INSERT INTO `realmlist` (`id`, `name`, `address`, `localAddress`, `port`) VALUES ({realm_id}, '{options['world.name']}', '{options['world.address']}', '{options['world.local_address']}', {realm_port});")
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
        cursor.execute(f'DELETE FROM `motd` WHERE `realmid` = {realm_id};')
        cursor.execute(f"INSERT INTO `motd` (`realmid`, `text`) VALUES ({realm_id}, 'Welcome to {options['world.name']}');")
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

        if int(options['module.progression.patch']) < patch:
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
    for c in range(1, 30):
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
    RestartServer()
