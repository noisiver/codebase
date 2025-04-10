from pathlib import Path
from tqdm import tqdm
import colorama
import git
import multiprocessing
import os
import requests
import shutil
import subprocess
import stat
import sys

colorama.just_fix_windows_console()

cwd = os.getcwd()
map_update_threads = multiprocessing.cpu_count()

windows_paths = {
    'msbuild': 'C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/MSBuild/Current/Bin',
    'mysql': 'C:/Program Files/MySQL/MySQL Server 8.4',
    'openssl': 'C:/Program Files/OpenSSL-Win64',
    'cmake': 'C:/Program Files/CMake'
}

cores = [
    [ 'auth', 0, 0, 0 ],
    [ 'world1', 1, 0, 1 ],
    [ 'world2', 1, 12, 2 ],
    [ 'world3', 1, 18, 3 ]
]

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
    PrintError(msg)
    sys.exit(1)

modules = [
    ['mod-assistant', 'noisiver/mod-assistant', 'master', True, 0],
    ['mod-eluna', 'azerothcore/mod-eluna', 'master', False, 0],
    ['mod-dungeoneer', 'noisiver/mod-dungeoneer', 'master', True, 0],
    ['mod-fixes', 'noisiver/mod-fixes', 'master', True, 0],
    ['mod-gamemaster', 'noisiver/mod-gamemaster', 'master', True, 0],
    ['mod-junk-to-gold', 'noisiver/mod-junk-to-gold', 'master', True, 0],
    ['mod-learnspells', 'noisiver/mod-learnspells', 'progression', True, 0],
    ['mod-playerbots', 'noisiver/mod-playerbots', 'noisiver-cataclysm', True, 0],
    ['mod-progression', 'noisiver/mod-progression', 'master', True, 0],
    ['mod-skip-dk-starting-area', 'noisiver/mod-skip-dk-starting-area', 'noisiver', True, 17],
    ['mod-stop-killing-them', 'noisiver/mod-stop-killing-them', 'master', True, 12],
    ['mod-weekendbonus', 'noisiver/mod-weekendbonus', 'master', True, 0]
]

def GenerateBaseFolders():
    PrintHeader('Creating folders...')

    folders = []

    for core in cores:
        name = core[0]
        type = core[1]

        if type == 1:
            folders.append(f'dbc/{name}')

        folders.append(f'sql/{name}/auth')

        if type == 1:
            folders.append(f'sql/{name}/characters')
            folders.append(f'sql/{name}/world')

    count = 0
    if len(folders) > 0:
        for folder in folders:
            if not os.path.isdir(f'{cwd}/{folder}'):
                PrintProgress(f'Creating {folder}')
                os.makedirs(f'{cwd}/{folder}', 0o666)
                count = count + 1

    if count == 0:
        PrintProgress('No folders created')

    PrintHeader('Finished creating folders...')

    if count > 0:
        HandleError('Stopping script due to new folders being created')

def GenerateFolders(name, type):
    PrintHeader('Creating folders...')

    folders = [
        f'packaged/core/{name}',
        f'packaged/core/{name}/configs',
        f'packaged/logs/{name}'
    ]

    if type == 1:
        folders.append(f'packaged/core/{name}/configs/modules')
        folders.append(f'packaged/data/{name}')

    for folder in folders:
        if not os.path.isdir(f'{cwd}/{folder}'):
            PrintProgress(f'Creating {folder}')
            os.makedirs(f'{cwd}/{folder}', 0o666)

    PrintHeader('Finished creating folders...')

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

def DownloadSource(name, type, id):
    PrintHeader('Downloading source code...')

    source = f'{cwd}/source/{name}'

    UpdateSource(source, 'git@github.com:noisiver/azerothcore.git', 'noisiver', 'azerothcore')

    if type == 1:
        for module in modules:
            path = f'{source}/modules/{module[0]}'
            repo = module[1]
            branch = module[2]
            enabled = module[3]
            patch = module[4]

            if enabled and id >= patch:
                UpdateSource(path, f'git@github.com:{repo}', branch, module[0])

    PrintHeader('Finished downloading source code...')

def GenerateProject(name, type):
    PrintHeader('Generating project files...')

    args = [
        f'-S {cwd}/source/{name}',
        f'-B {cwd}/source/{name}/build',
        '-DWITH_WARNINGS=0',
        '-DSCRIPTS=static',
        f'-DAPPS_BUILD={'auth-only' if type == 0 else 'world-only'}',
        f'-DMYSQL_EXECUTABLE={windows_paths['mysql']}/bin/mysql.exe'
        f'-DMYSQL_INCLUDE_DIR={windows_paths['mysql']}/include'
        f'-DMYSQL_LIBRARY={windows_paths['mysql']}/lib/libmysql.lib'
    ]

    try:
        subprocess.run([f'{windows_paths['cmake']}/bin/cmake.exe', *args], check=True)
    except:
        HandleError('An error occurred while generating the project files')

    PrintHeader('Finished generating project files...')

def CleanSource(name):
    args = [
        f'{cwd}/source/{name}/build/AzerothCore.sln',
        '/t:Clean'
    ]

    try:
        subprocess.run([f'{windows_paths['msbuild']}/MSBuild.exe', *args], cwd=build, check=True)
    except:
        HandleError('An error occurred while compiling the source code')

