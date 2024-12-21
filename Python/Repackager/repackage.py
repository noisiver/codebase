from pathlib import Path
from tqdm import tqdm
import git
import requests
import shutil
import subprocess
import stat
import os

cwd = os.getcwd()

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
    [ 'world3', 1, 19, 3 ]
]

def CreateTargetFolders():
    if os.path.exists(f'{cwd}/packaged'):
        shutil.rmtree(f'{cwd}/packaged')

    for directory in directories:
        if not os.path.isdir(directory):
            os.makedirs(directory, 0o666)

class GitProgress(git.remote.RemoteProgress):
    def line_dropped(self, line):
        print(line)
    def update(self, *args):
        print(self._cur_line)

def ResetSource(path, branch):
    repo = git.Repo(path)
    repo.git.reset('--hard', f'origin/{branch}')

def CloneSource(path, url, branch):
    git.Repo.clone_from(url=url, to_path=path, branch=branch, depth=1, progress=GitProgress())

def PullSource(path):
    repo = git.Repo(path)
    repo.remotes.origin.pull(progress=GitProgress())

def DownloadSource(path, url, branch):
    if not os.path.exists(path):
        try:
            CloneSource(path, url, branch)
        except Exception as e:
            print(e.stderr)
    else:
        try:
            ResetSource(path, branch)
        except Exception as e:
            print(e.stderr)

        try:
            PullSource(path)
        except Exception as e:
            print(e.stderr)

def DownloadSourceCode(name, type, patch):
    DownloadSource(f'{cwd}/source/{name}', 'git@github.com:noisiver/azerothcore.git', 'noisiver')
    if type == 1:
        DownloadSource(f'{cwd}/source/{name}/modules/mod-ah-bot', 'git@github.com:noisiver/mod-ah-bot.git', 'noisiver')
        DownloadSource(f'{cwd}/source/{name}/modules/mod-assistant', 'git@github.com:noisiver/mod-assistant.git', 'master')
        #DownloadSource(f'{cwd}/source/{name}/modules/mod-eluna', 'git@github.com:azerothcore/mod-eluna.git', 'master')
        DownloadSource(f'{cwd}/source/{name}/modules/mod-gamemaster', 'git@github.com:noisiver/mod-gamemaster.git', 'master')
        DownloadSource(f'{cwd}/source/{name}/modules/mod-junk-to-gold', 'git@github.com:noisiver/mod-junk-to-gold.git', 'master')
        DownloadSource(f'{cwd}/source/{name}/modules/mod-learnspells', 'git@github.com:noisiver/mod-learnspells.git', 'master')
        DownloadSource(f'{cwd}/source/{name}/modules/mod-playerbots', 'git@github.com:noisiver/mod-playerbots.git', 'noisiver')
        DownloadSource(f'{cwd}/source/{name}/modules/mod-stop-killing-them', 'git@github.com:noisiver/mod-stop-killing-them.git', 'master')
        DownloadSource(f'{cwd}/source/{name}/modules/mod-weekendbonus', 'git@github.com:noisiver/mod-weekendbonus.git', 'master')
        if patch >= 12:
            DownloadSource(f'{cwd}/source/{name}/modules/mod-appreciation', 'git@github.com:noisiver/mod-appreciation.git', 'master')
        if patch >= 17:
            DownloadSource(f'{cwd}/source/{name}/modules/mod-fixes', 'git@github.com:noisiver/mod-fixes.git', 'master')
            DownloadSource(f'{cwd}/source/{name}/modules/mod-recruitafriend', 'git@github.com:noisiver/mod-recruitafriend.git', 'master')
            DownloadSource(f'{cwd}/source/{name}/modules/mod-skip-dk-starting-area', 'git@github.com:azerothcore/mod-skip-dk-starting-area.git', 'master')

