# Linux: apt install -y git screen cmake make gcc clang g++ libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost1.83-all-dev libmysqlclient-dev mysql-client python3-git python3-requests python3-tqdm python3-pymysql python3-colorama
# wget https://repo.mysql.com/mysql-apt-config_0.8.36-1_all.deb
# dpkg -i mysql-apt-config_0.8.36-1_all.deb
# apt update && apt install -y mysql-server

# Windows: pip install cryptography gitpython pymysql requests tqdm
# ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

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

mysql_config = {
    'hostname': '127.0.0.1',
    'port': 3306,
    'username': 'acore',
    'password': 'acore',
    'database': 'acore_auth'
}

realm_id = 1
realm_port = 29724 + realm_id

options = {}
nested_options = {
    'build': {
        'auth': True,
        'world': True
    },
    'git': {
        'branch': 'master',
        'repository': 'azerothcore/azerothcore-wotlk',
        'use_ssh': False
    },
    'module': {
        'assistant': {
            'enabled': False
        },
        'dungeoneer': {
            'enabled': False
        },
        'fixes': {
            'enabled': False
        },
        'gamemaster': {
            'enabled': False
        },
        'junktogold': {
            'enabled': False
        },
        'learnspells': {
            'enabled': False
        },
        'playerbots': {
            'enabled': False,
            'auto_equip_upgrades': True,
            'auto_select_quest_reward': True,
            'random_bots': {
                'active_alone': 100,
                'maximum': 50,
                'minimum': 50,
                'only_with_players': False,
                'smart_scale': False
            },
            'drop_obsolete_quests': True
        },
        'playerbots_level_brackets': {
            'dynamic_distribution': False,
            'enabled': False
        },
        'progression': {
            'aura': 6,
            'enabled': False,
            'phase': 19,
            'reset': False
        },
        'skip_dk_starting_area': {
            'enabled': False
        },
        'stop_killing_them': {
            'enabled': False
        },
        'weekendbonus': {
            'enabled': False
        }
    },
    'mysql': {
        'database': {
            'characters': 'acore_characters',
            'playerbots': 'acore_playerbots',
            'world': 'acore_world'
        }
    },
    'telegram': {
        'chat_id': 0,
        'token': 0
    },
    'world': {
        'address': '127.0.0.1',
        'data': {
            'directory': '.',
            'use_pre_extracted_files': True
        },
        'game_type': 0,
        'rate': {
            'experience': 1.0
        },
        'infinite_ammo': False,
        'local_address': '127.0.0.1',
        'map_update_threads': -1,
        'name': 'AzerothCore',
        'preload_grids': False,
        'realm_zone': 1,
        'warden': True
    }
}

windows_paths = {
    'msbuild': 'C:/Program Files/Microsoft Visual Studio/18/Community/MSBuild/Current/Bin',
    'mysql': 'C:/Program Files/MySQL/MySQL Server 8.4',
    'openssl': 'C:/Program Files/OpenSSL-Win64',
    'cmake': 'C:/Program Files/CMake'
}

def ReportError(message):
    if options.get('telegram.chat_id', 0) and options.get('telegram.token', 0):
        try:
            requests.get(
                f'https://api.telegram.org/bot{options.get('telegram.token', 0)}/sendMessage'
                f'?chat_id={options.get('telegram.chat_id', 0)}&text=[{options.get('world.name', 'AzerothCore')} (id: {realm_id})]: {message}'
            ).json()
        except:
            pass

    os.remove(mysql_cnf) if os.path.exists(mysql_cnf) else None

    print(f'{colorama.Fore.RED}{message}{colorama.Style.RESET_ALL}')
    print(f'{colorama.Fore.GREEN}The script finished after {FormattedTime(int(time.time() - start_time))}...{colorama.Style.RESET_ALL}')
    sys.exit(1)

def FormattedTime(seconds):
    if seconds < 1:
        return 'less than a second'

    h, m, s = seconds // 3600, (seconds % 3600) // 60, seconds % 60
    parts = [
        f'{h} hour{'s' if h != 1 else ''}' if h else '',
        f'{m} minute{'s' if m != 1 else ''}' if m else '',
        f'{s} second{'s' if s != 1 else ''}' if s or not (h or m) else ''
    ]

    return ' and '.join(filter(None, parts))

def GetFileHash(file):
    with open(file, 'rb') as f:
        return hashlib.file_digest(f, 'sha1').hexdigest()

arguments = [
    [ [ 'install', 'setup', 'update' ], 'Downloads the source code, with enabled modules, and compiles it' ],
    [ 'data', 'Download and extract the client data files'],
    [ [ 'database', 'db' ], 'Import all files to the specified databases' ],
    [ [ 'config', 'conf', 'cfg', 'settings', 'options' ], 'Updates all config files, including enabled modules, with options specified' ],
    [ 'dbc', 'Copy modified client data files to the proper folder' ],
    [ 'reset', 'Drops all database tables from the world database' ],
    [ 'all', 'Run all parameters listed above, excluding reset but including stop and start' ],
    [ 'start', 'Starts the compiled processes, based off of the choice for compilation' ],
    [ 'stop', 'Stops the compiled processes, based off of the choice for compilation' ],
    [ 'restart', 'Stops and then starts the compiled processes, based off of the choice for compilation' ],
]

def PrintAvailableArguments():
    os.system('cls' if os.name == 'nt' else 'clear')
    print(f'{colorama.Fore.GREEN}Available arguments{colorama.Style.RESET_ALL}')

    max_len = max(len('/'.join(arg[0]) if isinstance(arg[0], list) else arg[0]) for arg in arguments)

    for arg in arguments:
        param = '/'.join(arg[0]) if isinstance(arg[0], list) else arg[0]
        desc = arg[1]
        print(f'{colorama.Fore.YELLOW}{param}{colorama.Fore.WHITE}{' ' * (max_len - len(param))} | '
              f'{colorama.Fore.BLUE}{desc}{colorama.Style.RESET_ALL}')

    sys.exit(1)