def CompileSource(name, type):
    PrintHeader('Compiling the source code...')

    args = [
        f'{cwd}/source/{name}/build/AzerothCore.sln',
        '/p:Configuration=RelWithDebInfo',
        '/p:WarningLevel=0'
    ]

    if type == 0:
        args.append('/target:authserver')
    else:
        args.append('/target:worldserver')

    attempts = 1
    while attempts < 3:
        try:
            subprocess.run([f'{windows_paths['msbuild']}/MSBuild.exe', *args], cwd=f'{cwd}/source/{name}/build', check=True)
            break
        except:
            CleanSource(name)
            attempts += 1
            if attempts == 2:
                HandleError('An error occurred while compiling the source code')

    PrintHeader('Finished compiling the source code...')

def CopyBinaries(name, type):
    binaries = [
        f'{'authserver' if type == 0 else 'worldserver'}.exe',
        f'{'authserver' if type == 0 else 'worldserver'}.pdb'
    ]

    try:
        for bin in binaries:
            PrintProgress(f'Copying {bin}')
            shutil.copyfile(f'{cwd}/source/{name}/build/bin/RelWithDebInfo/{bin}', f'{cwd}/packaged/core/{name}/{bin}')
    except Exception as e:
        PrintError('An error occured while copying library files')

def CreateScript(name, path, text):
    PrintProgress(f'Creating {name}')
    file = open(f'{path}/{name}', 'w')
    file.write(text)
    file.close()
    f = Path(f'{path}/{name}')
    f.chmod(f.stat().st_mode | stat.S_IEXEC)

def CreateScripts(name, type):
    if type == 0:
        CreateScript('auth.bat', f'{cwd}/packaged/core/{name}', '@echo off\n:auth\n    authserver.exe\ngoto auth\n')
    else:
        CreateScript('world.bat', f'{cwd}/packaged/core/{name}', '@echo off\n:world\n    worldserver.exe\n    timeout 10\ngoto world\n')

def CopyLibraries(name):
    libraries = [
        [f'{windows_paths['openssl']}/bin', 'legacy.dll'],
        [f'{windows_paths['openssl']}/bin', 'libcrypto-3-x64.dll'],
        [f'{windows_paths['openssl']}/bin', 'libssl-3-x64.dll'],
        [f'{windows_paths['mysql']}/lib', 'libmysql.dll']
    ]

    PrintHeader('Copying required libraries...')

    try:
        for lib in libraries:
            PrintProgress(f'Copying {lib[1]}')
            shutil.copyfile(f'{lib[0]}/{lib[1]}', f'{cwd}/packaged/core/{name}/{lib[1]}')
    except Exception as e:
        PrintError('An error occured while copying library files')

    PrintHeader('Finished copying required libraries...')

def GetLocalDataVersion(name):
    version = 0
    data_file = f'{cwd}/packaged/data/{name}/data.version'
    if os.path.exists(data_file) and os.path.isfile(data_file):
        file = open(data_file, 'r')
        content = file.read()
        if content.isnumeric():
            version = content
    return version

def GetDownloadedDataVersion():
    version = 0
    data_file = f'{cwd}/data.version'
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

def DeleteClientData(name):
    dirs = ['Cameras', 'dbc', 'maps', 'mmaps', 'vmaps']
    for dir in dirs:
        if os.path.exists(f'{cwd}/packaged/data/{name}/{dir}'):
            shutil.rmtree(f'{cwd}/packaged/data/{name}/{dir}')

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

def UnpackDataFiles(name):
    try:
        PrintProgress('Unpacking archive')
        shutil.unpack_archive(f'{cwd}/data.zip', f'{cwd}/packaged/data/{name}')
    except Exception as e:
        print(e.stderr)
        HandleError('An error occurred while unpacking the client data files')

def UpdateDownloadedDataVersion(version):
    file = open(f'{cwd}/data.version', 'w')
    file.write(version)
    file.close()

def UpdateDataVersion(name, version):
    file = open(f'{cwd}/packaged/data/{name}/data.version', 'w')
    file.write(version)
    file.close()

def UpdateClientData(name):
    PrintHeader('Downloading client data files...')

    downloaded_version = GetDownloadedDataVersion()
    local_version = GetLocalDataVersion(name)
    remote_version = GetRemoteDataVersion()

    if downloaded_version != remote_version:
        DownloadClientData(remote_version)
        UpdateDownloadedDataVersion(remote_version)

    if local_version != downloaded_version:
        DeleteClientData(name)
        UnpackDataFiles(name)
        UpdateDataVersion(name, downloaded_version)
    else:
        PrintProgress('The files are up-to-date')

    PrintHeader('Finished downloading client data files...')

def CopyDBCFiles(name):
    PrintHeader('Copying modified client data files...')

    files = sorted(os.listdir(f'{cwd}/dbc/{name}'))
    if len(files) > 0:
        for file in files:
            if os.path.isfile(f'{cwd}/dbc/{name}/{file}'):
                if file.endswith('.dbc'):
                    PrintProgress(f'Copying {file}')
                    shutil.copyfile(f'{cwd}/dbc/{name}/{file}', f'{cwd}/packaged/data/{name}/dbc/{file}')
    else:
        PrintProgress('No files found in the directory')

    PrintHeader('Finished copying modified client data files...')