def GenerateProject(name, type):
    if type == 0:
        apps = 'auth-only'
    else:
        apps = 'world-only'

    args = [ f'-S {cwd}/source/{name}', f'-B {cwd}/source/{name}/build', '-DWITH_WARNINGS=0', '-DSCRIPTS=static', f'-DAPPS_BUILD={apps}', f'-DMYSQL_EXECUTABLE={windows_paths['mysql']}/bin/mysql.exe', f'-DMYSQL_INCLUDE_DIR={windows_paths['mysql']}/include', f'-DMYSQL_LIBRARY={windows_paths['mysql']}/lib/libmysql.lib' ]

    try:
        subprocess.run([f'{windows_paths['cmake']}/bin/cmake.exe', *args], check=True)
    except Exception as e:
        print(e.stderr)
        exit()

def BuildProject(name, type):
    args = [f'{cwd}/source/{name}/build/AzerothCore.sln', '/p:Configuration=RelWithDebInfo', '/p:WarningLevel=0']

    if type == 0:
        args.append('/target:authserver')
    else:
        args.append('/target:worldserver')

    try:
        subprocess.run([f'{windows_paths['msbuild']}/MSBuild.exe', *args], cwd=f'{cwd}/source/{name}/build', check=True)
    except Exception as e:
        print(e.stderr)
        exit()

def CopyBinaries(name, type):
    try:
        if not os.path.isdir(f'{cwd}/packaged/core/{name}'):
            os.makedirs(f'{cwd}/packaged/core/{name}', 0o666)
    except Exception as e:
        print(e.stderr)
        exit()

    if type == 0:
        filename = 'authserver'
    else:
        filename = 'worldserver'

    binaries = [
        f'{filename}.exe',
        f'{filename}.pdb'
    ]

    try:
        for binary in binaries:
            shutil.copyfile(f'{cwd}/source/{name}/build/bin/RelWithDebInfo/{binary}', f'{cwd}/packaged/core/{name}/{binary}')
    except Exception as e:
        print(e.stderr)
        exit()

def CopyLibraries(name):
    libraries = [
        [f'{windows_paths['openssl']}/bin', 'legacy.dll'],
        [f'{windows_paths['openssl']}/bin', 'libcrypto-3-x64.dll'],
        [f'{windows_paths['openssl']}/bin', 'libssl-3-x64.dll'],
        [f'{windows_paths['mysql']}/lib', 'libmysql.dll']
    ]

    try:
        for lib in libraries:
            shutil.copyfile(f'{lib[0]}/{lib[1]}', f'{cwd}/packaged/core/{name}/{lib[1]}')
    except Exception as e:
        print(e.stderr)
        exit()

def GenerateScript(name, type):
    if type == 0:
        filename = 'auth.bat'
        text = 'title auth\n@echo off\n:auth\n    authserver.exe\n    timeout 10\ngoto auth\n'
    else:
        filename = 'world.bat'
        text = f'title world{id}\n@echo off\n:world\n    worldserver.exe\n    echo %errorlevel%\n    pause\ngoto world\n'

    try:
        file = open(f'{cwd}/packaged/core/{name}/{filename}', 'w')
        file.write(text)
        file.close()
    except Exception as e:
        print(e.stderr)
        exit()

    try:
        f = Path(f'{cwd}/packaged/core/{name}/{filename}')
        f.chmod(f.stat().st_mode | stat.S_IEXEC)
    except Exception as e:
        print(e.stderr)
        exit()