def LoadOptionsFromDatabase():
    print(f'{colorama.Fore.GREEN}Loading options from the database...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()

    def SetNestedValue(d, keys, value):
        for k in keys[:-1]:
            d = d.setdefault(k, {})
        d[keys[-1]] = True if value == 'true' else False if value == 'false' else value

    def FlattenDict(d, parent_key = '', sep = '.'):
        items = {}
        for k, v in d.items():
            new_key = f'{parent_key}{sep}{k}' if parent_key else k
            if isinstance(v, dict):
                items.update(FlattenDict(v, new_key, sep=sep))
            else:
                items[new_key] = v
        return items

    try:
        with pymysql.connect(host=mysql_config['hostname'], port=mysql_config['port'], user=mysql_config['username'], password=mysql_config['password'], db=mysql_config['database']) as connect:
            with connect.cursor() as cursor:
                cursor.execute(f'''
                    WITH s AS (
                        SELECT `id`, `setting`, `value`,
                               ROW_NUMBER() OVER (PARTITION BY `setting` ORDER BY `id` DESC) nr
                        FROM `realm_settings`
                        WHERE `id` = {realm_id} OR `id` = -1
                    )
                    SELECT `setting`, `value` FROM s WHERE nr = 1;
                ''')
                for key, value in cursor.fetchall():
                    SetNestedValue(nested_options, key.split('.'), value)
                    print(f'{colorama.Fore.YELLOW}{key} has been set to {value}{colorama.Style.RESET_ALL}')

        global options
        options = FlattenDict(nested_options)
    except pymysql.Error as e:
        ReportError(e.args[1])

    print(f'{colorama.Fore.GREEN}Finished loading options from the database after {FormattedTime(int(time.time() - function_start_time))}...{colorama.Style.RESET_ALL}')

def CreateBaseFolders():
    folders = [
        (options.get('build.world', True), 'dbc'),
        (True, 'logs'),
        (True, 'sql/auth'),
        (options.get('build.world', True), 'sql/characters'),
        (options.get('build.world', True), 'sql/world')
    ]

    created = False
    for enabled, folder in folders:
        path = os.path.join(cwd, folder)

        if not enabled:
            if os.path.exists(path): shutil.rmtree(path)
            continue

        if not os.path.exists(path):
            os.makedirs(path, 0o777)
            created = True

    if created:
        print(f'{colorama.Fore.YELLOW}At least one base folder was created. Stopping script to allow adding files to these folders{colorama.Style.RESET_ALL}')
        sys.exit(1)

class Progress(git.remote.RemoteProgress):
    def line_dropped(self, line): print(line)
    def update(self, *args): print(self._cur_line)

def DownloadOrUpdateSourceCode(repo, path, branch, name):
    url = f'{'git@github.com:' if options.get('git.use_ssh', False) else 'https://github.com/'}{repo}'
    try:
        if not os.path.exists(path):
            print(f'{colorama.Fore.YELLOW}Downloading the source code for {name}{colorama.Style.RESET_ALL}')
            git.Repo.clone_from(url=url, to_path=path, branch=branch, depth=1, single_branch=True, progress=Progress())
        else:
            print(f'{colorama.Fore.YELLOW}Updating the source code for {name}{colorama.Style.RESET_ALL}')
            git.Repo(path).git.reset('--hard', f'origin/{branch}')
            git.Repo(path).remotes.origin.pull(progress=Progress())
    except:
        ReportError(f'Failed to download or update the source code for {name}')

def DownloadSourceCode():
    print(f'{colorama.Fore.GREEN}Downloading source code...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()

    DownloadOrUpdateSourceCode(options.get('git.repository', 'azerothcore/azerothcore-wotlk'), os.path.join(cwd, 'source'), options.get('git.branch', 'master'), 'azerothcore')

    if options.get('build.world', True):
        modules = [
            ('mod-assistant', 'noisiver/mod-assistant', 'master', options.get('module.assistant.enabled', False)),
            ('mod-dungeoneer', 'noisiver/mod-dungeoneer', 'master', options.get('module.dungeoneer.enabled', False)),
            ('mod-fixes', 'noisiver/mod-fixes', 'master', options.get('module.fixes.enabled', False)),
            ('mod-gamemaster', 'noisiver/mod-gamemaster', 'master', options.get('module.gamemaster.enabled', False)),
            ('mod-junk-to-gold', 'noisiver/mod-junk-to-gold', 'master', options.get('module.junktogold.enabled', False)),
            ('mod-learnspells', 'noisiver/mod-learnspells', 'master', options.get('module.learnspells.enabled', False)),
            ('mod-playerbots', 'noisiver/mod-playerbots', 'noisiver', options.get('module.playerbots.enabled', False)),
            ('mod-player-bot-level-brackets', 'DustinHendrickson/mod-player-bot-level-brackets', 'main', options.get('module.playerbots.enabled', False) and options.get('module.playerbots_level_brackets.enabled', False)),
            ('mod-progression', 'noisiver/mod-progression', 'phases', options.get('module.progression.enabled', False)),
            ('mod-skip-dk-starting-area', 'azerothcore/mod-skip-dk-starting-area', 'master', options.get('module.skip_dk_starting_area.enabled', False) and int(options.get('module.progression.phase', 19)) >= 14),
            ('mod-stop-killing-them', 'noisiver/mod-stop-killing-them', 'master', options.get('module.stop_killing_them.enabled', False) and int(options.get('module.progression.phase', 19)) >= 7),
            ('mod-weekendbonus', 'noisiver/mod-weekendbonus', 'master', options.get('module.weekendbonus.enabled', False))
        ]

        [DownloadOrUpdateSourceCode(repo, os.path.join(cwd, 'source/modules', name), branch, name)
         for name, repo, branch, enabled in modules if enabled]

    print(f'{colorama.Fore.GREEN}Finished downloading source code after {FormattedTime(int(time.time() - function_start_time))}...{colorama.Style.RESET_ALL}')

def GenerateProject():
    print(f'{colorama.Fore.GREEN}Generating project files...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()

    apps = 'all' if options.get('build.auth', True) and options.get('build.world', True) else 'auth-only' if options.get('build.auth', True) else 'world-only'
    cmake_cmd = f'{windows_paths['cmake']}/bin/cmake.exe' if os.name == 'nt' else 'cmake'

    args = [
        f'-S {cwd}/source',
        f'-B {cwd}/source/build',
        '-DWITH_WARNINGS=0',
        '-DSCRIPTS=static',
        f'-DAPPS_BUILD={apps}',
    ] + (
        [
            '-Wno-dev',
            f'-DMYSQL_EXECUTABLE={windows_paths['mysql']}/bin/mysql.exe',
            f'-DMYSQL_INCLUDE_DIR={windows_paths['mysql']}/include',
            f'-DMYSQL_LIBRARY={windows_paths['mysql']}/lib/libmysql.lib'
        ] if os.name == 'nt' else
        [
            f'-DCMAKE_INSTALL_PREFIX={cwd}/source',
            '-DCMAKE_C_COMPILER=/usr/bin/clang',
            '-DCMAKE_CXX_COMPILER=/usr/bin/clang++',
            '-DCMAKE_CXX_FLAGS="-w"'
        ]
    )

    try:
        subprocess.run([cmake_cmd, *args], check=True)
    except:
        ReportError('Failed to generate the project files')

    print(f'{colorama.Fore.GREEN}Finished generating project files after {FormattedTime(int(time.time() - function_start_time))}...{colorama.Style.RESET_ALL}')

def CompileSourceCode():
    print(f'{colorama.Fore.GREEN}Compiling the source code...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()
    is_windows = os.name == 'nt'

    if is_windows:
        target = ('authserver' if options.get('build.auth', True) and not options.get('build.world', True) else
                  'worldserver' if not options.get('build.auth', True) and options.get('build.world', True) else
                  'ALL_BUILD')
        build_cmd, build_args, clean_args = f'{windows_paths['msbuild']}/MSBuild.exe', [f'{cwd}/source/build/AzerothCore.slnx', '/p:Configuration=RelWithDebInfo', '/p:WarningLevel=0', f'/target:{target}'], [f'{cwd}/source/build/AzerothCore.sln', '/t:Clean']
    else:
        build_cmd, build_args, clean_args = 'make', ['-j', str(multiprocessing.cpu_count()), 'install'], ['clean']

    for attempt in range(2):
        try:
            subprocess.run([build_cmd, *build_args], cwd=f'{cwd}/source/build', check=True)
            break
        except:
            if attempt == 0:
                try:
                    subprocess.run([build_cmd, *clean_args], cwd=f'{cwd}/source/build', check=True)
                except:
                    ReportError('Failed to clean the project')
            else:
                ReportError('Failed to compile the source code')

    print(f'{colorama.Fore.GREEN}Finished compiling the source code after {FormattedTime(int(time.time() - function_start_time))}...{colorama.Style.RESET_ALL}')

def CreateRequiredScripts():
    print(f'{colorama.Fore.GREEN}Creating required scripts...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()

    scripts = [
        [f'auth.{'bat' if os.name == 'nt' else 'sh'}', options.get('build.auth', True),
         cwd if os.name == 'nt' else f'{cwd}/source/bin',
         '@echo off\ncd source/build/bin/RelWithDebInfo\n:auth\n    authserver.exe\ngoto auth\n' if os.name == 'nt' else
         '#!/bin/bash\nwhile :; do\n    ./authserver\n    sleep 5\ndone\n'],
        [f'world.{'bat' if os.name == 'nt' else 'sh'}', options.get('build.world', True),
         cwd if os.name == 'nt' else f'{cwd}/source/bin',
         '@echo off\ncd source/build/bin/RelWithDebInfo\n:world\n    worldserver.exe\n    timeout 5\ngoto world\n' if os.name == 'nt' else
         '#!/bin/bash\nwhile :; do\n    ./worldserver\n    [[ $? == 0 ]] && break\n    sleep 5\ndone\n'],
        ['start.sh', os.name != 'nt', f'{cwd}/source/bin',
         f'#!/bin/bash\n{'screen -AmdS auth ./auth.sh\n' if options.get('build.auth', True) else ''}'
         f'{f'time=$(date +%s)\nscreen -L -Logfile $time.log -AmdS world-{realm_id} ./world.sh\n' if options.get('build.world', True) else ''}'],
        ['stop.sh', os.name != 'nt', f'{cwd}/source/bin',
         f'#!/bin/bash\n{'screen -X -S auth quit\n' if options.get('build.auth', True) else ''}'
         f'{f'screen -X -S world-{realm_id} quit\n' if options.get('build.world', True) else ''}']
    ]

    for name, enabled, path, text in scripts:
        full_path = f'{path}/{name}'
        if not enabled:
            if os.path.exists(full_path):
                print(f'{colorama.Fore.YELLOW}Removing {name}{colorama.Style.RESET_ALL}')
                os.remove(full_path)
            continue

        print(f'{colorama.Fore.YELLOW}Creating {name}{colorama.Style.RESET_ALL}')
        try:
            with open(full_path, 'w') as f:
                f.write(text)
            Path(full_path).chmod(Path(full_path).stat().st_mode | stat.S_IEXEC)
        except:
            ReportError(f'Failed to create {name}')

    print(f'{colorama.Fore.GREEN}Finished creating required scripts after {FormattedTime(int(time.time() - function_start_time))}...{colorama.Style.RESET_ALL}')

def CopyRequiredLibraries():
    if not os.name == 'nt':
        return

    print(f'{colorama.Fore.GREEN}Copying required libraries...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()

    libraries = {
        f'{windows_paths['openssl']}/bin': [
            'legacy.dll',
            'libcrypto-3-x64.dll',
            'libssl-3-x64.dll'
        ],
        f'{windows_paths['mysql']}/lib': ['libmysql.dll']
    }

    for src_dir, files in libraries.items():
        for filename in files:
            print(f'{colorama.Fore.YELLOW}Copying {filename}{colorama.Style.RESET_ALL}')
            try:
                shutil.copyfile(f'{src_dir}/{filename}', f'{cwd}/source/build/bin/RelWithDebInfo/{filename}')
            except:
                ReportError('Failed to copy required libraries')

    print(f'{colorama.Fore.GREEN}Finished copying required libraries after {FormattedTime(int(time.time() - function_start_time))}...{colorama.Style.RESET_ALL}')

def GetClientDataPath():
    data_dir = options.get('world.data.directory', '.')
    binary_path = f'{cwd}/source/bin/RelWithDebInfo' if os.name == 'nt' else f'{cwd}/source/bin'
    return binary_path if data_dir == '.' else f'{binary_path}/{data_dir[2:]}' if data_dir.startswith('./') else data_dir

def DownloadClientDataFiles():
    if not options.get('build.world', True):
        if sys.argv[1].lower() == 'data':
            print(f'{colorama.Fore.RED}Skipped because world is not enabled{colorama.Style.RESET_ALL}')
        return

    if not options.get('world.data.use_pre_extracted_files', True):
        if sys.argv[1].lower() == 'data':
            print(f'{colorama.Fore.RED}Skipped because use of pre-extracted data is disabled{colorama.Style.RESET_ALL}')
        return

    print(f'{colorama.Fore.GREEN}Downloading client data files...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()
    data_path = GetClientDataPath()
    version_file = f'{data_path}/data.version'
    dirs = ['Cameras', 'dbc', 'maps', 'mmaps', 'vmaps']

    local_version = 0
    if os.path.isfile(version_file):
        with open(version_file, 'r') as f:
            local_version = f.read().strip()
    if any(not os.path.exists(f'{data_path}/{d}') for d in dirs):
        local_version = 0

    try:
        remote_version = sorted(git.cmd.Git().ls_remote('--tags', 'https://github.com/wowgaming/client-data.git').split('\n'), reverse=True)[0].rsplit('/', 1)[1].replace('v', '')
    except:
        ReportError('Failed to retrieve the latest client data version')

    if str(local_version) != remote_version:
        [shutil.rmtree(f'{data_path}/{d}', ignore_errors=True) for d in dirs]
        os.path.exists(f'{cwd}/data.zip') and os.remove(f'{cwd}/data.zip')

        print(f'{colorama.Fore.YELLOW}Downloading archive version {remote_version}{colorama.Style.RESET_ALL}')
        response = requests.get(f'https://github.com/wowgaming/client-data/releases/download/v{remote_version}/data.zip', stream=True)
        if response.status_code != 200:
            ReportError('Failed to download the client data files')

        try:
            with open(f'{cwd}/data.zip', 'wb') as f, tqdm(total=int(response.headers.get('content-length', 0)), unit='iB', unit_scale=True, unit_divisor=1024) as bar:
                [bar.update(f.write(chunk)) for chunk in response.iter_content(1024)]
        except:
            ReportError('Failed to download the client data files')

        try:
            print(f'{colorama.Fore.YELLOW}Extracting archive version {remote_version}{colorama.Style.RESET_ALL}')
            shutil.unpack_archive(f'{cwd}/data.zip', data_path)
            with open(version_file, 'w') as f: f.write(remote_version)
        except:
            ReportError('Failed to extract client data files')

        os.path.exists(f'{cwd}/data.zip') and os.remove(f'{cwd}/data.zip')
    else:
        print(f'{colorama.Fore.YELLOW}The files are up-to-date{colorama.Style.RESET_ALL}')

    print(f'{colorama.Fore.GREEN}Finished downloading client data files after {FormattedTime(int(time.time() - function_start_time))}...{colorama.Style.RESET_ALL}')

def CopyDBCFiles():
    if not options.get('build.world', True):
        if sys.argv[1].lower() == 'dbc':
            print(f'{colorama.Fore.RED}Skipped because world is not enabled{colorama.Style.RESET_ALL}')
        return

    print(f'{colorama.Fore.GREEN}Copying dbc files...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()

    dbc_path = os.path.join(cwd, 'dbc')
    files = [f for f in sorted(os.listdir(dbc_path)) if f.endswith('.dbc') and os.path.isfile(os.path.join(dbc_path, f))]

    if files:
        for file in files:
            print(f'{colorama.Fore.YELLOW}Copying {file}{colorama.Style.RESET_ALL}')
            try:
                shutil.copyfile(os.path.join(dbc_path, file), os.path.join(GetClientDataPath(), 'dbc', file))
            except OSError as e:
                ReportError(f'Failed to copy {file}: {e.strerror if hasattr(e, 'strerror') else e}')
            except Exception as e:
                ReportError(f'Failed to copy {file}: Unexpected error ({e})')
    else:
        print(f'{colorama.Fore.YELLOW}No files found in the directory{colorama.Style.RESET_ALL}')

    print(f'{colorama.Fore.GREEN}Finished copying dbc files after {FormattedTime(int(time.time() - function_start_time))}...{colorama.Style.RESET_ALL}')

def ImportDatabaseFiles():
    print(f'{colorama.Fore.GREEN}Importing database files...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()

    with open(mysql_cnf, 'w') as f:
        f.write(f'[client]\nhost="{mysql_config['hostname']}"\nport="{mysql_config['port']}"\nuser="{mysql_config['username']}"\npassword="{mysql_config['password']}"')

    databases = {
        mysql_config['database']: [
            [True, f'{cwd}/source/data/sql/base/db_auth', None],
            [True, f'{cwd}/source/data/sql/updates/db_auth', 'RELEASED'],
            [True, f'{cwd}/source/data/sql/custom/db_auth', 'CUSTOM'],
            [True, f'{cwd}/sql/auth', None]
        ],
        options.get('mysql.database.characters', 'acore_characters'): [
            [options.get('build.world', True), f'{cwd}/source/data/sql/base/db_characters', None],
            [options.get('build.world', True), f'{cwd}/source/data/sql/updates/db_characters', 'RELEASED'],
            [options.get('build.world', True), f'{cwd}/source/data/sql/custom/db_characters', 'CUSTOM'],
            [options.get('build.world', True) and options.get('module.playerbots.enabled', False), f'{cwd}/source/modules/mod-playerbots/data/sql/characters/base', None],
            [options.get('build.world', True) and options.get('module.playerbots.enabled', False), f'{cwd}/source/modules/mod-playerbots/data/sql/characters/updates', 'RELEASED'],
            [options.get('build.world', True), f'{cwd}/sql/characters', None]
        ],
        options.get('mysql.database.playerbots', 'acore_playerbots'): [
            [options.get('build.world', True) and options.get('module.playerbots.enabled', False), f'{cwd}/source/modules/mod-playerbots/data/sql/playerbots/base', None],
            [options.get('build.world', True) and options.get('module.playerbots.enabled', False), f'{cwd}/source/modules/mod-playerbots/data/sql/playerbots/updates', 'RELEASED'],
            [options.get('build.world', True) and options.get('module.playerbots.enabled', False), f'{cwd}/source/modules/mod-playerbots/data/sql/playerbots/custom', 'CUSTOM']
        ],
        options.get('mysql.database.world', 'acore_world'): [
            [options.get('build.world', True), f'{cwd}/source/data/sql/base/db_world', None],
            [options.get('build.world', True), f'{cwd}/source/data/sql/updates/db_world', 'RELEASED'],
            [options.get('build.world', True), f'{cwd}/source/data/sql/custom/db_world', 'CUSTOM'],
            [options.get('build.world', True) and options.get('module.assistant.enabled', False), f'{cwd}/source/modules/mod-assistant/data/sql/world', 'MODULE'],
            [options.get('build.world', True) and options.get('module.fixes.enabled', False), f'{cwd}/source/modules/mod-fixes/data/sql/world', 'MODULE'],
            [options.get('build.world', True) and options.get('module.learnspells.enabled', False), f'{cwd}/source/modules/mod-learnspells/data/sql/world', 'MODULE'],
            [options.get('build.world', True) and options.get('module.playerbots.enabled', False), f'{cwd}/source/modules/mod-playerbots/data/sql/world/base', 'MODULE'],
            [options.get('build.world', True) and options.get('module.playerbots.enabled', False), f'{cwd}/source/modules/mod-playerbots/data/sql/world/updates', 'RELEASED'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False), f'{cwd}/source/modules/mod-progression/src/phase_00/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 1, f'{cwd}/source/modules/mod-progression/src/phase_01/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 2, f'{cwd}/source/modules/mod-progression/src/phase_02/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 3, f'{cwd}/source/modules/mod-progression/src/phase_03/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 4, f'{cwd}/source/modules/mod-progression/src/phase_04/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 5, f'{cwd}/source/modules/mod-progression/src/phase_05/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 6, f'{cwd}/source/modules/mod-progression/src/phase_06/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 7, f'{cwd}/source/modules/mod-progression/src/phase_07/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 8, f'{cwd}/source/modules/mod-progression/src/phase_08/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 9, f'{cwd}/source/modules/mod-progression/src/phase_09/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 10, f'{cwd}/source/modules/mod-progression/src/phase_10/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 11, f'{cwd}/source/modules/mod-progression/src/phase_11/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 12, f'{cwd}/source/modules/mod-progression/src/phase_12/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 13, f'{cwd}/source/modules/mod-progression/src/phase_13/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 14, f'{cwd}/source/modules/mod-progression/src/phase_14/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 15, f'{cwd}/source/modules/mod-progression/src/phase_15/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 16, f'{cwd}/source/modules/mod-progression/src/phase_16/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 17, f'{cwd}/source/modules/mod-progression/src/phase_17/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 18, f'{cwd}/source/modules/mod-progression/src/phase_18/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.progression.enabled', False) and int(options.get('module.progression.phase', 19)) >= 19, f'{cwd}/source/modules/mod-progression/src/phase_19/sql', None if options.get('module.progression.reset', False) else 'MODULE'],
            [options.get('build.world', True) and options.get('module.skip_dk_starting_area.enabled', False) and int(options.get('module.progression.phase', 19)) >= 14, f'{cwd}/source/modules/mod-skip-dk-starting-area/data/sql/db-world', 'MODULE'],
            [options.get('build.world', True), f'{cwd}/sql/world', None]
        ]
    }

    for db_name, entries in databases.items():
        if not any(e[0] for e in entries):
            continue

        print(f'{colorama.Fore.MAGENTA}Importing database files for {db_name}...{colorama.Style.RESET_ALL}')
        section_start = time.time()

        try:
            with pymysql.connect(host=mysql_config['hostname'], port=mysql_config['port'], user=mysql_config['username'], password=mysql_config['password'], db=db_name) as connect:
                with connect.cursor() as cursor:
                    cursor.execute('SHOW TABLES;')
                    tables = [row[0] for row in cursor.fetchall()]
        except pymysql.MySQLError:
            ReportError(f'Failed to load table data from {db_name}')

        for enabled, directory, description in entries:
            if not enabled:
                continue
            if not os.path.exists(directory):
                ReportError(f'Failed to import database files for {db_name}')

            is_update = bool(description)
            updates = []
            if is_update:
                try:
                    with pymysql.connect(host=mysql_config['hostname'], port=mysql_config['port'], user=mysql_config['username'], password=mysql_config['password'], db=db_name) as connect:
                        with connect.cursor() as cursor:
                            cursor.execute('SELECT `name`, `hash` FROM `updates`;')
                            updates = [[row[0], row[1]] for row in cursor.fetchall()]
                except:
                    ReportError('Failed to load updates')

            for file in sorted(os.listdir(directory)):
                file_path = f'{directory}/{file}'
                if not os.path.isfile(file_path) or not file.endswith('.sql'):
                    continue

                sha = GetFileHash(file_path).upper()
                short = file.replace('.sql', '')

                if (is_update and [file, sha] in updates) or (not is_update and short in tables):
                    print(f'{colorama.Fore.YELLOW}Skipping {file}{colorama.Style.RESET_ALL}')
                    continue

                print(f'{colorama.Fore.YELLOW}Importing {file}{colorama.Style.RESET_ALL}')
                try:
                    subprocess.run(f'{f'"{windows_paths['mysql']}/bin/mysql.exe"' if os.name == 'nt' else 'mysql'} --defaults-extra-file={cwd}/mysql.cnf {db_name} < {file_path}', shell=True, check=True)
                except:
                    ReportError(f'Failed to import database file for {db_name}')

                if is_update:
                    try:
                        with pymysql.connect(host=mysql_config['hostname'], port=mysql_config['port'], user=mysql_config['username'], password=mysql_config['password'], db=db_name) as connect:
                            with connect.cursor() as cursor:
                                cursor.execute('DELETE FROM `updates` WHERE `name` = %s;', (file,))
                                cursor.execute('INSERT INTO `updates` (`name`, `hash`, `state`) VALUES (%s, %s, %s);', (file, sha, description))
                                connect.commit()
                    except:
                        ReportError('Failed to add file hash to updates')

        print(f'{colorama.Fore.MAGENTA}Finished importing database files for {db_name} after {FormattedTime(int(time.time() - section_start))}...{colorama.Style.RESET_ALL}')

    if options.get('build.world', True):
        print(f'{colorama.Fore.MAGENTA}Updating realmlist and message of the day...{colorama.Style.RESET_ALL}')
        section_start = time.time()
        try:
            with pymysql.connect(host=mysql_config['hostname'], port=mysql_config['port'], user=mysql_config['username'], password=mysql_config['password'], db=mysql_config['database']) as connect:
                with connect.cursor() as cursor:
                    print(f'{colorama.Fore.YELLOW}Updating realmlist{colorama.Style.RESET_ALL}')
                    cursor.execute(f'DELETE FROM `realmlist` WHERE `id` = %s;', (realm_id,))
                    cursor.execute('INSERT INTO `realmlist` (`id`, `name`, `address`, `localAddress`, `port`) VALUES (%s, %s, %s, %s, %s);',
                                   (realm_id, options.get('world.name', 'AzerothCore'), options.get('world.address', '127.0.0.1'), options.get('world.local_address', '127.0.0.1'), realm_port))

                    print(f'{colorama.Fore.YELLOW}Updating message of the day{colorama.Style.RESET_ALL}')
                    cursor.execute(f'DELETE FROM `motd` WHERE `realmid` = %s;', (realm_id,))
                    cursor.execute('INSERT INTO `motd` (`realmid`, `text`) VALUES (%s, %s);', (realm_id, f'Welcome to {options.get('world.name', 'AzerothCore')}'))

                    connect.commit()
        except pymysql.Error:
            ReportError('Failed to update realmlist and message of the day')

        print(f'{colorama.Fore.MAGENTA}Finished updating realmlist and message of the day after {FormattedTime(int(time.time() - section_start))}...{colorama.Style.RESET_ALL}')

    if os.path.exists(mysql_cnf):
        os.remove(mysql_cnf)

    print(f'{colorama.Fore.GREEN}Finished importing database files after {FormattedTime(int(time.time() - function_start_time))}...{colorama.Style.RESET_ALL}')

def UpdateConfigFiles():
    print(f'{colorama.Fore.GREEN}Updating config files...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()

    map_update_threads = int(options.get('world.map_update_threads', '-1'))
    phase_id = int(options.get('module.progression.phase', 19))
    random_bots_maximum = int(options.get('module.playerbots.random_bots.maximum', 50))
    mysql_hostname = mysql_config['hostname']
    mysql_port = mysql_config['port']
    mysql_username = mysql_config['username']
    mysql_password = mysql_config['password']
    mysql_database_auth = mysql_config['database']

    config_values = {
        'authserver.conf': {
            'enabled': options.get('build.auth', True),
            'options': {
                'LoginDatabaseInfo': {
                    'enabled': True,
                    'value': f'"{mysql_hostname};{mysql_config['port']};{mysql_username};{mysql_password};{mysql_database_auth}"'
                },
                'Updates.EnableDatabases': {
                    'enabled': True,
                    'value': 0
                },
                'LogsDir': {
                    'enabled': True,
                    'value': f'"{cwd}/logs"'
                }
            }
        },
        'worldserver.conf': {
            'enabled': options.get('build.world', True),
            'options': {
                'RealmID': {
                    'enabled': True,
                    'value': realm_id
                },
                'WorldServerPort': {
                    'enabled': True,
                    'value': realm_port
                },
                'LoginDatabaseInfo': {
                    'enabled': True,
                    'value': f'"{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{mysql_database_auth}"'
                },
                'WorldDatabaseInfo': {
                    'enabled': True,
                    'value': f'"{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options.get('mysql.database.world', 'acore_world')}"'
                },
                'CharacterDatabaseInfo': {
                    'enabled': True,
                    'value': f'"{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options.get('mysql.database.characters', 'acore_characters')}"'
                },
                'LoginDatabase.SynchThreads': {
                    'enabled': True,
                    'value': 2
                },
                'WorldDatabase.SynchThreads': {
                    'enabled': True,
                    'value': 2
                },
                'CharacterDatabase.SynchThreads': {
                    'enabled': True,
                    'value': 2
                },
                'DataDir': {
                    'enabled': True,
                    'value': f'"{GetClientDataPath()}"'
                },
                'LogsDir': {
                    'enabled': True,
                    'value': f'"{os.path.join(cwd, 'logs')}"'
                },
                'BeepAtStart': {
                    'enabled': os.name == 'nt',
                    'value': 0
                },
                'FlashAtStart': {
                    'enabled': os.name == 'nt',
                    'value': 0
                },
                'Updates.EnableDatabases': {
                    'enabled': True,
                    'value': 0
                },
                'GameType': {
                    'enabled': True,
                    'value': options.get('world.game_type', 0)
                },
                'RealmZone': {
                    'enabled': True,
                    'value': options.get('world.realm_zone', 1)
                },
                'MapUpdateInterval': {
                    'enabled': True,
                    'value': 100
                },
                'MapUpdate.Threads': {
                    'enabled': True,
                    'value': multiprocessing.cpu_count() if map_update_threads == -1 or map_update_threads == 0 else map_update_threads
                },
                'PreloadAllNonInstancedMapGrids': {
                    'enabled': options.get('world.preload_grids', False),
                    'value': 1
                },
                'GM.LoginState': {
                    'enabled': True,
                    'value': 1
                },
                'GM.Visible': {
                    'enabled': True,
                    'value': 0
                },
                'GM.Chat': {
                    'enabled': True,
                    'value': 1
                },
                'GM.WhisperingTo': {
                    'enabled': True,
                    'value': 0
                },
                'GM.InGMList.Level': {
                    'enabled': True,
                    'value': 1
                },
                'GM.InWhoList.Level': {
                    'enabled': True,
                    'value': 0
                },
                'StrictPlayerNames': {
                    'enabled': True,
                    'value': 3
                },
                'StrictPetNames': {
                    'enabled': True,
                    'value': 3
                },
                'HeroicCharactersPerRealm': {
                    'enabled': True,
                    'value': 10
                },
                'CharacterCreating.MinLevelForHeroicCharacter': {
                    'enabled': True,
                    'value': 0
                },
                'DBC.EnforceItemAttributes': {
                    'enabled': True,
                    'value': 0
                },
                'Quests.IgnoreRaid': {
                    'enabled': True,
                    'value': 1
                },
                'Quests.IgnoreAutoAccept': {
                    'enabled': True,
                    'value': 1
                },
                'DungeonFinder.CastDeserter': {
                    'enabled': True,
                    'value': 0
                },
                'StrictCharterNames': {
                    'enabled': True,
                    'value': 3
                },
                'Battleground.CastDeserter': {
                    'enabled': True,
                    'value': 0
                },
                'StrictChannelNames': {
                    'enabled': True,
                    'value': 3
                },
                'Minigob.Manabonk.Enable': {
                    'enabled': True,
                    'value': 0
                },
                'Daze.Enabled': {
                    'enabled': True,
                    'value': 0
                },
                'InfiniteAmmo.Enabled': {
                    'enabled': options.get('world.infinite_ammo', False),
                    'value': 1
                },
                'Rate.XP.Kill': {
                    'enabled': True,
                    'value': options.get('world.rate.experience', 1.0)
                },
                'Rate.XP.Quest': {
                    'enabled': True,
                    'value': options.get('world.rate.experience', 1.0)
                },
                'Rate.XP.Quest.DF': {
                    'enabled': True,
                    'value': options.get('world.rate.experience', 1.0)
                },
                'Rate.XP.Explore': {
                    'enabled': True,
                    'value': options.get('world.rate.experience', 1.0)
                },
                'Rate.XP.Pet': {
                    'enabled': True,
                    'value': options.get('world.rate.experience', 1.0)
                },
                'Warden.Enabled': {
                    'enabled': not options.get('world.warden', True),
                    'value': 0
                }
            }
        },
        'modules/mod_assistant.conf': {
            'enabled': options.get('build.world', True) and options.get('module.assistant.enabled', False),
            'options': {
                'Assistant.Heirlooms.Enabled': {
                    'enabled': phase_id < 14,
                    'value': 0
                },
                'Assistant.Glyphs.Enabled': {
                    'enabled': phase_id < 14,
                    'value': 0
                },
                'Assistant.Gems.Enabled': {
                    'enabled': phase_id < 14,
                    'value': 0
                },
                'Assistant.Elixirs.Enabled': {
                    'enabled': phase_id < 14,
                    'value': 0
                },
                'Assistant.Food.Enabled': {
                    'enabled': phase_id < 14,
                    'value': 0
                },
                'Assistant.Enchants.Enabled': {
                    'enabled': phase_id < 14,
                    'value': 0
                },
                'Assistant.FlightPaths.Vanilla.Enabled': {
                    'enabled': phase_id < 7,
                    'value': 0
                },
                'Assistant.FlightPaths.BurningCrusade.Enabled': {
                    'enabled': phase_id < 14,
                    'value': 0
                },
                'Assistant.Professions.Apprentice.Cost': {
                    'enabled': True,
                    'value': 100000 if phase_id < 14 else 1000000
                },
                'Assistant.Professions.Journeyman.Cost': {
                    'enabled': True,
                    'value': 250000 if phase_id < 14 else 2500000
                },
                'Assistant.Professions.Expert.Cost': {
                    'enabled': True,
                    'value': 500000 if phase_id < 14 else 5000000
                },
                'Assistant.Professions.Artisan.Cost': {
                    'enabled': True,
                    'value': 750000 if phase_id < 14 else 7500000
                },
                'Assistant.Professions.Master.Enabled': {
                    'enabled': phase_id >= 7,
                    'value': 1
                },
                'Assistant.Professions.Master.Cost': {
                    'enabled': True,
                    'value': 1250000 if phase_id < 14 else 12500000
                },
                'Assistant.Professions.GrandMaster.Enabled': {
                    'enabled': phase_id >= 14,
                    'value': 1
                },
                'Assistant.Instances.Heroic.Enabled': {
                    'enabled': phase_id < 8,
                    'value': 0
                }
            }
        },
        'modules/mod_learnspells.conf': {
            'enabled': options.get('build.world', True) and options.get('module.learnspells.enabled', False),
            'options': {
                'LearnSpells.Gamemasters': {
                    'enabled': True,
                    'value': 1
                },
                'LearnSpells.Riding.Apprentice': {
                    'enabled': True,
                    'value': 1
                },
                'LearnSpells.Riding.Journeyman': {
                    'enabled': True,
                    'value': 1
                },
                'LearnSpells.Riding.Expert': {
                    'enabled': True,
                    'value': 1
                }
            }
        },
        'modules/playerbots.conf': {
            'enabled': options.get('build.world', True) and options.get('module.playerbots.enabled', False),
            'options': {
                'AiPlayerbot.MinRandomBots': {
                    'enabled': True,
                    'value': options.get('module.playerbots.random_bots.minimum', 50)
                },
                'AiPlayerbot.MaxRandomBots': {
                    'enabled': True,
                    'value': random_bots_maximum
                },
                'AiPlayerbot.RandomBotAccountCount': {
                    'enabled': random_bots_maximum > 0,
                    'value': int(random_bots_maximum / (9 if phase_id < 14 else 10) + 1)
                },
                'AiPlayerbot.DisabledWithoutRealPlayer': {
                    'enabled': options.get('module.playerbots.random_bots.only_with_players', False),
                    'value': 1
                },
                'AiPlayerbot.RandomBotGuildCount': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.SelfBotLevel': {
                    'enabled': True,
                    'value': 2
                },
                'AiPlayerbot.SayWhenCollectingItems': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.MinBotsForGreaterBuff': {
                    'enabled': True,
                    'value': 1
                },
                'AiPlayerbot.AltMaintenanceAmmo': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceFood': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceReagents': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceConsumables': {
                    'enabled': True,
                    'value': 1
                },
                'AiPlayerbot.AltMaintenancePotions': {
                    'enabled': True,
                    'value': 1
                },
                'AiPlayerbot.AltMaintenanceBags': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceMounts': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceSkills': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceClassSpells': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceAvailableSpells': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceSpecialSpells': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceTalentTree': {
                    'enabled': phase_id >= 14,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceGlyphs': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceGemsEnchants': {
                    'enabled': phase_id >= 14,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenancePet': {
                    'enabled': phase_id >= 14,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenancePetTalents': {
                    'enabled': phase_id >= 14,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceReputation': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceAttunementQuests': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AltMaintenanceKeyring': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AutoGearQualityLimit': {
                    'enabled': True,
                    'value': 5
                },
                'AiPlayerbot.DisableDeathKnightLogin': {
                    'enabled': phase_id < 14,
                    'value': 1
                },
                'AiPlayerbot.DisableRandomLevels': {
                    'enabled': not options.get('module.playerbots_level_brackets.enabled', False),
                    'value': 1
                },
                'AiPlayerbot.RandombotStartingLevel': {
                    'enabled': not options.get('module.playerbots_level_brackets.enabled', False),
                    'value': 60 if phase_id < 7 else 70 if phase_id < 14 else 80
                },
                'AiPlayerbot.RandomBotMaxLevel': {
                    'enabled': True,
                    'value': 60 if phase_id < 7 else 70 if phase_id < 14 else 80
                },
                'AiPlayerbot.RandomGearQualityLimit': {
                    'enabled': True,
                    'value': 5
                },
                'AiPlayerbot.RandomBotGroupNearby': {
                    'enabled': True,
                    'value': 1
                },
                'AiPlayerbot.RandomBotMaps': {
                    'enabled': phase_id < 14,
                    'value': '0,1' if phase_id < 7 else '0,1,530'
                },
                'PlayerbotsDatabaseInfo': {
                    'enabled': True,
                    'value': f'"{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options.get('mysql.database.playerbots', 'acore_playerbots')}"'
                },
                'Playerbots.Updates.EnableDatabases': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.RandomBotTalk': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.RandomBotSuggestDungeons': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.ToxicLinksRepliesChance': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.ThunderfuryRepliesChance': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.GuildRepliesRate': {
                    'enabled': True,
                    'value': 0
                },
                'AIPlayerbot.GuildFeedback': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.EnableBroadcasts': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AddClassCommand': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.AddClassAccountPoolSize': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.BotActiveAlone': {
                    'enabled': True,
                    'value': options.get('module.playerbots.random_bots.active_alone', 100)
                },
                'AiPlayerbot.botActiveAloneSmartScale': {
                    'enabled': not options.get('module.playerbots.random_bots.smart_scale', False),
                    'value': 0
                },
                'AiPlayerbot.CommandServerPort': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.RandomBotArenaTeam2v2Count': {
                    'enabled': True,
                    'value': 0 if phase_id < 8 else 15
                },
                'AiPlayerbot.RandomBotArenaTeam3v3Count': {
                    'enabled': True,
                    'value': 0 if phase_id < 8 else 15
                },
                'AiPlayerbot.RandomBotArenaTeam5v5Count': {
                    'enabled': True,
                    'value': 0 if phase_id < 8 else 25
                },
                'AiPlayerbot.AutoEquipUpgradeLoot': {
                    'enabled': not options.get('module.playerbots.auto_equip_upgrades', True),
                    'value': 0
                },
                'AiPlayerbot.AutoPickReward': {
                    'enabled': not options.get('module.playerbots.auto_select_quest_reward', True),
                    'value': 'no'
                },
                'AiPlayerbot.AutoTrainSpells': {
                    'enabled': True,
                    'value': 'no'
                },
                'AiPlayerbot.DropObsoleteQuests': {
                    'enabled': not options.get('module.playerbots.drop_obsolete_quests', True),
                    'value': 0
                },
                'PlayerbotsDatabase.WorkerThreads': {
                    'enabled': True,
                    'value': 4
                },
                'AiPlayerbot.UseGroundMountAtMinLevel': {
                    'enabled': phase_id < 17,
                    'value': 40 if phase_id < 16 else 30
                },
                'AiPlayerbot.UseFastGroundMountAtMinLevel': {
                    'enabled': phase_id < 17,
                    'value': 60
                },
                'AiPlayerbot.UseFlyMountAtMinLevel': {
                    'enabled': phase_id < 17,
                    'value': 70
                },
                'AiPlayerbot.NonCombatStrategies': {
                    'enabled': True,
                    'value': '"+worldbuff,-food"'
                },
                'AiPlayerbot.PremadeSpecGlyph.1.0': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.1.1': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.1.2': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.1.3': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.1.4': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.1.5': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.2.0': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.2.1': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.2.2': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.2.3': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.2.4': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.2.5': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.3.0': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.3.1': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.3.2': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.3.3': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.3.4': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.3.5': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.4.0': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.4.1': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.4.2': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.4.3': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.4.4': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.4.5': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.5.0': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.5.1': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.5.2': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.5.3': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.5.4': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.5.5': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.0': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.1': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.2': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.3': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.4': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.5': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.6': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.7.0': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.7.1': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.7.2': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.7.3': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.7.4': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.7.5': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.0': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.1': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.2': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.3': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.4': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.5': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.6': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.9.0': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.9.1': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.9.2': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.9.3': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.9.4': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.9.5': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.0': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.1': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.2': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.3': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.4': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.5': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.6': {
                    'enabled': phase_id < 14,
                    'value': '0,0,0,0,0,0'
                }
            }
        },
        'modules/mod_player_bot_level_brackets.conf': {
            'enabled': options.get('build.world', True) and options.get('module.playerbots.enabled', False) and options.get('module.playerbots_level_brackets.enabled', False),
            'options': {
                'BotLevelBrackets.Dynamic.UseDynamicDistribution': {
                    'enabled': options.get('module.playerbots_level_brackets.dynamic_distribution', False),
                    'value': 1
                },
                'BotLevelBrackets.NumRanges': {
                    'enabled': phase_id < 14,
                    'value': 7 if phase_id < 7 else 8
                },
                'BotLevelBrackets.Alliance.Range1.Pct': {
                    'enabled': phase_id < 14,
                    'value': 0
                },
                'BotLevelBrackets.Alliance.Range2.Pct': {
                    'enabled': phase_id < 14,
                    'value': 14 if phase_id < 7 else 12
                },
                'BotLevelBrackets.Alliance.Range3.Pct': {
                    'enabled': phase_id < 14,
                    'value': 14 if phase_id < 7 else 12
                },
                'BotLevelBrackets.Alliance.Range4.Pct': {
                    'enabled': phase_id < 14,
                    'value': 14 if phase_id < 7 else 12
                },
                'BotLevelBrackets.Alliance.Range5.Pct': {
                    'enabled': phase_id < 14,
                    'value': 14 if phase_id < 7 else 12
                },
                'BotLevelBrackets.Alliance.Range6.Pct': {
                    'enabled': phase_id < 14,
                    'value': 14 if phase_id < 7 else 12
                },
                'BotLevelBrackets.Alliance.Range7.Upper': {
                    'enabled': phase_id < 7,
                    'value': 60
                },
                'BotLevelBrackets.Alliance.Range7.Pct': {
                    'enabled': phase_id < 14,
                    'value': 30 if phase_id < 7 else 12
                },
                'BotLevelBrackets.Alliance.Range8.Upper': {
                    'enabled': phase_id >= 7 and phase_id < 14,
                    'value': 70
                },
                'BotLevelBrackets.Alliance.Range8.Pct': {
                    'enabled': phase_id < 14,
                    'value': 0 if phase_id < 7 else 28
                },
                'BotLevelBrackets.Alliance.Range9.Pct': {
                    'enabled': phase_id < 14,
                    'value': 0
                },
                'BotLevelBrackets.Horde.Range1.Pct': {
                    'enabled': phase_id < 14,
                    'value': 0
                },
                'BotLevelBrackets.Horde.Range2.Pct': {
                    'enabled': phase_id < 14,
                    'value': 14 if phase_id < 7 else 12
                },
                'BotLevelBrackets.Horde.Range3.Pct': {
                    'enabled': phase_id < 14,
                    'value': 14 if phase_id < 7 else 12
                },
                'BotLevelBrackets.Horde.Range4.Pct': {
                    'enabled': phase_id < 14,
                    'value': 14 if phase_id < 7 else 12
                },
                'BotLevelBrackets.Horde.Range5.Pct': {
                    'enabled': phase_id < 14,
                    'value': 14 if phase_id < 7 else 12
                },
                'BotLevelBrackets.Horde.Range6.Pct': {
                    'enabled': phase_id < 14,
                    'value': 14 if phase_id < 7 else 12
                },
                'BotLevelBrackets.Horde.Range7.Upper': {
                    'enabled': phase_id < 7,
                    'value': 60
                },
                'BotLevelBrackets.Horde.Range7.Pct': {
                    'enabled': phase_id < 14,
                    'value': 30 if phase_id < 7 else 12
                },
                'BotLevelBrackets.Horde.Range8.Upper': {
                    'enabled': phase_id >= 7 and phase_id < 14,
                    'value': 70
                },
                'BotLevelBrackets.Horde.Range8.Pct': {
                    'enabled': phase_id < 14,
                    'value': 0 if phase_id < 7 else 70
                },
                'BotLevelBrackets.Horde.Range9.Pct': {
                    'enabled': phase_id < 14,
                    'value': 0
                },
            }
        },
        'modules/mod_progression.conf': {
            'enabled': options.get('build.world', True) and options.get('module.progression.enabled', False),
            'options': {
                'Progression.Phase': {
                    'enabled': True,
                    'value': phase_id
                },
                'Progression.IcecrownCitadel.Aura': {
                    'enabled': True,
                    'value': options.get('module.progression.aura', 6)
                }
            }
        },
        'modules/skip_dk_module.conf': {
            'enabled': options.get('build.world', True) and options.get('module.skip_dk_starting_area.enabled', False) and phase_id >= 14,
            'options': {
                'Skip.Deathknight.Starter.Announce.enable': {
                    'enabled': True,
                    'value': 0
                }
            }
        },
        'modules/mod_weekendbonus.conf': {
            'enabled': options.get('build.world', True) and options.get('module.weekendbonus.enabled', False),
            'options': {
            }
        }
    }

    for config_file, config_data in config_values.items():
        if not config_data['enabled']:
            continue

        file_path = os.path.join(cwd, *(['source', 'build', 'bin', 'RelWithDebInfo', 'configs'] if os.name == 'nt' else ['source', 'etc']), config_file)
        dist_file = f'{file_path}.dist'

        try:
            shutil.copy(dist_file, file_path)
        except (FileNotFoundError, PermissionError, OSError) as e:
            ReportError(f'Failed to update {os.path.basename(config_file)}: {type(e).__name__}')

        print(f'{colorama.Fore.YELLOW}Updating {os.path.basename(config_file)}{colorama.Style.RESET_ALL}')

        with open(file_path, 'r+') as f:
            enabled_options = {k: v['value'] for k, v in config_data['options'].items() if v['enabled']}
            lines = f.readlines()
            f.seek(0)
            f.writelines(
                f"{line.split('=')[0].strip()} = {enabled_options[line.split('=')[0].strip()]}\n" 
                if '=' in line and line.split('=')[0].strip() in enabled_options else line 
                for line in lines
            )
            f.truncate()

    print(f'{colorama.Fore.GREEN}Finished updating config files after {FormattedTime(int(time.time() - function_start_time))}...{colorama.Style.RESET_ALL}')

def ResetWorldDatabase():
    if not options.get('build.world'):
        print(f'{colorama.Fore.RED}Skipped because world is not enabled{colorama.Style.RESET_ALL}')
        return

    print(f'{colorama.Fore.GREEN}Dropping database tables...{colorama.Style.RESET_ALL}')
    start_time = time.time()

    db_name = options.get('mysql.database.world', 'acore_world')

    try:
        connect = pymysql.connect(host=mysql_config['hostname'], port=mysql_config['port'], user=mysql_config['username'], password=mysql_config['password'], db=db_name)
    except pymysql.MySQLError:
        ReportError(f'Failed to connect to {db_name}')
        return

    try:
        with connect.cursor() as cursor:
            cursor.execute('SHOW TABLES;')
            tables = [row[0] for row in cursor.fetchall()]

        if not tables:
            print(f"{colorama.Fore.YELLOW}No tables found in {db_name}{colorama.Style.RESET_ALL}")
            return

        with connect.cursor() as cursor:
            for table in reversed(tables):
                print(f'{colorama.Fore.YELLOW}Dropping {table}{colorama.Style.RESET_ALL}')
                cursor.execute(f'DROP TABLE `{table}`;')
        connect.commit()
    except pymysql.MySQLError:
        ReportError('Failed to drop tables')
    finally:
        connect.close()

    print(f'{colorama.Fore.GREEN}Finished dropping database tables after {FormattedTime(int(time.time() - start_time))}...{colorama.Style.RESET_ALL}')

def IsScreenActive(name) -> bool:
    result = subprocess.run(
        ['screen', '-list'],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True
    )
    return name in result.stdout

def StartProcess(name):        
    subprocess.run([f'./{name}'], cwd=f'{cwd}/source/bin', check=True)

def SendShutdown():
    subprocess.run([
        'screen', '-S', f'world-{realm_id}', '-p', '0',
        '-X', 'stuff', 'server shutdown 10^m'
    ], check=True)

def WaitForShutdown():
    for _ in range(30):
        if not IsScreenActive(f'world-{realm_id}'):
            return
        time.sleep(1)

def StartServer():
    if os.name == 'nt':
        return

    print(f'{colorama.Fore.GREEN}Starting the server...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()

    auth_needed = options.get('build.auth', True) and not IsScreenActive('auth')
    world_needed = options.get('build.world', True) and not IsScreenActive(f'world-{realm_id}')

    if auth_needed or world_needed:
        StartProcess('start.sh')

        if options.get('build.auth', True) and IsScreenActive('auth'):
            print(f"{colorama.Fore.YELLOW}To access the authserver screen: screen -r auth{colorama.Style.RESET_ALL}")

        if options.get('build.world', True) and IsScreenActive(f'world-{realm_id}'):
            print(f"{colorama.Fore.YELLOW}To access the worldserver screen: screen -r world-{realm_id}{colorama.Style.RESET_ALL}")
    else:
        print(f"{colorama.Fore.RED}The server is already running{colorama.Style.RESET_ALL}")

    print(f'{colorama.Fore.GREEN}Finished starting the server after {FormattedTime(int(time.time() - start_time))}...{colorama.Style.RESET_ALL}')

def StopServer():
    if os.name == 'nt':
        return

    print(f'{colorama.Fore.GREEN}Stopping the server...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()

    auth_running = options.get('build.auth', True) and IsScreenActive('auth')
    world_running = options.get('build.world', True) and IsScreenActive(f'world-{realm_id}')

    if auth_running or world_running:
        if world_running:
            print(f"{colorama.Fore.YELLOW}Telling the worldserver to shut down...{colorama.Style.RESET_ALL}")
            SendShutdown()
            WaitForShutdown()

        auth_running = options.get('build.auth', True) and IsScreenActive('auth')
        world_running = options.get('build.world', True) and IsScreenActive(f'world-{realm_id}')
        if auth_running or world_running:
            StartProcess('stop.sh')
    else:
        print(f"{colorama.Fore.RED}The server is not running{colorama.Style.RESET_ALL}")

    print(f'{colorama.Fore.GREEN}Finished stopping the server after {FormattedTime(int(time.time() - start_time))}...{colorama.Style.RESET_ALL}')

if len(sys.argv) < 2:
    PrintAvailableArguments()

commands = {
    'install': [StopServer, DownloadSourceCode, GenerateProject, CompileSourceCode, CreateRequiredScripts, CopyRequiredLibraries],
    'setup': [StopServer, DownloadSourceCode, GenerateProject, CompileSourceCode, CreateRequiredScripts, CopyRequiredLibraries],
    'update': [StopServer, DownloadSourceCode, GenerateProject, CompileSourceCode, CreateRequiredScripts, CopyRequiredLibraries],
    'data': [DownloadClientDataFiles],
    'db': [ImportDatabaseFiles],
    'database': [ImportDatabaseFiles],
    'config': [UpdateConfigFiles],
    'conf': [UpdateConfigFiles],
    'cfg': [UpdateConfigFiles],
    'settings': [UpdateConfigFiles],
    'options': [UpdateConfigFiles],
    'dbc': [CopyDBCFiles],
    'reset': [ResetWorldDatabase],
    'start': [StartServer],
    'stop': [StopServer],
    'restart': [StopServer, StartServer],
    'all': [StopServer, DownloadSourceCode, GenerateProject, CompileSourceCode, CreateRequiredScripts, CopyRequiredLibraries, DownloadClientDataFiles, CopyDBCFiles, ImportDatabaseFiles, UpdateConfigFiles, StartServer]
}

argument = sys.argv[1].lower()
start_time = time.time()
cwd = os.getcwd()
mysql_cnf = os.path.join(cwd, 'mysql.cnf')
if os.name == 'nt':
    colorama.just_fix_windows_console()
os.system('cls' if os.name == 'nt' else 'clear')

LoadOptionsFromDatabase()

if not (options.get('build.auth', True) or options.get('build.world', True)):
    print(f'{colorama.Fore.RED}Stopping due to both auth and world being disabled{colorama.Style.RESET_ALL}')
    sys.exit(1)

CreateBaseFolders()

funcs = commands.get(argument)
if funcs:
    for func in funcs:
        func()
else:
    PrintAvailableArguments()

print(f'{colorama.Fore.GREEN}The script finished after {FormattedTime(int(time.time() - start_time))}...{colorama.Style.RESET_ALL}')