def GetConfigOptions(name, type, patch, id):
    if patch < 12:
        playerbots_starting_level = 1
        playerbots_maps = '0,1'
    elif patch < 17:
        playerbots_starting_level = 1
        playerbots_maps = '0,1,530'
    else:
        playerbots_starting_level = 1
        playerbots_maps = '0,1,530,571'

    if patch < 16:
        playerbots_apprentice_riding = 40
    elif patch < 19:
        playerbots_apprentice_riding = 30
    else:
        playerbots_apprentice_riding = 20

    if patch < 19:
        playerbots_journeyman_riding = 60
        playerbots_expert_riding = 70
    else:
        playerbots_journeyman_riding = 40
        playerbots_expert_riding = 60

    configs = [
        [
            'authserver.conf', False, 0, [
                ['LoginDatabaseInfo =', 'LoginDatabaseInfo = "127.0.0.1;3306;acore;acore;acore_auth"'],
                ['SourceDirectory =', f'SourceDirectory = "../../source/{name}"'],
                ['MySQLExecutable =', 'MySQLExecutable = "../../mysql/bin/mysql.exe"'],
                ['LogsDir =', f'LogsDir = "../../logs/{name}"'],
            ]
        ],
        [
            'worldserver.conf', True, 0, [
                ['RealmID =', f'RealmID = {id}'],
                ['WorldServerPort =', f'WorldServerPort = {29724 + id}'],
                ['LoginDatabaseInfo     =', 'LoginDatabaseInfo     ="127.0.0.1;3306;acore;acore;acore_auth"'],
                ['WorldDatabaseInfo     =', f'WorldDatabaseInfo     ="127.0.0.1;3306;acore;acore;acore_world_{id}"'],
                ['CharacterDatabaseInfo = ', f'CharacterDatabaseInfo = "127.0.0.1;3306;acore;acore;acore_characters_{id}"'],
                ['LoginDatabase.SynchThreads     =', 'LoginDatabase.SynchThreads     = 2'],
                ['WorldDatabase.SynchThreads     =', 'WorldDatabase.SynchThreads     = 2'],
                ['CharacterDatabase.SynchThreads =', 'CharacterDatabase.SynchThreads = 2'],
                ['DataDir =', f'DataDir = "../../data/{name}"'],
                ['LogsDir =', f'LogsDir = "../../logs/{name}"'],
                ['SourceDirectory =', f'SourceDirectory = "../../source/{name}"'],
                ['MySQLExecutable =', 'MySQLExecutable = "../../mysql/bin/mysql.exe"'],
                ['BeepAtStart =', 'BeepAtStart = 0'],
                ['FlashAtStart =', 'FlashAtStart = 0'],
                ['GameType =', 'GameType = 0'],
                ['RealmZone =', 'RealmZone = 8'],
                ['MinWorldUpdateTime =', 'MinWorldUpdateTime = 1'],
                ['MapUpdateInterval =', 'MapUpdateInterval = 100'],
                ['MapUpdate.Threads =', f'MapUpdate.Threads = {map_update_threads}'],
                ['PreloadAllNonInstancedMapGrids =', 'PreloadAllNonInstancedMapGrids = 0'],
                ['SetAllCreaturesWithWaypointMovementActive =', 'SetAllCreaturesWithWaypointMovementActive = 0'],
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
                ['Warden.Enabled =', 'Warden.Enabled = 1']
            ]
        ],
        [
            'modules/mod_assistant.conf', True, 0, [
                ['Assistant.Heirlooms.Enabled  =', f'Assistant.Heirlooms.Enabled  = {'0' if patch < 17 else '1'}'],
                ['Assistant.Glyphs.Enabled     =', f'Assistant.Glyphs.Enabled     = {'0' if patch < 17 else '1'}'],
                ['Assistant.Gems.Enabled       =', f'Assistant.Gems.Enabled       = {'0' if patch < 17 else '1'}'],
                ['Assistant.Elixirs.Enabled    =', f'Assistant.Elixirs.Enabled    = {'0' if patch < 17 else '1'}'],
                ['Assistant.Food.Enabled       =', f'Assistant.Food.Enabled       = {'0' if patch < 17 else '1'}'],
                ['Assistant.Enchants.Enabled   =', f'Assistant.Enchants.Enabled   = {'0' if patch < 17 else '1'}'],
                ['Assistant.FlightPaths.Vanilla.Enabled                  =', 'Assistant.FlightPaths.Vanilla.Enabled                  = 0'],
                ['Assistant.FlightPaths.BurningCrusade.Enabled           =', 'Assistant.FlightPaths.BurningCrusade.Enabled           = 0'],
                ['Assistant.Professions.Master.Enabled      =', f'Assistant.Professions.Master.Enabled      = {'0' if patch < 12 else '1'}'],
                ['Assistant.Professions.GrandMaster.Enabled =', f'Assistant.Professions.GrandMaster.Enabled = {'0' if patch < 17 else '1'}'],
                ['Assistant.Instances.Heroic.Enabled  =', f'Assistant.Instances.Heroic.Enabled  = {'0' if patch < 12 else '1'}']
            ]
        ],
        [
            'modules/mod_learnspells.conf', True, 0, [
                ['LearnSpells.Gamemasters =', 'LearnSpells.Gamemasters = 1'],
                ['LearnSpells.SpellsFromQuests =', 'LearnSpells.SpellsFromQuests = 1'],
                ['LearnSpells.Riding.Apprentice =', 'LearnSpells.Riding.Apprentice = 1'],
                ['LearnSpells.Riding.Journeyman =', f'LearnSpells.Riding.Journeyman = {'0' if patch < 12 else '1'}'],
                ['LearnSpells.Riding.Expert =', f'LearnSpells.Riding.Expert = {'0' if patch < 17 else '1'}']
            ]
        ],
        [
            'modules/playerbots.conf', True, 0, [
                ['AiPlayerbot.MinRandomBots =', 'AiPlayerbot.MinRandomBots = 0'],
                ['AiPlayerbot.MaxRandomBots =', 'AiPlayerbot.MaxRandomBots = 0'],
                ['AiPlayerbot.AllowPlayerBots =', 'AiPlayerbot.AllowPlayerBots = 1'],
                ['AiPlayerbot.SelfBotLevel =', 'AiPlayerbot.SelfBotLevel = 2'],
                ['AiPlayerbot.SayWhenCollectingItems =', 'AiPlayerbot.SayWhenCollectingItems = 0'],
                ['AiPlayerbot.TellWhenAvoidAoe =', 'AiPlayerbot.TellWhenAvoidAoe = 0'],
                ['AiPlayerbot.AutoGearQualityLimit =', 'AiPlayerbot.AutoGearQualityLimit = 5'],
                ['AiPlayerbot.DisableDeathKnightLogin =', f'AiPlayerbot.DisableDeathKnightLogin = {'1' if patch < 17 else '0'}'],
                ['AiPlayerbot.DisableRandomLevels =', 'AiPlayerbot.DisableRandomLevels = 1'],
                ['AiPlayerbot.RandombotStartingLevel =', f'AiPlayerbot.RandombotStartingLevel = {playerbots_starting_level}'],
                ['AiPlayerbot.RandomGearQualityLimit =', 'AiPlayerbot.RandomGearQualityLimit = 5'],
                ['AiPlayerbot.RandomBotGroupNearby =', 'AiPlayerbot.RandomBotGroupNearby = 1'],
                ['AiPlayerbot.RandomBotMaps =', f'AiPlayerbot.RandomBotMaps = {playerbots_maps}'],
                ['PlayerbotsDatabaseInfo =', f'PlayerbotsDatabaseInfo = "127.0.0.1;3306;acore;acore;acore_playerbots_{id}"'],
                ['AiPlayerbot.RandomBotTalk =', 'AiPlayerbot.RandomBotTalk = 0'],
                ['AiPlayerbot.RandomBotSuggestDungeons =', 'AiPlayerbot.RandomBotSuggestDungeons = 0'],
                ['AiPlayerbot.ToxicLinksRepliesChance =', 'AiPlayerbot.ToxicLinksRepliesChance = 0'],
                ['AiPlayerbot.ThunderfuryRepliesChance =', 'AiPlayerbot.ThunderfuryRepliesChance = 0'],
                ['AiPlayerbot.GuildRepliesRate =', 'AiPlayerbot.GuildRepliesRate = 0'],
                ['AIPlayerbot.GuildFeedback =', 'AIPlayerbot.GuildFeedback = 0'],
                ['AiPlayerbot.EnableBroadcasts =', 'AiPlayerbot.EnableBroadcasts = 0'],
                ['AiPlayerbot.AddClassCommand =', 'AiPlayerbot.AddClassCommand = 0'],
                ['AiPlayerbot.AddClassAccountPoolSize =', 'AiPlayerbot.AddClassAccountPoolSize = 0'],
                ['AiPlayerbot.BotActiveAlone =', 'AiPlayerbot.BotActiveAlone = 100'],
                ['AiPlayerbot.botActiveAloneSmartScale =', 'AiPlayerbot.botActiveAloneSmartScale = 0'],
                ['AiPlayerbot.AutoAvoidAoe =', 'AiPlayerbot.AutoAvoidAoe = 1'],
                ['AiPlayerbot.CommandServerPort =', 'AiPlayerbot.CommandServerPort = 0'],
                ['AiPlayerbot.RandomBotArenaTeam2v2Count =', f'AiPlayerbot.RandomBotArenaTeam2v2Count = {'0' if patch < 12 else '15'}'],
                ['AiPlayerbot.RandomBotArenaTeam3v3Count =', f'AiPlayerbot.RandomBotArenaTeam3v3Count = {'0' if patch < 12 else '15'}'],
                ['AiPlayerbot.RandomBotArenaTeam5v5Count =', f'AiPlayerbot.RandomBotArenaTeam5v5Count = {'0' if patch < 12 else '25'}'],
                ['AiPlayerbot.KillXPRate =', 'AiPlayerbot.KillXPRate = 1'],
                ['AiPlayerbot.AutoEquipUpgradeLoot =', 'AiPlayerbot.AutoEquipUpgradeLoot = 0'],
                ['AiPlayerbot.FreeFood =', 'AiPlayerbot.FreeFood = 1'],
                ['AiPlayerbot.AutoPickReward =', 'AiPlayerbot.AutoPickReward = no'],
                ['AiPlayerbot.AutoTrainSpells =', 'AiPlayerbot.AutoTrainSpells = no'],
                ['AiPlayerbot.EnableNewRpgStrategy =', 'AiPlayerbot.EnableNewRpgStrategy = 1'],
                ['AiPlayerbot.DropObsoleteQuests =', 'AiPlayerbot.DropObsoleteQuests = 0'],
                ['PlayerbotsDatabase.WorkerThreads =', 'PlayerbotsDatabase.WorkerThreads = 4'],
                ['AiPlayerbot.UseGroundMountAtMinLevel =', f'AiPlayerbot.UseGroundMountAtMinLevel = {playerbots_apprentice_riding}'],
                ['AiPlayerbot.UseFastGroundMountAtMinLevel =', f'AiPlayerbot.UseFastGroundMountAtMinLevel = {playerbots_journeyman_riding}'],
                ['AiPlayerbot.UseFlyMountAtMinLevel =', f'AiPlayerbot.UseFlyMountAtMinLevel = {playerbots_expert_riding}'],
                ['AiPlayerbot.EquipmentPersistence =', 'AiPlayerbot.EquipmentPersistence = 1'],
                ['AiPlayerbot.EquipmentPersistenceLevel =', 'AiPlayerbot.EquipmentPersistenceLevel = 1']
            ]
        ],
        [
            'modules/mod_progression.conf', True, 0, [
                ['Progression.Patch =', f'Progression.Patch = {patch}'],
                ['Progression.IcecrownCitadel.Aura =', 'Progression.IcecrownCitadel.Aura = 0'],
                ['Progression.TradableBindsOnPickup.Enforced =', 'Progression.TradableBindsOnPickup.Enforced = 0'],
                ['Progression.QuestInfo.Enforced =', 'Progression.QuestInfo.Enforced = 0'],
                ['Progression.Multiplier.Damage =', 'Progression.Multiplier.Damage = 0.6'],
                ['Progression.Multiplier.Healing =', 'Progression.Multiplier.Healing = 1'],
                ['Progression.Reset =', 'Progression.Reset = 1']
            ]
        ],
        [
            'modules/skip_dk_module.conf', True, 17, [
                ['Skip.Deathknight.Starter.Announce.enable =', 'Skip.Deathknight.Starter.Announce.enable = 0']
            ]
        ],
        [
            'modules/mod_weekendbonus.conf', True, 0, [
                ['WeekendBonus.Multiplier.Experience =', 'WeekendBonus.Multiplier.Experience = 2.0'],
                ['WeekendBonus.Multiplier.Money =', 'WeekendBonus.Multiplier.Money = 2.0'],
                ['WeekendBonus.Multiplier.Professions =', 'WeekendBonus.Multiplier.Professions = 2'],
                ['WeekendBonus.Multiplier.Reputation =', 'WeekendBonus.Multiplier.Reputation = 2.0'],
                ['WeekendBonus.Multiplier.Proficiencies =', 'WeekendBonus.Multiplier.Proficiencies = 2'],
                ['WeekendBonus.Multiplier.Honor =', 'WeekendBonus.Multiplier.Honor = 2.0']
            ]
        ]
    ]

    if patch < 17:
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.1.0 =', 'AiPlayerbot.PremadeSpecGlyph.1.0 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.1.1 =', 'AiPlayerbot.PremadeSpecGlyph.1.1 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.1.2 =', 'AiPlayerbot.PremadeSpecGlyph.1.2 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.2.0 =', 'AiPlayerbot.PremadeSpecGlyph.2.0 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.2.1 =', 'AiPlayerbot.PremadeSpecGlyph.2.1 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.2.2 =', 'AiPlayerbot.PremadeSpecGlyph.2.2 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.3.0 =', 'AiPlayerbot.PremadeSpecGlyph.3.0 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.3.1 =', 'AiPlayerbot.PremadeSpecGlyph.3.1 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.3.2 =', 'AiPlayerbot.PremadeSpecGlyph.3.2 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.4.0 =', 'AiPlayerbot.PremadeSpecGlyph.4.0 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.4.1 =', 'AiPlayerbot.PremadeSpecGlyph.4.1 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.4.2 =', 'AiPlayerbot.PremadeSpecGlyph.4.2 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.5.0 =', 'AiPlayerbot.PremadeSpecGlyph.5.0 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.5.1 =', 'AiPlayerbot.PremadeSpecGlyph.5.1 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.5.2 =', 'AiPlayerbot.PremadeSpecGlyph.5.2 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.7.0 =', 'AiPlayerbot.PremadeSpecGlyph.7.0 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.7.1 =', 'AiPlayerbot.PremadeSpecGlyph.7.1 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.7.2 =', 'AiPlayerbot.PremadeSpecGlyph.7.2 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.8.0 =', 'AiPlayerbot.PremadeSpecGlyph.8.0 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.8.1 =', 'AiPlayerbot.PremadeSpecGlyph.8.1 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.8.2 =', 'AiPlayerbot.PremadeSpecGlyph.8.2 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.8.3 =', 'AiPlayerbot.PremadeSpecGlyph.8.3 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.9.0 =', 'AiPlayerbot.PremadeSpecGlyph.9.0 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.9.1 =', 'AiPlayerbot.PremadeSpecGlyph.9.1 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.9.2 =', 'AiPlayerbot.PremadeSpecGlyph.9.2 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.11.0 =', 'AiPlayerbot.PremadeSpecGlyph.11.0 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.11.1 =', 'AiPlayerbot.PremadeSpecGlyph.11.1 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.11.2 =', 'AiPlayerbot.PremadeSpecGlyph.11.2 = 0,0,0,0,0,0'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecGlyph.11.3 =', 'AiPlayerbot.PremadeSpecGlyph.11.3 = 0,0,0,0,0,0'])

    if patch < 12:
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.1.0.60 =', 'AiPlayerbot.PremadeSpecLink.1.0.60 = 30220321233351000021-30505300002'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.1.0.80 =', 'AiPlayerbot.PremadeSpecLink.1.0.80 = 30220321233351000021-30505300002'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.1.1.60 =', 'AiPlayerbot.PremadeSpecLink.1.1.60 = 30202301233-325000005502310051'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.1.1.80 =', 'AiPlayerbot.PremadeSpecLink.1.1.80 = 30202301233-325000005502310051'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.1.2.60 =', 'AiPlayerbot.PremadeSpecLink.1.2.60 = 352000001-3-05335122500021251'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.1.2.80 =', 'AiPlayerbot.PremadeSpecLink.1.2.80 = 352000001-3-05335122500021251'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.2.0.60 =', 'AiPlayerbot.PremadeSpecLink.2.0.60 = 50350152020013251-5002-05202'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.2.0.80 =', 'AiPlayerbot.PremadeSpecLink.2.0.80 = 50350152020013251-5002-05202'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.2.1.60 =', 'AiPlayerbot.PremadeSpecLink.2.1.60 = -0500513520310231-502302500003'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.2.1.80 =', 'AiPlayerbot.PremadeSpecLink.2.1.80 = -0500513520310231-502302500003'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.2.2.60 =', 'AiPlayerbot.PremadeSpecLink.2.2.60 = -453201002-05232051203331301'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.2.2.65 =', 'AiPlayerbot.PremadeSpecLink.2.2.65 = -453201002-05232051203331301'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.2.2.80 =', 'AiPlayerbot.PremadeSpecLink.2.2.80 = -453201002-05232051203331301'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.3.0.60 =', 'AiPlayerbot.PremadeSpecLink.3.0.60 = 51200201515012241-005305001-5'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.3.0.80 =', 'AiPlayerbot.PremadeSpecLink.3.0.80 = 51200201515012241-005305001-5'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.3.1.60 =', 'AiPlayerbot.PremadeSpecLink.3.1.60 = 502-035305231230013231-5000002'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.3.1.80 =', 'AiPlayerbot.PremadeSpecLink.3.1.80 = 502-035305231230013231-5000002'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.3.2.60 =', 'AiPlayerbot.PremadeSpecLink.3.2.60 = -005305101-5000032500033330531'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.3.2.80 =', 'AiPlayerbot.PremadeSpecLink.3.2.80 = -005305101-5000032500033330531'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.4.0.60 =', 'AiPlayerbot.PremadeSpecLink.4.0.60 = 005303005350102501-005005001-502'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.4.0.80 =', 'AiPlayerbot.PremadeSpecLink.4.0.80 = 005303005350102501-005005001-502'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.4.1.60 =', 'AiPlayerbot.PremadeSpecLink.4.1.60 = 00532000531-0252051000035015201'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.4.1.80 =', 'AiPlayerbot.PremadeSpecLink.4.1.80 = 00532000531-0252051000035015201'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.4.2.60 =', 'AiPlayerbot.PremadeSpecLink.4.2.60 = 3053031-3-5320232030300121051'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.4.2.80 =', 'AiPlayerbot.PremadeSpecLink.4.2.80 = 3053031-3-5320232030300121051'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.5.0.60 =', 'AiPlayerbot.PremadeSpecLink.5.0.60 = 050320313030051231-2055100303'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.5.0.80 =', 'AiPlayerbot.PremadeSpecLink.5.0.80 = 050320313030051231-2055100303'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.5.1.60 =', 'AiPlayerbot.PremadeSpecLink.5.1.60 = 0503203-23505103030215251'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.5.1.80 =', 'AiPlayerbot.PremadeSpecLink.5.1.80 = 0503203-23505103030215251'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.5.2.60 =', 'AiPlayerbot.PremadeSpecLink.5.2.60 = 05032031--3250230512230102231'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.5.2.80 =', 'AiPlayerbot.PremadeSpecLink.5.2.80 = 05032031--3250230512230102231'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.7.0.60 =', 'AiPlayerbot.PremadeSpecLink.7.0.60 = 3530001523213351-005050031'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.7.0.80 =', 'AiPlayerbot.PremadeSpecLink.7.0.80 = 3530001523213351-005050031'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.7.1.60 =', 'AiPlayerbot.PremadeSpecLink.7.1.60 = 053030051-3020503300502133301'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.7.1.80 =', 'AiPlayerbot.PremadeSpecLink.7.1.80 = 053030051-3020503300502133301'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.7.2.60 =', 'AiPlayerbot.PremadeSpecLink.7.2.60 = -0050503-0500533133531051'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.7.2.80 =', 'AiPlayerbot.PremadeSpecLink.7.2.80 = -0050503-0500533133531051'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.8.0.60 =', 'AiPlayerbot.PremadeSpecLink.8.0.60 = 235005030100330150321-03-023023001'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.8.0.80 =', 'AiPlayerbot.PremadeSpecLink.8.0.80 = 235005030100330150321-03-023023001'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.8.1.60 =', 'AiPlayerbot.PremadeSpecLink.8.1.60 = 2300230311-0055032012303330051'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.8.1.80 =', 'AiPlayerbot.PremadeSpecLink.8.1.80 = 2300230311-0055032012303330051'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.8.2.60 =', 'AiPlayerbot.PremadeSpecLink.8.2.60 = 23000503310003--0533030310233100031'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.8.2.80 =', 'AiPlayerbot.PremadeSpecLink.8.2.80 = 23000503310003--0533030310233100031'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.8.3.60 =', 'AiPlayerbot.PremadeSpecLink.8.3.60 = 23000503310003--0533030310233100031'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.8.3.80 =', 'AiPlayerbot.PremadeSpecLink.8.3.80 = 23000503310003--0533030310233100031'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.9.0.60 =', 'AiPlayerbot.PremadeSpecLink.9.0.60 = 235002203102351025--55000005'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.9.0.70 =', 'AiPlayerbot.PremadeSpecLink.9.0.70 = 235002203102351025--55000005'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.9.0.80 =', 'AiPlayerbot.PremadeSpecLink.9.0.80 = 235002203102351025--55000005'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.9.1.60 =', 'AiPlayerbot.PremadeSpecLink.9.1.60 = 002-203203301035012531-55000005'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.9.1.70 =', 'AiPlayerbot.PremadeSpecLink.9.1.70 = 002-203203301035012531-55000005'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.9.1.80 =', 'AiPlayerbot.PremadeSpecLink.9.1.80 = 002-203203301035012531-55000005'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.9.2.60 =', 'AiPlayerbot.PremadeSpecLink.9.2.60 = 025-03310030003-05203205220031051'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.9.2.80 =', 'AiPlayerbot.PremadeSpecLink.9.2.80 = 025-03310030003-05203205220031051'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.11.0.60 =', 'AiPlayerbot.PremadeSpecLink.11.0.60 = 503210312533130321--205003012'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.11.0.80 =', 'AiPlayerbot.PremadeSpecLink.11.0.80 = 503210312533130321--205003012'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.11.1.60 =', 'AiPlayerbot.PremadeSpecLink.11.1.60 = -5332321323220103531-205'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.11.1.80 =', 'AiPlayerbot.PremadeSpecLink.11.1.80 = -5332321323220103531-205'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.11.2.60 =', 'AiPlayerbot.PremadeSpecLink.11.2.60 = 05320001--23003331253151251'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.11.2.80 =', 'AiPlayerbot.PremadeSpecLink.11.2.80 = 05320001--23003331253151251'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.11.3.60 =', 'AiPlayerbot.PremadeSpecLink.11.3.60 = -5532020323220100531-205003002'])
        configs[6][3].append(['AiPlayerbot.PremadeSpecLink.11.3.80 =', 'AiPlayerbot.PremadeSpecLink.11.3.80 = -5532020323220100531-205003002'])

    return configs

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