def CopyDatabaseFiles(name, type, patch):
    directories = [
        'data/sql/archive/db_auth',
        'data/sql/base/db_auth',
        'data/sql/create',
        'data/sql/custom/db_auth',
        'data/sql/old/db_auth',
        'data/sql/updates/db_auth',
        'data/sql/updates/pending_db_auth',
    ]

    if type == 1:
        directories.append('data/sql/archive/db_characters')
        directories.append('data/sql/archive/db_world')
        directories.append('data/sql/base/db_characters')
        directories.append('data/sql/base/db_world')
        directories.append('data/sql/custom/db_characters')
        directories.append('data/sql/custom/db_world')
        directories.append('data/sql/old/db_characters')
        directories.append('data/sql/old/db_world')
        directories.append('data/sql/updates/db_characters')
        directories.append('data/sql/updates/db_world')
        directories.append('data/sql/updates/pending_db_characters')
        directories.append('data/sql/updates/pending_db_world')

    try:
        for directory in directories:
            if not os.path.isdir(f'{cwd}/packaged/source/{name}/{directory}'):
                os.makedirs(f'{cwd}/packaged/source/{name}/{directory}', 0o666)

            files = sorted(os.listdir(f'{cwd}/source/{name}/{directory}'))
            for file in files:
                if os.path.isfile(f'{cwd}/source/{name}/{directory}/{file}'):
                    if file.endswith('.sql'):
                        shutil.copyfile(f'{cwd}/source/{name}/{directory}/{file}', f'{cwd}/packaged/source/{name}/{directory}/{file}')

    except Exception as e:
        print(e.stderr)
        exit()

    if type == 1:
        directories = [
            [ 'modules/mod-ah-bot/data/sql/db-world', 'modules/mod-ah-bot/data/sql/world' ],
            [ 'modules/mod-assistant/data/sql/world', 'modules/mod-assistant/data/sql/world' ],
            [ 'modules/mod-playerbots/data/sql/characters', 'modules/mod-playerbots/data/sql/characters' ],
            [ 'modules/mod-playerbots/data/sql/playerbots/archive', 'modules/mod-playerbots/data/sql/playerbots/archive' ],
            [ 'modules/mod-playerbots/data/sql/playerbots/base', 'modules/mod-playerbots/data/sql/playerbots/base' ],
            [ 'modules/mod-playerbots/data/sql/playerbots/create', 'modules/mod-playerbots/data/sql/playerbots/create' ],
            [ 'modules/mod-playerbots/data/sql/playerbots/custom', 'modules/mod-playerbots/data/sql/playerbots/custom' ],
            [ 'modules/mod-playerbots/data/sql/playerbots/updates/db_playerbots', 'modules/mod-playerbots/data/sql/playerbots/updates/db_playerbots' ],
            [ 'modules/mod-playerbots/data/sql/world', 'modules/mod-playerbots/data/sql/world' ]
        ]

        if patch >= 12:
            directories.append([ 'modules/mod-appreciation/data/sql/world', 'modules/mod-appreciation/data/sql/world' ])

        if patch >= 17:
            directories.append([ 'modules/mod-fixes/data/sql/world', 'modules/mod-fixes/data/sql/world' ])
            directories.append([ 'modules/mod-recruitafriend/data/sql/auth', 'modules/mod-recruitafriend/data/sql/auth' ])
            directories.append([ 'modules/mod-skip-dk-starting-area/data/sql/db-world', 'modules/mod-skip-dk-starting-area/data/sql/world' ])

        try:
            for directory in directories:
                if not os.path.isdir(f'{cwd}/packaged/source/{name}/{directory[1]}'):
                    os.makedirs(f'{cwd}/packaged/source/{name}/{directory[1]}', 0o666)

                files = sorted(os.listdir(f'{cwd}/source/{name}/{directory[0]}'))
                for file in files:
                    if os.path.isfile(f'{cwd}/source/{name}/{directory[0]}/{file}'):
                        if file.endswith('.sql'):
                            shutil.copyfile(f'{cwd}/source/{name}/{directory[0]}/{file}', f'{cwd}/packaged/source/{name}/{directory[1]}/{file}')

        except Exception as e:
            print(e.stderr)
            exit()

    directories = [
        [ 'auth', 'data/sql/custom/db_auth' ],
        [ 'characters', '/data/sql/custom/db_characters' ],
        [ 'world', '/data/sql/custom/db_world' ]
    ]

    try:
        for directory in directories:
            if os.path.isdir(f'{cwd}/sql/{name}/{directory[0]}'):
                files = sorted(os.listdir(f'{cwd}/sql/{name}/{directory[0]}'))
                for file in files:
                    if os.path.isfile(f'{cwd}/sql/{name}/{directory[0]}/{file}'):
                        if file.endswith('.sql'):
                            shutil.copyfile(f'{cwd}/sql/{name}/{directory[0]}/{file}', f'{cwd}/packaged/source/{name}/{directory[1]}/{file}')
    except Exception as e:
        print(e.stderr)
        exit()

