# Linux: apt install -y git screen cmake make gcc clang g++ libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost1.83-all-dev libmysqlclient-dev mysql-client python3-git python3-requests python3-tqdm python3-pymysql python3-colorama
# wget https://repo.mysql.com/mysql-apt-config_0.8.34-1_all.deb
# dpkg -i mysql-apt-config_0.8.34-1_all.deb
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
use_custom_talent_trees = False

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
        'ah_bot': {
            'enabled': False,
            'buyer': {
                'enabled': False
            },
            'character_guids': 0,
            'seller': {
                'enabled': False
            }
        },
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
            'aura': 4,
            'enabled': False,
            'multiplier': {
                'damage': 0.6,
                'healing': 0.5
            },
            'patch': 21,
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
    'msbuild': 'C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/MSBuild/Current/Bin',
    'mysql': 'C:/Program Files/MySQL/MySQL Server 8.4',
    'openssl': 'C:/Program Files/OpenSSL-Win64',
    'cmake': 'C:/Program Files/CMake'
}

def ReportError(message):
    if options.get('telegram.chat_id', 0) and options.get('telegram.token', 0):
        try:
            requests.get(
                f'https://api.telegram.org/bot{options['telegram.token']}/sendMessage'
                f'?chat_id={options['telegram.chat_id']}&text=[{options['world.name']} (id: {realm_id})]: {message}'
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
        (options['build.world'], 'dbc'),
        (True, 'logs'),
        (True, 'sql/auth'),
        (options['build.world'], 'sql/characters'),
        (options['build.world'], 'sql/world')
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
    url = f'{'git@github.com:' if options['git.use_ssh'] else 'https://github.com/'}{repo}'
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

    DownloadOrUpdateSourceCode(options['git.repository'], os.path.join(cwd, 'source'), options['git.branch'], 'azerothcore')

    if options['build.world']:
        modules = [
            ('mod-ah-bot', 'NathanHandley/mod-ah-bot', 'master', options['module.ah_bot.enabled']),
            ('mod-assistant', 'noisiver/mod-assistant', 'master', options['module.assistant.enabled']),
            ('mod-dungeoneer', 'noisiver/mod-dungeoneer', 'master', options['module.dungeoneer.enabled']),
            ('mod-fixes', 'noisiver/mod-fixes', 'master', options['module.fixes.enabled']),
            ('mod-gamemaster', 'noisiver/mod-gamemaster', 'master', options['module.gamemaster.enabled']),
            ('mod-junk-to-gold', 'noisiver/mod-junk-to-gold', 'master', options['module.junktogold.enabled']),
            ('mod-learnspells', 'noisiver/mod-learnspells', 'master', options['module.learnspells.enabled']),
            ('mod-playerbots', 'noisiver/mod-playerbots', 'noisiver', options['module.playerbots.enabled']),
            ('mod-player-bot-level-brackets', 'DustinHendrickson/mod-player-bot-level-brackets', 'main', options['module.playerbots.enabled'] and options['module.playerbots_level_brackets.enabled']),
            ('mod-progression', 'noisiver/mod-progression', 'master', options['module.progression.enabled']),
            ('mod-skip-dk-starting-area', 'azerothcore/mod-skip-dk-starting-area', 'master', options['module.skip_dk_starting_area.enabled'] and int(options['module.progression.patch']) >= 17),
            ('mod-stop-killing-them', 'noisiver/mod-stop-killing-them', 'master', options['module.stop_killing_them.enabled'] and int(options['module.progression.patch']) >= 12),
            ('mod-weekendbonus', 'noisiver/mod-weekendbonus', 'master', options['module.weekendbonus.enabled'])
        ]

        [DownloadOrUpdateSourceCode(repo, os.path.join(cwd, 'source/modules', name), branch, name)
         for name, repo, branch, enabled in modules if enabled]

    print(f'{colorama.Fore.GREEN}Finished downloading source code after {FormattedTime(int(time.time() - function_start_time))}...{colorama.Style.RESET_ALL}')

def GenerateProject():
    print(f'{colorama.Fore.GREEN}Generating project files...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()

    apps = 'all' if options['build.auth'] and options['build.world'] else 'auth-only' if options['build.auth'] else 'world-only'
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
        target = ('authserver' if options['build.auth'] and not options['build.world'] else
                  'worldserver' if not options['build.auth'] and options['build.world'] else
                  'ALL_BUILD')
        build_cmd, build_args, clean_args = f'{windows_paths['msbuild']}/MSBuild.exe', [f'{cwd}/source/build/AzerothCore.sln', '/p:Configuration=RelWithDebInfo', '/p:WarningLevel=0', f'/target:{target}'], [f'{cwd}/source/build/AzerothCore.sln', '/t:Clean']
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
        [f'auth.{'bat' if os.name == 'nt' else 'sh'}', options['build.auth'],
         cwd if os.name == 'nt' else f'{cwd}/source/bin',
         '@echo off\ncd source/build/bin/RelWithDebInfo\n:auth\n    authserver.exe\ngoto auth\n' if os.name == 'nt' else
         '#!/bin/bash\nwhile :; do\n    ./authserver\n    sleep 5\ndone\n'],
        [f'world.{'bat' if os.name == 'nt' else 'sh'}', options['build.world'],
         cwd if os.name == 'nt' else f'{cwd}/source/bin',
         '@echo off\ncd source/build/bin/RelWithDebInfo\n:world\n    worldserver.exe\n    timeout 5\ngoto world\n' if os.name == 'nt' else
         '#!/bin/bash\nwhile :; do\n    ./worldserver\n    [[ $? == 0 ]] && break\n    sleep 5\ndone\n'],
        ['start.sh', os.name != 'nt', f'{cwd}/source/bin',
         f'#!/bin/bash\n{'screen -AmdS auth ./auth.sh\n' if options['build.auth'] else ''}'
         f'{f'time=$(date +%s)\nscreen -L -Logfile $time.log -AmdS world-{realm_id} ./world.sh\n' if options['build.world'] else ''}'],
        ['stop.sh', os.name != 'nt', f'{cwd}/source/bin',
         f'#!/bin/bash\n{'screen -X -S auth quit\n' if options['build.auth'] else ''}'
         f'{f'screen -X -S world-{realm_id} quit\n' if options['build.world'] else ''}']
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
    data_dir = options['world.data.directory']
    binary_path = f'{cwd}/source/bin/RelWithDebInfo' if os.name == 'nt' else f'{cwd}/source/bin'
    return binary_path if data_dir == '.' else f'{binary_path}/{data_dir[2:]}' if data_dir.startswith('./') else data_dir

def DownloadClientDataFiles():
    if not options['build.world']:
        if sys.argv[1].lower() == 'data':
            print(f'{colorama.Fore.RED}Skipped because world is not enabled{colorama.Style.RESET_ALL}')
        return

    if not options['world.data.use_pre_extracted_files']:
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
    if not options['build.world']:
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
        options['mysql.database.characters']: [
            [options['build.world'], f'{cwd}/source/data/sql/base/db_characters', None],
            [options['build.world'], f'{cwd}/source/data/sql/updates/db_characters', 'RELEASED'],
            [options['build.world'], f'{cwd}/source/data/sql/custom/db_characters', 'CUSTOM'],
            [options['build.world'] and options['module.playerbots.enabled'], f'{cwd}/source/modules/mod-playerbots/data/sql/characters/base', None],
            [options['build.world'] and options['module.playerbots.enabled'], f'{cwd}/source/modules/mod-playerbots/data/sql/characters/updates', 'RELEASED'],
            [options['build.world'], f'{cwd}/sql/characters', None]
        ],
        options['mysql.database.playerbots']: [
            [options['build.world'] and options['module.playerbots.enabled'], f'{cwd}/source/modules/mod-playerbots/data/sql/playerbots/base', None],
            [options['build.world'] and options['module.playerbots.enabled'], f'{cwd}/source/modules/mod-playerbots/data/sql/playerbots/updates', 'RELEASED'],
            [options['build.world'] and options['module.playerbots.enabled'], f'{cwd}/source/modules/mod-playerbots/data/sql/playerbots/custom', 'CUSTOM']
        ],
        options['mysql.database.world']: [
            [options['build.world'], f'{cwd}/source/data/sql/base/db_world', None],
            [options['build.world'], f'{cwd}/source/data/sql/updates/db_world', 'RELEASED'],
            [options['build.world'], f'{cwd}/source/data/sql/custom/db_world', 'CUSTOM'],
            [options['build.world'] and options['module.assistant.enabled'], f'{cwd}/source/modules/mod-assistant/data/sql/world', 'MODULE'],
            [options['build.world'] and options['module.fixes.enabled'], f'{cwd}/source/modules/mod-fixes/data/sql/world', 'MODULE'],
            [options['build.world'] and options['module.learnspells.enabled'], f'{cwd}/source/modules/mod-learnspells/data/sql/world', 'MODULE'],
            [options['build.world'] and options['module.playerbots.enabled'], f'{cwd}/source/modules/mod-playerbots/data/sql/world/base', 'MODULE'],
            [options['build.world'] and options['module.playerbots.enabled'], f'{cwd}/source/modules/mod-playerbots/data/sql/world/updates', 'RELEASED'],
            [options['build.world'] and options['module.progression.enabled'], f'{cwd}/source/modules/mod-progression/src/patch_00-1_1/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 1, f'{cwd}/source/modules/mod-progression/src/patch_01-1_2/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 2, f'{cwd}/source/modules/mod-progression/src/patch_02-1_3/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 3, f'{cwd}/source/modules/mod-progression/src/patch_03-1_4/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 4, f'{cwd}/source/modules/mod-progression/src/patch_04-1_5/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 5, f'{cwd}/source/modules/mod-progression/src/patch_05-1_6/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 6, f'{cwd}/source/modules/mod-progression/src/patch_06-1_7/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 7, f'{cwd}/source/modules/mod-progression/src/patch_07-1_8/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 8, f'{cwd}/source/modules/mod-progression/src/patch_08-1_9/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 9, f'{cwd}/source/modules/mod-progression/src/patch_09-1_10/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 10, f'{cwd}/source/modules/mod-progression/src/patch_10-1_11/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 11, f'{cwd}/source/modules/mod-progression/src/patch_11-1_12/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 12, f'{cwd}/source/modules/mod-progression/src/patch_12-2_0/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 13, f'{cwd}/source/modules/mod-progression/src/patch_13-2_1/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 14, f'{cwd}/source/modules/mod-progression/src/patch_14-2_2/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 15, f'{cwd}/source/modules/mod-progression/src/patch_15-2_3/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 16, f'{cwd}/source/modules/mod-progression/src/patch_16-2_4/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 17, f'{cwd}/source/modules/mod-progression/src/patch_17-3_0/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 18, f'{cwd}/source/modules/mod-progression/src/patch_18-3_1/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 19, f'{cwd}/source/modules/mod-progression/src/patch_19-3_2/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 20, f'{cwd}/source/modules/mod-progression/src/patch_20-3_3/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.progression.enabled'] and int(options['module.progression.patch']) >= 21, f'{cwd}/source/modules/mod-progression/src/patch_21-3_3_5/sql', None if options['module.progression.reset'] else 'MODULE'],
            [options['build.world'] and options['module.skip_dk_starting_area.enabled'] and int(options['module.progression.patch']) >= 17, f'{cwd}/source/modules/mod-skip-dk-starting-area/data/sql/db-world', 'MODULE'],
            [options['build.world'], f'{cwd}/sql/world', None]
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

    if options['build.world']:
        print(f'{colorama.Fore.MAGENTA}Updating realmlist and message of the day...{colorama.Style.RESET_ALL}')
        section_start = time.time()
        try:
            with pymysql.connect(host=mysql_config['hostname'], port=mysql_config['port'], user=mysql_config['username'], password=mysql_config['password'], db=mysql_config['database']) as connect:
                with connect.cursor() as cursor:
                    print(f'{colorama.Fore.YELLOW}Updating realmlist{colorama.Style.RESET_ALL}')
                    cursor.execute(f'DELETE FROM `realmlist` WHERE `id` = %s;', (realm_id,))
                    cursor.execute('INSERT INTO `realmlist` (`id`, `name`, `address`, `localAddress`, `port`) VALUES (%s, %s, %s, %s, %s);',
                                   (realm_id, options['world.name'], options['world.address'], options['world.local_address'], realm_port))

                    print(f'{colorama.Fore.YELLOW}Updating message of the day{colorama.Style.RESET_ALL}')
                    cursor.execute(f'DELETE FROM `motd` WHERE `realmid` = %s;', (realm_id,))
                    cursor.execute('INSERT INTO `motd` (`realmid`, `text`) VALUES (%s, %s);', (realm_id, f'Welcome to {options['world.name']}'))

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

    map_update_threads = int(options['world.map_update_threads'])
    patch_id = int(options['module.progression.patch'])
    random_bots_maximum = int(options['module.playerbots.random_bots.maximum'])
    mysql_hostname = mysql_config['hostname']
    mysql_port = mysql_config['port']
    mysql_username = mysql_config['username']
    mysql_password = mysql_config['password']
    mysql_database_auth = mysql_config['database']

    config_values = {
        'authserver.conf': {
            'enabled': options['build.auth'],
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
            'enabled': options['build.world'],
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
                    'value': f'"{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options['mysql.database.world']}"'
                },
                'CharacterDatabaseInfo': {
                    'enabled': True,
                    'value': f'"{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options['mysql.database.characters']}"'
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
                    'value': options['world.game_type']
                },
                'RealmZone': {
                    'enabled': True,
                    'value': options['world.realm_zone']
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
                    'enabled': options['world.preload_grids'],
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
                    'enabled': options['world.infinite_ammo'],
                    'value': 1
                },
                'Warden.Enabled': {
                    'enabled': not options['world.warden'],
                    'value': 0
                }
            }
        },
        'modules/mod_ahbot.conf': {
            'enabled': options['build.world'] and options['module.ah_bot.enabled'],
            'options': {
                'AuctionHouseBot.EnableSeller': {
                    'enabled': options['module.ah_bot.seller.enabled'],
                    'value': 1
                },
                'AuctionHouseBot.EnableBuyer': {
                    'enabled': options['module.ah_bot.buyer.enabled'],
                    'value': 1
                },
                'AuctionHouseBot.GUIDs': {
                    'enabled': True,
                    'value': options['module.ah_bot.character_guids']
                },
                'AuctionHouseBot.ItemsPerCycle': {
                    'enabled': True,
                    'value': 250
                },
                'AuctionHouseBot.ListedItemLevelRestrict.Enabled': {
                    'enabled': patch_id < 21,
                    'value': 'true'
                },
                'AuctionHouseBot.ListedItemLevelRestrict.MaxItemLevel': {
                    'enabled': patch_id < 21,
                    'value': 63 if patch_id < 6 else 66 if patch_id < 7 else 76 if patch_id < 12 else 110 if patch_id < 13 else 120 if patch_id < 14 else 133 if patch_id < 17 else 200 if patch_id < 18 else 213 if patch_id < 19 else 226 if patch_id < 20 else 245
                },
                'AuctionHouseBot.Alliance.MinItems': {
                    'enabled': True,
                    'value': 15000
                },
                'AuctionHouseBot.Alliance.MaxItems': {
                    'enabled': True,
                    'value': 25000
                },
                'AuctionHouseBot.Horde.MinItems': {
                    'enabled': True,
                    'value': 25000
                },
                'AuctionHouseBot.Horde.MaxItems': {
                    'enabled': True,
                    'value': 25000
                },
                'AuctionHouseBot.Neutral.MinItems': {
                    'enabled': True,
                    'value': 25000
                },
                'AuctionHouseBot.Neutral.MaxItems': {
                    'enabled': True,
                    'value': 25000
                },
            }
        },
        'modules/mod_assistant.conf': {
            'enabled': options['build.world'] and options['module.assistant.enabled'],
            'options': {
                'Assistant.Heirlooms.Enabled': {
                    'enabled': patch_id < 17,
                    'value': 0
                },
                'Assistant.Glyphs.Enabled': {
                    'enabled': patch_id < 17,
                    'value': 0
                },
                'Assistant.Gems.Enabled': {
                    'enabled': patch_id < 17,
                    'value': 0
                },
                'Assistant.Elixirs.Enabled': {
                    'enabled': patch_id < 17,
                    'value': 0
                },
                'Assistant.Food.Enabled': {
                    'enabled': patch_id < 17,
                    'value': 0
                },
                'Assistant.Enchants.Enabled': {
                    'enabled': patch_id < 17,
                    'value': 0
                },
                'Assistant.FlightPaths.Vanilla.Enabled': {
                    'enabled': patch_id < 12,
                    'value': 0
                },
                'Assistant.FlightPaths.BurningCrusade.Enabled': {
                    'enabled': patch_id < 17,
                    'value': 0
                },
                'Assistant.Professions.Apprentice.Cost': {
                    'enabled': True,
                    'value': 100000 if patch_id < 17 else 1000000
                },
                'Assistant.Professions.Journeyman.Cost': {
                    'enabled': True,
                    'value': 250000 if patch_id < 17 else 2500000
                },
                'Assistant.Professions.Expert.Cost': {
                    'enabled': True,
                    'value': 500000 if patch_id < 17 else 5000000
                },
                'Assistant.Professions.Artisan.Cost': {
                    'enabled': True,
                    'value': 750000 if patch_id < 17 else 7500000
                },
                'Assistant.Professions.Master.Enabled': {
                    'enabled': patch_id >= 12,
                    'value': 1
                },
                'Assistant.Professions.Master.Cost': {
                    'enabled': True,
                    'value': 1250000 if patch_id < 17 else 12500000
                },
                'Assistant.Professions.GrandMaster.Enabled': {
                    'enabled': patch_id >= 17,
                    'value': 1
                },
                'Assistant.Instances.Heroic.Enabled': {
                    'enabled': patch_id < 12,
                    'value': 0
                }
            }
        },
        'modules/mod_learnspells.conf': {
            'enabled': options['build.world'] and options['module.learnspells.enabled'],
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
            'enabled': options['build.world'] and options['module.playerbots.enabled'],
            'options': {
                'AiPlayerbot.MinRandomBots': {
                    'enabled': True,
                    'value': options['module.playerbots.random_bots.minimum']
                },
                'AiPlayerbot.MaxRandomBots': {
                    'enabled': True,
                    'value': random_bots_maximum
                },
                'AiPlayerbot.RandomBotAccountCount': {
                    'enabled': random_bots_maximum > 0,
                    'value': int(random_bots_maximum / (9 if patch_id < 17 else 10) + 1)
                },
                'AiPlayerbot.DisabledWithoutRealPlayer': {
                    'enabled': options['module.playerbots.random_bots.only_with_players'],
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
                'AiPlayerbot.AltMaintenanceGemsEnchants': {
                    'enabled': patch_id >= 17,
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
                    'enabled': patch_id < 17,
                    'value': 1
                },
                'AiPlayerbot.DisableRandomLevels': {
                    'enabled': not options['module.playerbots_level_brackets.enabled'],
                    'value': 1
                },
                'AiPlayerbot.RandombotStartingLevel': {
                    'enabled': not options['module.playerbots_level_brackets.enabled'],
                    'value': 59 if patch_id < 12 else 69 if patch_id < 17 else 79
                },
                'AiPlayerbot.RandomBotMaxLevel': {
                    'enabled': True,
                    'value': 60 if patch_id < 12 else 70 if patch_id < 17 else 80
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
                    'enabled': patch_id < 17,
                    'value': '0,1' if patch_id < 12 else '0,1,530'
                },
                'PlayerbotsDatabaseInfo': {
                    'enabled': True,
                    'value': f'"{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{options['mysql.database.playerbots']}"'
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
                    'value': options['module.playerbots.random_bots.active_alone']
                },
                'AiPlayerbot.botActiveAloneSmartScale': {
                    'enabled': not options['module.playerbots.random_bots.smart_scale'],
                    'value': 0
                },
                'AiPlayerbot.CommandServerPort': {
                    'enabled': True,
                    'value': 0
                },
                'AiPlayerbot.RandomBotArenaTeam2v2Count': {
                    'enabled': True,
                    'value': 0 if patch_id < 12 else 15
                },
                'AiPlayerbot.RandomBotArenaTeam3v3Count': {
                    'enabled': True,
                    'value': 0 if patch_id < 12 else 15
                },
                'AiPlayerbot.RandomBotArenaTeam5v5Count': {
                    'enabled': True,
                    'value': 0 if patch_id < 12 else 25
                },
                'AiPlayerbot.AutoEquipUpgradeLoot': {
                    'enabled': not options['module.playerbots.auto_equip_upgrades'],
                    'value': 0
                },
                'AiPlayerbot.AutoPickReward': {
                    'enabled': not options['module.playerbots.auto_select_quest_reward'],
                    'value': 'no'
                },
                'AiPlayerbot.AutoTrainSpells': {
                    'enabled': True,
                    'value': 'no'
                },
                'AiPlayerbot.DropObsoleteQuests': {
                    'enabled': not options['module.playerbots.drop_obsolete_quests'],
                    'value': 0
                },
                'PlayerbotsDatabase.WorkerThreads': {
                    'enabled': True,
                    'value': 4
                },
                'AiPlayerbot.UseGroundMountAtMinLevel': {
                    'enabled': patch_id < 19,
                    'value': 40 if patch_id < 16 else 30
                },
                'AiPlayerbot.UseFastGroundMountAtMinLevel': {
                    'enabled': patch_id < 19,
                    'value': 60
                },
                'AiPlayerbot.UseFlyMountAtMinLevel': {
                    'enabled': patch_id < 19,
                    'value': 70
                },
                'AiPlayerbot.NonCombatStrategies': {
                    'enabled': True,
                    'value': '"+worldbuff,-food"'
                },
                'AiPlayerbot.PremadeSpecGlyph.1.0': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.1.0.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '30220321233351000021-30505300002' if patch_id < 12 else '302203212333510020201231-30502'
                },
                'AiPlayerbot.PremadeSpecLink.1.0.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '30220321233351000021-30505300002' if patch_id < 12 else '302203212333510020201231-3050530004'
                },
                'AiPlayerbot.PremadeSpecGlyph.1.1': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.1.1.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '30202301233-325000005502310051' if patch_id < 12 else '302013-3250000055013100531251'
                },
                'AiPlayerbot.PremadeSpecLink.1.1.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '30202301233-325000005502310051' if patch_id < 12 else '30202301233-3250000055013100531251'
                },
                'AiPlayerbot.PremadeSpecGlyph.1.2': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.1.2.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '352000001-3-05335122500021251' if patch_id < 12 else '35--053351225000212521031'
                },
                'AiPlayerbot.PremadeSpecLink.1.2.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '352000001-3-05335122500021251' if patch_id < 12 else '3502000023-3-053351225000212521031'
                },
                'AiPlayerbot.PremadeSpecGlyph.1.3': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.1.3.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '30220321233351000021-30505300002' if patch_id < 12 else '302203212333510020201231-30502'
                },
                'AiPlayerbot.PremadeSpecLink.1.3.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '30220321233351000021-30505300002' if patch_id < 12 else '302203212333510020201231-3050530004'
                },
                'AiPlayerbot.PremadeSpecGlyph.1.4': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.1.4.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '30202301233-325000005502310051' if patch_id < 12 else '302013-3250000055013100531251'
                },
                'AiPlayerbot.PremadeSpecLink.1.4.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '30202301233-325000005502310051' if patch_id < 12 else '30202301233-3250000055013100531251'
                },
                'AiPlayerbot.PremadeSpecGlyph.1.5': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.1.5.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '352000001-3-05335122500021251' if patch_id < 12 else '35--053351225000212521031'
                },
                'AiPlayerbot.PremadeSpecLink.1.5.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '352000001-3-05335122500021251' if patch_id < 12 else '3502000023-3-053351225000212521031'
                },
                'AiPlayerbot.PremadeSpecGlyph.2.0': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.2.0.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '50350152020013251-5002-05202' if patch_id < 12 else '503500520020130531051-50023'
                },
                'AiPlayerbot.PremadeSpecLink.2.0.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '50350152020013251-5002-05202' if patch_id < 12 else '503500520020130531051-500251022-03'
                },
                'AiPlayerbot.PremadeSpecGlyph.2.1': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.2.1.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-0500513520310231-502302500003' if patch_id < 12 else '-25005135203102321331-5022'
                },
                'AiPlayerbot.PremadeSpecLink.2.1.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-0500513520310231-502302500003' if patch_id < 12 else '-25005135203102321331-502300510003'
                },
                'AiPlayerbot.PremadeSpecGlyph.2.2': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.2.2.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-453201002-05232051203331301' if patch_id < 12 else '-45-052220512033313021331'
                },
                'AiPlayerbot.PremadeSpecLink.2.2.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-453201002-05232051203331301' if patch_id < 12 else '-553201002-052320512033313021331'
                },
                'AiPlayerbot.PremadeSpecGlyph.2.3': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.2.3.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '50350152020013251-5002-05202' if patch_id < 12 else '503500520020130531051-50023'
                },
                'AiPlayerbot.PremadeSpecLink.2.3.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '50350152020013251-5002-05202' if patch_id < 12 else '503500520020130531051-500251022-03'
                },
                'AiPlayerbot.PremadeSpecGlyph.2.4': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.2.4.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-0500513520310231-502302500003' if patch_id < 12 else '-25005135203102321331-5022'
                },
                'AiPlayerbot.PremadeSpecLink.2.4.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-0500513520310231-502302500003' if patch_id < 12 else '-25005135203102321331-502300510003'
                },
                'AiPlayerbot.PremadeSpecGlyph.2.5': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.2.5.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-453201002-05232051203331301' if patch_id < 12 else '-45-052220512033313021331'
                },
                'AiPlayerbot.PremadeSpecLink.2.5.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-453201002-05232051203331301' if patch_id < 12 else '-553201002-052320512033313021331'
                },
                'AiPlayerbot.PremadeSpecGlyph.3.0': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.3.0.40': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '5120020151501224' if patch_id < 12 else '51200201515012231'
                },
                'AiPlayerbot.PremadeSpecLink.3.0.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '51200201515012241-005305001-5' if patch_id < 12 else '512002015150122331151-005302'
                },
                'AiPlayerbot.PremadeSpecLink.3.0.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '51200201515012241-005305001-5' if patch_id < 12 else '512002015150122331151-005304-500003'
                },
                'AiPlayerbot.PremadeSpecGlyph.3.1': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.3.1.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '502-035305231230013231-5000002' if patch_id < 12 else '502-0353050012300132331351'
                },
                'AiPlayerbot.PremadeSpecLink.3.1.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '502-035305231230013231-5000002' if patch_id < 12 else '502-0353050012300132331351-5300002'
                },
                'AiPlayerbot.PremadeSpecGlyph.3.2': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.3.2.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-005305101-5000032500033330531' if patch_id < 12 else '-0052-50000325000333305311151'
                },
                'AiPlayerbot.PremadeSpecLink.3.2.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-005305101-5000032500033330531' if patch_id < 12 else '-00530511102-50000325000333305311151'
                },
                'AiPlayerbot.PremadeSpecGlyph.3.3': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.3.3.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '51200201515012241-005305001-5' if patch_id < 12 else '512002015150122331151-005302'
                },
                'AiPlayerbot.PremadeSpecLink.3.3.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '51200201515012241-005305001-5' if patch_id < 12 else '512002015150122331151-005304-500003'
                },
                'AiPlayerbot.PremadeSpecGlyph.3.4': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.3.4.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '502-035305231230013231-5000002' if patch_id < 12 else '502-0353050012300132331351'
                },
                'AiPlayerbot.PremadeSpecLink.3.4.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '502-035305231230013231-5000002' if patch_id < 12 else '502-0353050012300132331351-5300002'
                },
                'AiPlayerbot.PremadeSpecGlyph.3.5': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.3.5.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-005305101-5000032500033330531' if patch_id < 12 else '-0052-50000325000333305311151'
                },
                'AiPlayerbot.PremadeSpecLink.3.5.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-005305101-5000032500033330531' if patch_id < 12 else '-00530511102-50000325000333305311151'
                },
                'AiPlayerbot.PremadeSpecGlyph.4.0': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.4.0.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '005303005350102501-005005001-502' if patch_id < 12 else '005303105350102521131-005005'
                },
                'AiPlayerbot.PremadeSpecLink.4.0.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '005303005350102501-005005001-502' if patch_id < 12 else '005303105350102521131-005005003-502'
                },
                'AiPlayerbot.PremadeSpecGlyph.4.1': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.4.1.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '00532000531-0252051000035015201' if patch_id < 12 else '0053-02520510000350152231051'
                },
                'AiPlayerbot.PremadeSpecLink.4.1.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '00532000531-0252051000035015201' if patch_id < 12 else '0053200053-02520510000350152231051'
                },
                'AiPlayerbot.PremadeSpecGlyph.4.2': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.4.2.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '3053031-3-5320232030300121051' if patch_id < 12 else '302-3-51202320303001213501351'
                },
                'AiPlayerbot.PremadeSpecLink.4.2.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '3053031-3-5320232030300121051' if patch_id < 12 else '3053031-3-51202320303001213501351'
                },
                'AiPlayerbot.PremadeSpecGlyph.4.3': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.4.3.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '005303005350102501-005005001-502' if patch_id < 12 else '005303105350102521131-005005'
                },
                'AiPlayerbot.PremadeSpecLink.4.3.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '005303005350102501-005005001-502' if patch_id < 12 else '005303105350102521131-005005003-502'
                },
                'AiPlayerbot.PremadeSpecGlyph.4.4': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.4.4.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '00532000531-0252051000035015201' if patch_id < 12 else '0053-02520510000350152231051'
                },
                'AiPlayerbot.PremadeSpecLink.4.4.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '00532000531-0252051000035015201' if patch_id < 12 else '0053200053-02520510000350152231051'
                },
                'AiPlayerbot.PremadeSpecGlyph.4.5': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.4.5.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '3053031-3-5320232030300121051' if patch_id < 12 else '302-3-51202320303001213501351'
                },
                'AiPlayerbot.PremadeSpecLink.4.5.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '3053031-3-5320232030300121051' if patch_id < 12 else '3053031-3-51202320303001213501351'
                },
                'AiPlayerbot.PremadeSpecGlyph.5.0': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.5.0.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '050320313030051231-2055100303' if patch_id < 12 else '0503203130302512301331-2053'
                },
                'AiPlayerbot.PremadeSpecLink.5.0.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '050320313030051231-2055100303' if patch_id < 12 else '0523203130302512301331-2055000303'
                },
                'AiPlayerbot.PremadeSpecGlyph.5.1': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.5.1.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '0503203-23505103030215251' if patch_id < 12 else '05-235051030302152530051'
                },
                'AiPlayerbot.PremadeSpecLink.5.1.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '0503203-23505103030215251' if patch_id < 12 else '050320302-235051030302152530051'
                },
                'AiPlayerbot.PremadeSpecGlyph.5.2': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.5.2.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '05032031--3250230512230102231' if patch_id < 12 else '04--3250230512230103231531'
                },
                'AiPlayerbot.PremadeSpecLink.5.2.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '05032031--3250230512230102231' if patch_id < 12 else '050032031--3250230512230103231531'
                },
                'AiPlayerbot.PremadeSpecGlyph.5.3': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.5.3.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '050320313030051231-2055100303' if patch_id < 12 else '0503203130302512301331-2053'
                },
                'AiPlayerbot.PremadeSpecLink.5.3.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '050320313030051231-2055100303' if patch_id < 12 else '0523203130302512301331-2055000303'
                },
                'AiPlayerbot.PremadeSpecGlyph.5.4': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.5.4.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '0503203-23505103030215251' if patch_id < 12 else '05-235051030302152530051'
                },
                'AiPlayerbot.PremadeSpecLink.5.4.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '0503203-23505103030215251' if patch_id < 12 else '050320302-235051030302152530051'
                },
                'AiPlayerbot.PremadeSpecGlyph.5.5': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.5.5.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '05032031--3250230512230102231' if patch_id < 12 else '04--3250230512230103231531'
                },
                'AiPlayerbot.PremadeSpecLink.5.5.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '05032031--3250230512230102231' if patch_id < 12 else '050032031--3250230512230103231531'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.0': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.1': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.2': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.3': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.4': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.5': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.6.6': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecGlyph.7.0': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.7.0.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '3530001523213351-005050031' if patch_id < 12 else '2530001523213351331-00503'
                },
                'AiPlayerbot.PremadeSpecLink.7.0.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '3530001523213351-005050031' if patch_id < 12 else '5530011523213351331-0050531'
                },
                'AiPlayerbot.PremadeSpecGlyph.7.1': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.7.1.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '053030051-3020503300502133301' if patch_id < 12 else '05302-30305033005021333031111'
                },
                'AiPlayerbot.PremadeSpecLink.7.1.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '053030051-3020503300502133301' if patch_id < 12 else '053030052-30505033005021333031111'
                },
                'AiPlayerbot.PremadeSpecGlyph.7.2': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.7.2.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-0050503-0500533133531051' if patch_id < 12 else '-0050103-05035331335010510301'
                },
                'AiPlayerbot.PremadeSpecLink.7.2.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-0050503-0500533133531051' if patch_id < 12 else '-0050523-05235331335010510321'
                },
                'AiPlayerbot.PremadeSpecGlyph.7.3': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.7.3.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '3530001523213351-005050031' if patch_id < 12 else '2530001523213351331-00503'
                },
                'AiPlayerbot.PremadeSpecLink.7.3.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '3530001523213351-005050031' if patch_id < 12 else '5530011523213351331-0050531'
                },
                'AiPlayerbot.PremadeSpecGlyph.7.4': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.7.4.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '053030051-3020503300502133301' if patch_id < 12 else '05302-30305033005021333031111'
                },
                'AiPlayerbot.PremadeSpecLink.7.4.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '053030051-3020503300502133301' if patch_id < 12 else '053030052-30505033005021333031111'
                },
                'AiPlayerbot.PremadeSpecGlyph.7.5': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.7.5.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-0050503-0500533133531051' if patch_id < 12 else '-0050103-05035331335010510301'
                },
                'AiPlayerbot.PremadeSpecLink.7.5.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-0050503-0500533133531051' if patch_id < 12 else '0050523-05235331335010510321'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.0': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.8.0.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '235005030100330150321-03-023023001' if patch_id < 12 else '233005030100030150323125-03-023001'
                },
                'AiPlayerbot.PremadeSpecLink.8.0.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '235005030100330150321-03-023023001' if patch_id < 12 else '235005030100330150323125-03-023023001'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.1': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.8.1.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '2300230311-0055032012303330051' if patch_id < 12 else '23002-0055032012303330053123'
                },
                'AiPlayerbot.PremadeSpecLink.8.1.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '2300230311-0055032012303330051' if patch_id < 12 else '2300230331-0055032012303330053123'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.2': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.8.2.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '23000503310003--0533030310233100031' if patch_id < 12 else '230005--05330303102331000321521'
                },
                'AiPlayerbot.PremadeSpecLink.8.2.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '23000503310003--0533030310233100031' if patch_id < 12 else '23000503310003--05330303102331000321521'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.3': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.8.3.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '2300230311-0055032012303330051' if patch_id < 12 else '-2305030012303331053123-023003'
                },
                'AiPlayerbot.PremadeSpecLink.8.3.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '2300230311-0055032012303330051' if patch_id < 12 else '-2305030012303331053123-033323031'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.4': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.8.4.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '235005030100330150321-03-023023001' if patch_id < 12 else '233005030100030150323125-03-023001'
                },
                'AiPlayerbot.PremadeSpecLink.8.4.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '235005030100330150321-03-023023001' if patch_id < 12 else '235005030100330150323125-03-023023001'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.5': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.8.5.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '2300230311-0055032012303330051' if patch_id < 12 else '23002-0055032012303330053123'
                },
                'AiPlayerbot.PremadeSpecLink.8.5.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '2300230311-0055032012303330051' if patch_id < 12 else '2300230331-0055032012303330053123'
                },
                'AiPlayerbot.PremadeSpecGlyph.8.6': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.8.6.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '23000503310003--0533030310233100031' if patch_id < 12 else '230005--05330303102331000321521'
                },
                'AiPlayerbot.PremadeSpecLink.8.6.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '23000503310003--0533030310233100031' if patch_id < 12 else '23000503310003--05330303102331000321521'
                },
                'AiPlayerbot.PremadeSpecGlyph.9.0': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.9.0.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '235002203102351025--55000005' if patch_id < 12 else '23500220310035100550031--55'
                },
                'AiPlayerbot.PremadeSpecLink.9.0.70': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '235002203102351025--55000005' if patch_id < 12 else '23500220310235102551031--55000005'
                },
                'AiPlayerbot.PremadeSpecLink.9.0.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '235002203102351025--55000005' if patch_id < 12 else '23500220310235102551031--55000005'
                },
                'AiPlayerbot.PremadeSpecGlyph.9.1': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.9.1.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '002-203203301035012531-55000005' if patch_id < 12 else '-0032033011352025301351-53'
                },
                'AiPlayerbot.PremadeSpecLink.9.1.70': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '002-203203301035012531-55000005' if patch_id < 12 else '03-0032033011352025301351-55000005'
                },
                'AiPlayerbot.PremadeSpecLink.9.1.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '002-203203301035012531-55000005' if patch_id < 12 else '03-0032033011352025301351-55000005'
                },
                'AiPlayerbot.PremadeSpecGlyph.9.2': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.9.2.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '025-03310030003-05203205220031051' if patch_id < 12 else '-032-052032052203310513351'
                },
                'AiPlayerbot.PremadeSpecLink.9.2.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '025-03310030003-05203205220031051' if patch_id < 12 else '005-0331003-052032052203310513351'
                },
                'AiPlayerbot.PremadeSpecGlyph.9.3': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.9.3.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '235002203102351025--55000005' if patch_id < 12 else '23500220310035100550031--55'
                },
                'AiPlayerbot.PremadeSpecLink.9.3.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '235002203102351025--55000005' if patch_id < 12 else '23500220310235102551031--55000005'
                },
                'AiPlayerbot.PremadeSpecGlyph.9.4': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.9.4.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '002-203203301035012531-55000005' if patch_id < 12 else '-0032033011352025301351-53'
                },
                'AiPlayerbot.PremadeSpecLink.9.4.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '002-203203301035012531-55000005' if patch_id < 12 else '03-0032033011352025301351-55000005'
                },
                'AiPlayerbot.PremadeSpecGlyph.9.5': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.9.5.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '025-03310030003-05203205220031051' if patch_id < 12 else '-032-052032052203310513351'
                },
                'AiPlayerbot.PremadeSpecLink.9.5.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '025-03310030003-05203205220031051' if patch_id < 12 else '005-0331003-052032052203310513351'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.0': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.11.0.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '503210312533130321--205003012' if patch_id < 12 else '503200312533133201351--203'
                },
                'AiPlayerbot.PremadeSpecLink.11.0.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '503210312533130321--205003012' if patch_id < 12 else '503200312533133221351--205003012'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.1': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.11.1.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-5332321323220103531-205' if patch_id < 12 else '-50323213232201035310001-2034'
                },
                'AiPlayerbot.PremadeSpecLink.11.1.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-5332321323220103531-205' if patch_id < 12 else '-50323213232221035312001-20550201'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.2': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.11.2.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '05320001--23003331253151251' if patch_id < 12 else '051--230033312031502531251'
                },
                'AiPlayerbot.PremadeSpecLink.11.2.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '05320001--23003331253151251' if patch_id < 12 else '05320001--230033312431502531351'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.3': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.11.3.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-5532020323220100531-205003002' if patch_id < 12 else '-51320203232201005312031-203203'
                },
                'AiPlayerbot.PremadeSpecLink.11.3.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-5532020323220100531-205003002' if patch_id < 12 else '-55320203232201005312031-203503012'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.4': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.11.4.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '503210312533130321--205003012' if patch_id < 12 else '503200312533133201351--203'
                },
                'AiPlayerbot.PremadeSpecLink.11.4.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '503210312533130321--205003012' if patch_id < 12 else '503200312533133221351--205003012'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.5': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.11.5.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-5532020323220100531-205003002' if patch_id < 12 else '-51320203232201005312031-203203'
                },
                'AiPlayerbot.PremadeSpecLink.11.5.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '-5532020323220100531-205003002' if patch_id < 12 else '-55320203232201005312031-203503012'
                },
                'AiPlayerbot.PremadeSpecGlyph.11.6': {
                    'enabled': patch_id < 17,
                    'value': '0,0,0,0,0,0'
                },
                'AiPlayerbot.PremadeSpecLink.11.6.60': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '05320001--23003331253151251' if patch_id < 12 else '051--230033312031502531251'
                },
                'AiPlayerbot.PremadeSpecLink.11.6.80': {
                    'enabled': patch_id < 17 and use_custom_talent_trees,
                    'value': '05320001--23003331253151251' if patch_id < 12 else '05320001--230033312431502531351'
                }
            }
        },
        'modules/mod_player_bot_level_brackets.conf': {
            'enabled': options['build.world'] and options['module.playerbots.enabled'] and options['module.playerbots_level_brackets.enabled'],
            'options': {
                'BotLevelBrackets.Dynamic.UseDynamicDistribution': {
                    'enabled': options['module.playerbots_level_brackets.dynamic_distribution'],
                    'value': 1
                },
                'BotLevelBrackets.NumRanges': {
                    'enabled': patch_id < 17,
                    'value': 7 if patch_id < 12 else 8
                },
                'BotLevelBrackets.Alliance.Range1.Pct': {
                    'enabled': patch_id < 17,
                    'value': 0
                },
                'BotLevelBrackets.Alliance.Range2.Pct': {
                    'enabled': patch_id < 17,
                    'value': 14 if patch_id < 12 else 12
                },
                'BotLevelBrackets.Alliance.Range3.Pct': {
                    'enabled': patch_id < 17,
                    'value': 14 if patch_id < 12 else 12
                },
                'BotLevelBrackets.Alliance.Range4.Pct': {
                    'enabled': patch_id < 17,
                    'value': 14 if patch_id < 12 else 12
                },
                'BotLevelBrackets.Alliance.Range5.Pct': {
                    'enabled': patch_id < 17,
                    'value': 14 if patch_id < 12 else 12
                },
                'BotLevelBrackets.Alliance.Range6.Pct': {
                    'enabled': patch_id < 17,
                    'value': 14 if patch_id < 12 else 12
                },
                'BotLevelBrackets.Alliance.Range7.Upper': {
                    'enabled': patch_id < 12,
                    'value': 60
                },
                'BotLevelBrackets.Alliance.Range7.Pct': {
                    'enabled': patch_id < 17,
                    'value': 30 if patch_id < 12 else 12
                },
                'BotLevelBrackets.Alliance.Range8.Upper': {
                    'enabled': patch_id >= 12 and patch_id < 17,
                    'value': 70
                },
                'BotLevelBrackets.Alliance.Range8.Pct': {
                    'enabled': patch_id < 17,
                    'value': 0 if patch_id < 12 else 28
                },
                'BotLevelBrackets.Alliance.Range9.Pct': {
                    'enabled': patch_id < 17,
                    'value': 0
                },
                'BotLevelBrackets.Horde.Range1.Pct': {
                    'enabled': patch_id < 17,
                    'value': 0
                },
                'BotLevelBrackets.Horde.Range2.Pct': {
                    'enabled': patch_id < 17,
                    'value': 14 if patch_id < 12 else 12
                },
                'BotLevelBrackets.Horde.Range3.Pct': {
                    'enabled': patch_id < 17,
                    'value': 14 if patch_id < 12 else 12
                },
                'BotLevelBrackets.Horde.Range4.Pct': {
                    'enabled': patch_id < 17,
                    'value': 14 if patch_id < 12 else 12
                },
                'BotLevelBrackets.Horde.Range5.Pct': {
                    'enabled': patch_id < 17,
                    'value': 14 if patch_id < 12 else 12
                },
                'BotLevelBrackets.Horde.Range6.Pct': {
                    'enabled': patch_id < 17,
                    'value': 14 if patch_id < 12 else 12
                },
                'BotLevelBrackets.Horde.Range7.Upper': {
                    'enabled': patch_id < 12,
                    'value': 60
                },
                'BotLevelBrackets.Horde.Range7.Pct': {
                    'enabled': patch_id < 17,
                    'value': 30 if patch_id < 12 else 12
                },
                'BotLevelBrackets.Horde.Range8.Upper': {
                    'enabled': patch_id >= 12 and patch_id < 17,
                    'value': 70
                },
                'BotLevelBrackets.Horde.Range8.Pct': {
                    'enabled': patch_id < 17,
                    'value': 0 if patch_id < 12 else 70
                },
                'BotLevelBrackets.Horde.Range9.Pct': {
                    'enabled': patch_id < 17,
                    'value': 0
                },
            }
        },
        'modules/mod_progression.conf': {
            'enabled': options['build.world'] and options['module.progression.enabled'],
            'options': {
                'Progression.Patch': {
                    'enabled': True,
                    'value': patch_id
                },
                'Progression.IcecrownCitadel.Aura': {
                    'enabled': True,
                    'value': options['module.progression.aura']
                },
                'Progression.TradableBindsOnPickup.Enforced': {
                    'enabled': True,
                    'value': 0
                },
                'Progression.QuestInfo.Enforced': {
                    'enabled': True,
                    'value': 0
                },
                'Progression.Achievements.Enforced': {
                    'enabled': True,
                    'value': 0
                },
                'Progression.Multiplier.Damage': {
                    'enabled': True,
                    'value': options['module.progression.multiplier.damage']
                },
                'Progression.Multiplier.Healing': {
                    'enabled': True,
                    'value': options['module.progression.multiplier.healing']
                }
            }
        },
        'modules/skip_dk_module.conf': {
            'enabled': options['build.world'] and options['module.skip_dk_starting_area.enabled'] and patch_id >= 17,
            'options': {
                'Skip.Deathknight.Starter.Announce.enable': {
                    'enabled': True,
                    'value': 0
                }
            }
        },
        'modules/mod_weekendbonus.conf': {
            'enabled': options['build.world'] and options['module.weekendbonus.enabled'],
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

    db_name = options['mysql.database.world']

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

    auth_needed = options['build.auth'] and not IsScreenActive('auth')
    world_needed = options['build.world'] and not IsScreenActive(f'world-{realm_id}')

    if auth_needed or world_needed:
        StartProcess('start.sh')

        if options['build.auth'] and IsScreenActive('auth'):
            print(f"{colorama.Fore.YELLOW}To access the authserver screen: screen -r auth{colorama.Style.RESET_ALL}")

        if options['build.world'] and IsScreenActive(f'world-{realm_id}'):
            print(f"{colorama.Fore.YELLOW}To access the worldserver screen: screen -r world-{realm_id}{colorama.Style.RESET_ALL}")
    else:
        print(f"{colorama.Fore.RED}The server is already running{colorama.Style.RESET_ALL}")

    print(f'{colorama.Fore.GREEN}Finished starting the server after {FormattedTime(int(time.time() - start_time))}...{colorama.Style.RESET_ALL}')

def StopServer():
    if os.name == 'nt':
        return

    print(f'{colorama.Fore.GREEN}Stopping the server...{colorama.Style.RESET_ALL}')
    function_start_time = time.time()

    auth_running = options['build.auth'] and IsScreenActive('auth')
    world_running = options['build.world'] and IsScreenActive(f'world-{realm_id}')

    if auth_running or world_running:
        if world_running:
            print(f"{colorama.Fore.YELLOW}Telling the worldserver to shut down...{colorama.Style.RESET_ALL}")
            SendShutdown()
            WaitForShutdown()

        auth_running = options['build.auth'] and IsScreenActive('auth')
        world_running = options['build.world'] and IsScreenActive(f'world-{realm_id}')
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

if not (options['build.auth'] or options['build.world']):
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