def UpdateConfigs(name, type, patch, id):
    PrintHeader('Updating config files...')

    configs = GetConfigOptions(name, type, patch, id)
    for config in configs:
        filename = config[0]
        world_only = config[1]
        patch_id = config[2]
        replacements = config[3]

        if type == 0 and world_only:
            continue

        if type == 1 and not world_only:
            continue

        if patch < patch_id:
            continue

        try:
            shutil.copyfile(f'{cwd}/source/{name}/build/bin/RelWithDebInfo/configs/{filename}.dist', f'{cwd}/packaged/core/{name}/configs/{filename}.dist')
        except Exception as e:
            HandleError('An error occured while copying config files')

        UpdateConfig(f'{cwd}/packaged/core/{name}/configs/{filename}', replacements)

    PrintHeader('Finished updating config files...')

def CopyDatabaseFiles(name, type, patch):
    PrintHeader('Copying database files...')

    if os.path.exists(f'{cwd}/packaged/source/{name}'):
        shutil.rmtree(f'{cwd}/packaged/source/{name}')

    directories = [
        [f'source/{name}/data/sql/archive/db_auth', f'packaged/source/{name}/data/sql/archive/db_auth'],
        [f'source/{name}/data/sql/base/db_auth', f'packaged/source/{name}/data/sql/base/db_auth'],
        [f'source/{name}/data/sql/custom/db_auth', f'packaged/source/{name}/data/sql/custom/db_auth'],
        [f'source/{name}/data/sql/old/db_auth', f'packaged/source/{name}/data/sql/old/db_auth'],
        [f'source/{name}/data/sql/updates/db_auth', f'packaged/source/{name}/data/sql/updates/db_auth'],
        [f'source/{name}/data/sql/updates/pending_db_auth', f'packaged/source/{name}/data/sql/updates/pending_db_auth'],
        [f'sql/{name}/auth', f'packaged/source/{name}/data/sql/custom/db_auth']
    ]

    if type == 1:
        directories.append([f'source/{name}/data/sql/archive/db_characters', f'packaged/source/{name}/data/sql/archive/db_characters'])
        directories.append([f'source/{name}/data/sql/archive/db_world', f'packaged/source/{name}/data/sql/archive/db_world'])
        directories.append([f'source/{name}/data/sql/base/db_characters', f'packaged/source/{name}/data/sql/base/db_characters'])
        directories.append([f'source/{name}/data/sql/base/db_world', f'packaged/source/{name}/data/sql/base/db_world'])
        directories.append([f'source/{name}/data/sql/custom/db_characters', f'packaged/source/{name}/data/sql/custom/db_characters'])
        directories.append([f'source/{name}/data/sql/custom/db_world', f'packaged/source/{name}/data/sql/custom/db_world'])
        directories.append([f'source/{name}/data/sql/old/db_characters', f'packaged/source/{name}/data/sql/old/db_characters'])
        directories.append([f'source/{name}/data/sql/old/db_world', f'packaged/source/{name}/data/sql/old/db_world'])
        directories.append([f'source/{name}/data/sql/updates/db_characters', f'packaged/source/{name}/data/sql/updates/db_characters'])
        directories.append([f'source/{name}/data/sql/updates/db_world', f'packaged/source/{name}/data/sql/updates/db_world'])
        directories.append([f'source/{name}/data/sql/updates/pending_db_characters', f'packaged/source/{name}/data/sql/updates/pending_db_characters'])
        directories.append([f'source/{name}/data/sql/updates/pending_db_world', f'packaged/source/{name}/data/sql/updates/pending_db_world'])
        directories.append([f'sql/{name}/characters', f'packaged/source/{name}/data/sql/custom/db_characters'])
        directories.append([f'sql/{name}/world', f'packaged/source/{name}/data/sql/custom/db_world'])
        directories.append([f'source/{name}/modules/mod-assistant/data/sql/world', f'packaged/source/{name}/modules/mod-assistant/data/sql/world'])
        directories.append([f'source/{name}/modules/mod-fixes/data/sql/world', f'packaged/source/{name}/modules/mod-fixes/data/sql/world'])
        directories.append([f'source/{name}/modules/mod-playerbots/data/sql/characters', f'packaged/source/{name}/modules/mod-playerbots/data/sql/characters'])
        directories.append([f'source/{name}/modules/mod-playerbots/data/sql/playerbots/archive', f'packaged/source/{name}/modules/mod-playerbots/data/sql/playerbots/archive'])
        directories.append([f'source/{name}/modules/mod-playerbots/data/sql/playerbots/base', f'packaged/source/{name}/modules/mod-playerbots/data/sql/playerbots/base'])
        directories.append([f'source/{name}/modules/mod-playerbots/data/sql/playerbots/custom', f'packaged/source/{name}/modules/mod-playerbots/data/sql/playerbots/custom'])
        directories.append([f'source/{name}/modules/mod-playerbots/data/sql/playerbots/updates/db_playerbots', f'packaged/source/{name}/modules/mod-playerbots/data/sql/playerbots/updates/db_playerbots'])
        directories.append([f'source/{name}/modules/mod-playerbots/data/sql/world', f'packaged/source/{name}/modules/mod-playerbots/data/sql/world'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_00-1_1/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_00-1_1/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_01-1_2/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_01-1_2/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_02-1_3/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_02-1_3/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_03-1_4/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_03-1_4/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_04-1_5/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_04-1_5/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_05-1_6/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_05-1_6/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_06-1_7/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_06-1_7/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_07-1_8/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_07-1_8/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_08-1_9/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_08-1_9/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_09-1_10/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_09-1_10/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_10-1_11/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_10-1_11/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_11-1_12/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_11-1_12/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_12-2_0/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_12-2_0/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_13-2_1/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_13-2_1/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_14-2_2/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_14-2_2/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_15-2_3/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_15-2_3/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_16-2_4/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_16-2_4/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_17-3_0/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_17-3_0/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_18-3_1/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_18-3_1/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_19-3_2/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_19-3_2/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_20-3_3/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_20-3_3/sql'])
        directories.append([f'source/{name}/modules/mod-progression/src/patch_21-3_3_5/sql', f'packaged/source/{name}/modules/mod-progression/src/patch_21-3_3_5/sql'])

        if patch >= 17:
            directories.append([f'source/{name}/modules/mod-skip-dk-starting-area/data/sql/db-world', f'packaged/source/{name}/modules/mod-skip-dk-starting-area/data/sql/db-world'])

    for directory in directories:
        if not os.path.isdir(f'{cwd}/{directory[1]}'):
            os.makedirs(f'{cwd}/{directory[1]}', 0o666)

        files = sorted(os.listdir(f'{cwd}/{directory[0]}'))
        for file in files:
            if os.path.isfile(f'{cwd}/{directory[0]}/{file}'):
                if file.endswith('.sql'):
                    PrintProgress(f'Copying {file}')
                    shutil.copyfile(f'{cwd}/{directory[0]}/{file}', f'{cwd}/{directory[1]}/{file}')

    PrintHeader('Finished copying database files...')

GenerateBaseFolders()

for core in cores:
    name = core[0]
    type = core[1]
    patch = core[2]
    id = core[3]

    GenerateFolders(name, type)
    DownloadSource(name, type, patch)
    GenerateProject(name, type)
    CompileSource(name, type)
    CopyBinaries(name, type)
    CreateScripts(name, type)
    CopyLibraries(name)
    if type == 1:
        UpdateClientData(name)
        CopyDBCFiles(name)
    UpdateConfigs(name, type, patch, id)
    CopyDatabaseFiles(name, type, patch)