def UpdateConfig(path, replacements):
    with open(f'{path}.dist', encoding='utf-8') as file:
        lines = file.readlines()

    for count, line in enumerate(lines):
        for replacement in replacements:
            if line.startswith(replacement[0]):
                lines[count] = f'{replacement[1]}\n'

    with open(path, 'w', encoding='utf-8') as file:
        file.writelines(lines)

def UpdateConfigFiles(name, type, patch, id):
    try:
        if not os.path.isdir(f'{cwd}/packaged/core/{name}/configs'):
            os.makedirs(f'{cwd}/packaged/core/{name}/configs', 0o666)
    except Exception as e:
        print(e.stderr)
        exit()

    if type == 0:
        try:
            shutil.copyfile(f'{cwd}/source/{name}/build/bin/RelWithDebInfo/configs/authserver.conf.dist', f'{cwd}/packaged/core/{name}/configs/authserver.conf.dist')
        except Exception as e:
            print(e.stderr)
            exit()

        replacements = [
            [ 'LoginDatabaseInfo =', 'LoginDatabaseInfo = "127.0.0.1;3306;acore;acore;acore_auth"' ],
            [ 'SourceDirectory =', f'SourceDirectory = "../../source/{name}"' ],
            [ 'MySQLExecutable =', 'MySQLExecutable = "../../mysql/bin/mysql.exe"' ]
        ]
        UpdateConfig(f'{cwd}/packaged/core/{name}/configs/authserver.conf', replacements)
    else:
        try:
            if not os.path.isdir(f'{cwd}/packaged/core/{name}/configs/modules'):
                os.makedirs(f'{cwd}/packaged/core/{name}/configs/modules', 0o666)
        except Exception as e:
            print(e.stderr)
            exit()

        try:
            shutil.copyfile(f'{cwd}/source/{name}/build/bin/RelWithDebInfo/configs/worldserver.conf.dist', f'{cwd}/packaged/core/{name}/configs/worldserver.conf.dist')
        except Exception as e:
            print(e.stderr)
            exit()

        replacements = [
            ['RealmID =', f'RealmID = {id}'],
            ['WorldServerPort =', f'WorldServerPort = {49274+id}'],
            ['LoginDatabaseInfo     =', 'LoginDatabaseInfo     ="127.0.0.1;3306;acore;acore;acore_auth"'],
            ['WorldDatabaseInfo     =', f'WorldDatabaseInfo     ="127.0.0.1;3306;acore;acore;acore_world_{id}"'],
            ['CharacterDatabaseInfo = ', f'CharacterDatabaseInfo = "127.0.0.1;3306;acore;acore;acore_characters_{id}"'],
            ['DataDir =', 'DataDir = "../../data"'],
            ['SourceDirectory =', f'SourceDirectory = "../../source/{name}"'],
            ['MySQLExecutable =', 'MySQLExecutable = "../../mysql/bin/mysql.exe"'],
            ['GameType =', 'GameType = 0'],
            ['RealmZone =', 'RealmZone = 8'],
            ['MinWorldUpdateTime =', 'MinWorldUpdateTime = 10'],
            ['MapUpdateInterval =', 'MapUpdateInterval = 100'],
            ['MapUpdate.Threads =', 'MapUpdate.Threads = 4'],
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
            ['Warden.Enabled =', 'Warden.Enabled = 1'],
            ['FlashAtStart =', 'FlashAtStart = 0'],
            ['Progression.Patch =', f'Progression.Patch = {patch}'],
            ['Progression.IcecrownCitadel.Aura =', 'Progression.IcecrownCitadel.Aura = 0'],
            ['Progression.Level.Enforced =', 'Progression.Level.Enforced = 1'],
            ['Progression.DungeonFinder.Enforced =', 'Progression.DungeonFinder.Enforced = 0'],
            ['Progression.DualTalent.Enforced =', 'Progression.DualTalent.Enforced = 0' ],
            ['Progression.QuestInfo.Enforced =', 'Progression.QuestInfo.Enforced = 0' ],
            ['Progression.Multiplier.Damage =', 'Progression.Multiplier.Damage = 0.6'],
            ['Progression.Multiplier.Healing =', 'Progression.Multiplier.Healing = 0.5'],
            ['Progression.PatchNotes.Enabled =', 'Progression.PatchNotes.Enabled = 1']
        ]
        UpdateConfig(f'{cwd}/packaged/core/{name}/configs/worldserver.conf', replacements)

        try:
            shutil.copyfile(f'{cwd}/source/{name}/build/bin/RelWithDebInfo/configs/modules/mod_ahbot.conf.dist', f'{cwd}/packaged/core/{name}/configs/modules/mod_ahbot.conf.dist')
        except Exception as e:
            print(e.stderr)
            exit()

        replacements = [
            ['AuctionHouseBot.EnableSeller =', 'AuctionHouseBot.EnableSeller = 1'],
            ['AuctionHouseBot.EnableBuyer =', 'AuctionHouseBot.EnableBuyer = 1'],
            ['AuctionHouseBot.Account =', 'AuctionHouseBot.Account = 1'],
            ['AuctionHouseBot.GUID =', 'AuctionHouseBot.GUID = 1'],
            ['AuctionHouseBot.ItemsPerCycle =', 'AuctionHouseBot.ItemsPerCycle = 200']
        ]
        UpdateConfig(f'{cwd}/packaged/core/{name}/configs/modules/mod_ahbot.conf', replacements)

        try:
            shutil.copyfile(f'{cwd}/source/{name}/build/bin/RelWithDebInfo/configs/modules/mod_assistant.conf.dist', f'{cwd}/packaged/core/{name}/configs/modules/mod_assistant.conf.dist')
        except Exception as e:
            print(e.stderr)
            exit()

        replacements = [
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
        UpdateConfig(f'{cwd}/packaged/core/{name}/configs/modules/mod_assistant.conf', replacements)

        try:
            shutil.copyfile(f'{cwd}/source/{name}/build/bin/RelWithDebInfo/configs/modules/mod_learnspells.conf.dist', f'{cwd}/packaged/core/{name}/configs/modules/mod_learnspells.conf.dist')
        except Exception as e:
            print(e.stderr)
            exit()

        replacements = [
            ['LearnSpells.Gamemasters =', 'LearnSpells.Gamemasters = 1'],
            ['LearnSpells.Riding.Apprentice =', f'LearnSpells.Riding.Apprentice = {'0' if patch < 17 else '1'}'],
            ['LearnSpells.Riding.Journeyman =', f'LearnSpells.Riding.Journeyman = {'0' if patch < 17 else '1'}'],
            ['LearnSpells.Riding.Expert =', f'LearnSpells.Riding.Expert = {'0' if patch < 17 else '1'}']
        ]
        UpdateConfig(f'{cwd}/packaged/core/{name}/configs/modules/mod_learnspells.conf', replacements)

        try:
            shutil.copyfile(f'{cwd}/source/{name}/build/bin/RelWithDebInfo/configs/modules/playerbots.conf.dist', f'{cwd}/packaged/core/{name}/configs/modules/playerbots.conf.dist')
        except Exception as e:
            print(e.stderr)
            exit()

        if patch < 12:
            bot_starting_level = 50
            bot_maps = '0,1'
        elif patch < 17:
            bot_starting_level = 60
            bot_maps = '0,1,530'
        else:
            bot_starting_level = 70
            bot_maps = '0,1,530,571'

        replacements = [
            ['AiPlayerbot.RandomBotAccountCount =', 'AiPlayerbot.RandomBotAccountCount = 0'],
            ['AiPlayerbot.MinRandomBots =', 'AiPlayerbot.MinRandomBots = 0'],
            ['AiPlayerbot.MaxRandomBots =', 'AiPlayerbot.MaxRandomBots = 0'],
            ['AiPlayerbot.AllowPlayerBots =', 'AiPlayerbot.AllowPlayerBots = 1'],
            ['AiPlayerbot.SelfBotLevel =', 'AiPlayerbot.SelfBotLevel = 2'],
            ['AiPlayerbot.SayWhenCollectingItems =', 'AiPlayerbot.SayWhenCollectingItems = 0'],
            ['AiPlayerbot.TellWhenAvoidAoe =', 'AiPlayerbot.TellWhenAvoidAoe = 0'],
            ['AiPlayerbot.AutoGearQualityLimit =', 'AiPlayerbot.AutoGearQualityLimit = 5'],
            ['AiPlayerbot.DisableDeathKnightLogin =', f'AiPlayerbot.DisableDeathKnightLogin = {'1' if patch < 17 else '0'}'],
            ['AiPlayerbot.DisableRandomLevels =', 'AiPlayerbot.DisableRandomLevels = 1'],
            ['AiPlayerbot.RandombotStartingLevel =', f'AiPlayerbot.RandombotStartingLevel = {bot_starting_level}'],
            ['AiPlayerbot.RandomGearQualityLimit =', 'AiPlayerbot.RandomGearQualityLimit = 5'],
            ['AiPlayerbot.RandomBotGroupNearby =', 'AiPlayerbot.RandomBotGroupNearby = 1'],
            ['AiPlayerbot.RandomBotMaps =', f'AiPlayerbot.RandomBotMaps = {bot_maps}'],
            ['PlayerbotsDatabaseInfo =', f'PlayerbotsDatabaseInfo = "127.0.0.1;3306;acore;acore;acore_playerbots_{id}"'],
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
            ['AiPlayerbot.BotActiveAlone =', 'AiPlayerbot.BotActiveAlone = 100'],
            ['AiPlayerbot.botActiveAloneSmartScale =', 'AiPlayerbot.botActiveAloneSmartScale = 1'],
            ['AiPlayerbot.AutoAvoidAoe =', 'AiPlayerbot.AutoAvoidAoe = 1'],
            ['AiPlayerbot.CommandServerPort =', 'AiPlayerbot.CommandServerPort = 0'],
            ['AiPlayerbot.RandomBotArenaTeam2v2Count =', f'AiPlayerbot.RandomBotArenaTeam2v2Count = {'0' if patch < 12 else '15'}'],
            ['AiPlayerbot.RandomBotArenaTeam3v3Count =', f'AiPlayerbot.RandomBotArenaTeam3v3Count = {'0' if patch < 12 else '15'}'],
            ['AiPlayerbot.RandomBotArenaTeam5v5Count =', f'AiPlayerbot.RandomBotArenaTeam5v5Count = {'0' if patch < 12 else '25'}'],
            ['AiPlayerbot.KillXPRate =', 'AiPlayerbot.KillXPRate = 1'],
            ['AiPlayerbot.AutoEquipUpgradeLoot =', 'AiPlayerbot.AutoEquipUpgradeLoot = 0'],
            ['AiPlayerbot.FreeFood =', 'AiPlayerbot.FreeFood = 0'],
            ['AiPlayerbot.AutoPickReward =', 'AiPlayerbot.AutoPickReward = no'],
            ['AiPlayerbot.AutoTrainSpells =', 'AiPlayerbot.AutoTrainSpells = no'],
            ['AiPlayerbot.EnableNewRpgStrategy =', 'AiPlayerbot.EnableNewRpgStrategy = 1']
        ]
        UpdateConfig(f'{cwd}/packaged/core/{name}/configs/modules/playerbots.conf', replacements)

        try:
            shutil.copyfile(f'{cwd}/source/{name}/build/bin/RelWithDebInfo/configs/modules/mod_weekendbonus.conf.dist', f'{cwd}/packaged/core/{name}/configs/modules/mod_weekendbonus.conf.dist')
        except Exception as e:
            print(e.stderr)
            exit()

        try:
            shutil.copyfile(f'{cwd}/packaged/core/{name}/configs/modules/mod_weekendbonus.conf.dist', f'{cwd}/packaged/core/{name}/configs/modules/mod_weekendbonus.conf')
        except Exception as e:
            print(e.stderr)
            exit()

        if patch >= 12:
            try:
                shutil.copyfile(f'{cwd}/source/{name}/build/bin/RelWithDebInfo/configs/modules/mod_appreciation.conf.dist', f'{cwd}/packaged/core/{name}/configs/modules/mod_appreciation.conf.dist')
            except Exception as e:
                print(e.stderr)
                exit()

            replacements = [
                ['Appreciation.RequireCertificate.Enabled =', 'Appreciation.RequireCertificate.Enabled = 0'],
                ['Appreciation.LevelBoost.TargetLevel =', f'Appreciation.LevelBoost.TargetLevel = {'60' if patch < 17 else '70'}'],
                ['Appreciation.LevelBoost.IncludedCopper =', f'Appreciation.LevelBoost.IncludedCopper = {'5000000' if patch < 17 else '10000000'}'],
                ['Appreciation.UnlockContinents.Enabled =', f'Appreciation.UnlockContinents.Enabled = {'0' if patch < 12 else '1'}'],
                ['Appreciation.UnlockContinents.EasternKingdoms.Enabled =', f'Appreciation.UnlockContinents.EasternKingdoms.Enabled = {'0' if patch < 12 else '1'}'],
                ['Appreciation.UnlockContinents.Kalimdor.Enabled =', f'Appreciation.UnlockContinents.Kalimdor.Enabled = {'0' if patch < 12 else '1'}'],
                ['Appreciation.UnlockContinents.Outland.Enabled =', f'Appreciation.UnlockContinents.Outland.Enabled = {'0' if patch < 17 else '1'}']
            ]
            UpdateConfig(f'{cwd}/packaged/core/{name}/configs/modules/mod_appreciation.conf', replacements)

        if patch >= 17:
            try:
                shutil.copyfile(f'{cwd}/source/{name}/build/bin/RelWithDebInfo/configs/modules/mod_recruitafriend.conf.dist', f'{cwd}/packaged/core/{name}/configs/modules/mod_recruitafriend.conf.dist')
            except Exception as e:
                print(e.stderr)
                exit()

            replacements = [
                ['RecruitAFriend.Duration =', 'RecruitAFriend.Duration = 0'],
                ['RecruitAFriend.MaxAccountAge =', 'RecruitAFriend.MaxAccountAge = 0']
            ]
            UpdateConfig(f'{cwd}/packaged/core/{name}/configs/modules/mod_recruitafriend.conf', replacements)

            try:
                shutil.copyfile(f'{cwd}/source/{name}/build/bin/RelWithDebInfo/configs/modules/skip_dk_module.conf.dist', f'{cwd}/packaged/core/{name}/configs/modules/skip_dk_module.conf.dist')
            except Exception as e:
                print(e.stderr)
                exit()

            replacements = [
                ['Skip.Deathknight.Starter.Announce.enable =', 'Skip.Deathknight.Starter.Announce.enable = 0'],
            ]
            UpdateConfig(f'{cwd}/packaged/core/{name}/configs/modules/skip_dk_module.conf', replacements)

def GetLocalDataVersion():
    version = 0
    data_file = f'{cwd}/data/data.version'
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

def DeleteClientData():
    data_dir = f'{cwd}/data'
    dirs = [ 'Cameras', 'dbc', 'maps', 'mmaps', 'vmaps' ]
    for dir in dirs:
        if os.path.exists(f'{data_dir}/{dir}'):
            shutil.rmtree(f'{data_dir}/{dir}')

def DownloadClientData(version):
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
    shutil.unpack_archive(f'{cwd}/data.zip', f'{cwd}/data')

def UpdateDataVersion(version):
    file = open(f'{cwd}/data/data.version', 'w')
    file.write(version)
    file.close()

def GetClientData():
    local_version = GetLocalDataVersion()
    remote_version = GetRemoteDataVersion()

    if local_version != remote_version:
        DeleteClientData()
        DownloadClientData(remote_version)
        UnpackDataFiles()
        UpdateDataVersion(remote_version)

    if os.path.exists(f'{cwd}/data.zip'):
        os.remove(f'{cwd}/data.zip')

if os.path.exists(f'{cwd}/packaged'):
    shutil.rmtree(f'{cwd}/packaged')

for core in cores:
    name = core[0]
    type = core[1]
    patch = core[2]
    id = core[3]

    DownloadSourceCode(name, type, patch)
    GenerateProject(name, type)
    BuildProject(name, type)
    CopyBinaries(name, type)
    CopyLibraries(name)
    GenerateScript(name, type)
    CopyDatabaseFiles(name, type, patch)
    UpdateConfigFiles(name, type, patch, id)
    GetClientData()
