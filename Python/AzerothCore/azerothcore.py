# wget https://repo.mysql.com/mysql-apt-config_0.8.39-1_all.deb
# dpkg -i mysql-apt-config_0.8.39-1_all.deb
# apt update && apt install -y mysql-server

# apt-get install --yes screen cmake make gcc clang g++ libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost1.83-all-dev libmysqlclient-dev mysql-client python3-colorama python3-git python3-pymysql python3-requests python3-tqdm

from pathlib import Path
from tqdm import tqdm
from zipfile import ZipFile
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

options = {
    'build': {
        'auth': True,
        'world': True,
        'type': 'Release'
    },
    'azerothcore': {
        'branch': 'master',
        'repository': 'azerothcore/azerothcore-wotlk',
        'use_ssh': False,
        'config': {
            'realm_id': 1,
            'realm_port': 8085,
            'realm_name': 'AzerothCore',
            'realm_address': '127.0.0.1',
            'map_update_threads': 0,
            'visibility': {
                'continents': 100,
                'instances': 170,
                'battlegrounds': 250
            }
        }
    },
    'modules': {
        'mod-dungeon-clear': {
            'enabled': False,
            'branch': 'master',
            'repository': 'jrad7/mod-dungeon-clear',
            'use_ssh': False
        },
        'mod-dungeoneer': {
            'enabled': False,
            'branch': 'master',
            'repository': 'noisiver/mod-dungeoneer',
            'use_ssh': True
        },
        'mod-gamemaster': {
            'enabled': False,
            'branch': 'master',
            'repository': 'noisiver/mod-gamemaster',
            'use_ssh': True
        },
        'mod-junk-to-gold': {
            'enabled': False,
            'branch': 'master',
            'repository': 'noisiver/mod-junk-to-gold',
            'use_ssh': False
        },
        'mod-learnspells': {
            'enabled': False,
            'branch': 'master',
            'repository': 'noisiver/mod-learnspells',
            'use_ssh': True,
            'config': {
                'apprentice_riding_level': 20,
                'journeyman_riding_level': 40
            }
        },
        'mod-playerbots': {
            'enabled': False,
            'branch': 'master',
            'repository': 'mod-playerbots/mod-playerbots',
            'use_ssh': False,
            'config': {
                'min_random_bots': 500,
                'max_random_bots': 500,
                'active_alone': 100
            }
        },
        'mod-progression': {
            'enabled': False,
            'branch': 'master',
            'repository': 'noisiver/mod-progression',
            'use_ssh': False,
            'config': {
                'phase_id': 18
            }
        },
        'mod-quest-catchup': {
            'enabled': False,
            'branch': 'main',
            'repository': 'Jellypowered/mod-quest-catchup',
            'use_ssh': False
        },
        'mod-skip-dk-starting-area': {
            'enabled': False,
            'branch': 'master',
            'repository': 'azerothcore/mod-skip-dk-starting-area',
            'use_ssh': False
        },
        'mod-weekendbonus': {
            'enabled': False,
            'branch': 'master',
            'repository': 'noisiver/mod-weekendbonus',
            'use_ssh': False
        }
    },
    'mysql': {
        'hostname': '127.0.0.1',
        'port': 3306,
        'username': 'acore',
        'password': 'acore',
        'database': {
            'auth': 'acore_auth',
            'characters': 'acore_characters',
            'world': 'acore_world',
            'playerbots': 'acore_playerbots'
        }
    }
}

cwd = os.getcwd()

build_auth = options['build']['auth']
build_world = options['build']['world']
build_type = options['build']['type']
build_apps = 'all' if build_auth and build_world else 'auth-only' if build_auth else 'world-only'

if not build_auth and not build_world:
    print(f'{colorama.Fore.RED}Stopping due to both auth and world being disabled{colorama.Style.RESET_ALL}')
    sys.exit(1)

module_options = options['modules']
progression_enabled = module_options['mod-progression']['enabled']
progression_phase_id = module_options['mod-progression']['config']['phase_id']
playerbots_enabled = module_options['mod-playerbots']['enabled']
skip_dk_starting_area_enabled = module_options['mod-skip-dk-starting-area']['enabled']

src_dir = os.path.join(cwd, 'src')
build_dir = os.path.join(src_dir, 'build')
install_dir = cwd
bin_dir = os.path.join(install_dir, 'bin')
data_dir = os.path.join(cwd, 'data')
custom_dir = os.path.join(cwd, 'custom')
sql_dir = os.path.join(custom_dir, 'sql')
dbc_dir = os.path.join(custom_dir, 'dbc')

world_options = options['azerothcore']['config']
world_realm_id = world_options['realm_id']
world_realm_port = world_options['realm_port']
world_realm_name = world_options['realm_name']
world_realm_address = world_options['realm_address']

mysql_hostname = options['mysql']['hostname']
mysql_port = options['mysql']['port']
mysql_username = options['mysql']['username']
mysql_password = options['mysql']['password']
mysql_database_auth = options['mysql']['database']['auth']
mysql_database_characters = options['mysql']['database']['characters']
mysql_database_world = options['mysql']['database']['world']
mysql_database_playerbots = options['mysql']['database']['playerbots']

not os.path.exists(os.path.join(sql_dir, 'auth')) and os.makedirs(os.path.join(sql_dir, 'auth'), exist_ok=True)
build_world and not os.path.exists(os.path.join(sql_dir, 'characters')) and os.makedirs(os.path.join(sql_dir, 'characters'), exist_ok=True)
build_world and not os.path.exists(os.path.join(sql_dir, 'world')) and os.makedirs(os.path.join(sql_dir, 'world'), exist_ok=True)
build_world and not os.path.exists(dbc_dir) and os.makedirs(dbc_dir, exist_ok=True)

class GitProgress(git.remote.RemoteProgress):
    def line_dropped(self, line): print(line)
    def update(self, *args): print(self._cur_line)

def DownloadOrUpdateSourceCode(name, path, branch, repository, use_ssh):
    if not os.path.exists(path):
        try:
            print(f'{colorama.Fore.YELLOW}Downloading the source code for {name}{colorama.Style.RESET_ALL}')
            git.Repo.clone_from(url=f'git@github.com:{repository}' if use_ssh else f'https://github.com/{repository}.git', to_path=path, branch=branch, depth=1, single_branch=True, progress=GitProgress())
        except:
            print(f'{colorama.Fore.RED}Failed to download the source code for {name}{colorama.Style.RESET_ALL}')
            sys.exit(1)
    else:
        try:
            print(f'{colorama.Fore.YELLOW}Updating the source code for {name}{colorama.Style.RESET_ALL}')
            git.Repo(path).git.reset('--hard', f'origin/{branch}')
            git.Repo(path).remotes.origin.pull(progress=GitProgress())
        except:
            print(f'{colorama.Fore.RED}Failed to update the source code for {name}{colorama.Style.RESET_ALL}')
            sys.exit(1)

def DownloadSourceCode():
    print(f'{colorama.Fore.GREEN}Downloading source code...{colorama.Style.RESET_ALL}')

    ac_branch = options['azerothcore']['branch']
    ac_repository = options['azerothcore']['repository']
    ac_use_ssh = options['azerothcore']['use_ssh']

    DownloadOrUpdateSourceCode('azerothcore', src_dir, ac_branch, ac_repository, ac_use_ssh)

    for module_name, module_options in options['modules'].items():
        module_enabled = module_options['enabled']
        module_path = os.path.join(src_dir, 'modules', module_name)
        module_branch = module_options['branch']
        module_repository = module_options['repository']
        module_use_ssh = module_options['use_ssh']

        if not module_enabled or not build_world:
            if os.path.exists(module_path):
                print(f'{colorama.Fore.YELLOW}Removing the source code for {module_name}{colorama.Style.RESET_ALL}')
                shutil.rmtree(module_path, ignore_errors=True)
            continue

        DownloadOrUpdateSourceCode(module_name, module_path, module_branch, module_repository, module_use_ssh)

    print(f'{colorama.Fore.GREEN}Finished downloading source code...{colorama.Style.RESET_ALL}')

def GenerateProject():
    print(f'{colorama.Fore.GREEN}Generating project files...{colorama.Style.RESET_ALL}')
    args = [
        '-S',
        src_dir,
        '-B',
        build_dir,
        '-DWITH_WARNINGS=0',
        '-DSCRIPTS=static',
        f'-DAPPS_BUILD={build_apps}',
        f'-DCMAKE_BUILD_TYPE={build_type}',
        f'-DCMAKE_INSTALL_PREFIX={install_dir}',
        '-DCMAKE_C_COMPILER=/usr/bin/clang',
        '-DCMAKE_CXX_COMPILER=/usr/bin/clang++',
        '-DCMAKE_CXX_FLAGS="-w"'
    ]

    try:
        subprocess.run(['cmake', *args], check=True)
    except:
        print(f'{colorama.Fore.RED}Failed to generate the project files{colorama.Style.RESET_ALL}')
        sys.exit(1)

    print(f'{colorama.Fore.GREEN}Finished generating project files...{colorama.Style.RESET_ALL}')

def CompileSourceCode():
    print(f'{colorama.Fore.GREEN}Compiling the source code...{colorama.Style.RESET_ALL}')

    for attempt in range(2):
        try:
            subprocess.run(['make', '-j', str(multiprocessing.cpu_count()), 'install'], cwd=build_dir, check=True)
            break
        except:
            if attempt == 0:
                try:
                    subprocess.run(['make', 'clean'], cwd=build_dir, check=True)
                except:
                    print(f'{colorama.Fore.RED}Failed to clean the source code{colorama.Style.RESET_ALL}')
                    sys.exit(1)
            else:
                print(f'{colorama.Fore.RED}Failed to compile the source code{colorama.Style.RESET_ALL}')
                sys.exit(1)

    print(f'{colorama.Fore.GREEN}Finished compiling the source code...{colorama.Style.RESET_ALL}')

def CreateRequiredScripts():
    print(f'{colorama.Fore.GREEN}Creating required scripts...{colorama.Style.RESET_ALL}')

    scripts = [
        [
            'auth.sh', build_auth,
            '#!/bin/bash\nwhile :; do\n    ./authserver\ndone\n'
        ],
        [
            'world.sh', build_world,
            '#!/bin/bash\nwhile :; do\n    ./worldserver\n    [[ $? == 0 ]] && break\ndone\n'
        ],
        [
            'start.sh', True,
            f'#!/bin/bash\n{'screen -AmdS auth ./auth.sh\n' if build_auth else ''}{f'time=$(date +%s)\nscreen -L -Logfile $time.log -AmdS world-{world_realm_id} ./world.sh\n' if build_world else ''}'
        ],
        [
            'stop.sh', True,
            f'#!/bin/bash\n{'screen -X -S auth quit\n' if build_auth else ''}{f'screen -X -S world-{world_realm_id} quit\n' if build_world else ''}'
        ]
            
    ]

    for name, enabled, content in scripts:
        script_path = os.path.join(bin_dir, name)

        if not enabled:
            if os.path.exists(script_path):
                print(f'{colorama.Fore.YELLOW}Removing {name}{colorama.Style.RESET_ALL}')
                os.remove(script_path)
            continue

        print(f'{colorama.Fore.YELLOW}Creating {name}{colorama.Style.RESET_ALL}')

        try:
            with open(script_path, 'w') as f:
                f.write(content)
            Path(script_path).chmod(Path(script_path).stat().st_mode | stat.S_IEXEC)
        except:
            print(f'{colorama.Fore.RED}Failed to create {name}{colorama.Style.RESET_ALL}')
            sys.exit(1)

    print(f'{colorama.Fore.GREEN}Finished creating required scripts...{colorama.Style.RESET_ALL}')

def UpdateConfigs():
    print(f'{colorama.Fore.GREEN}Updating config files...{colorama.Style.RESET_ALL}')

    world_map_update_threads = world_options['map_update_threads']
    world_visibility_continents = world_options['visibility']['continents']
    world_visibility_instances = world_options['visibility']['instances']
    world_visibility_battlegrounds = world_options['visibility']['battlegrounds']

    dungeon_clear_enabled = module_options['mod-dungeon-clear']['enabled']

    learnspells_enabled = module_options['mod-learnspells']['enabled']
    apprentice_riding_level = module_options['mod-learnspells']['config']['apprentice_riding_level']
    journeyman_riding_level = module_options['mod-learnspells']['config']['journeyman_riding_level']

    weekendbonus_enabled = module_options['mod-weekendbonus']['enabled']

    min_random_bots = module_options['mod-playerbots']['config']['min_random_bots']
    max_random_bots = module_options['mod-playerbots']['config']['max_random_bots']
    item_quality_limit = 2 if progression_phase_id == 0 or progression_phase_id == 7 or progression_phase_id == 13 else 3 if progression_phase_id == 1 or progression_phase_id == 8 or progression_phase_id == 14 else 4
    item_level_limit = 58 if progression_phase_id < 3 else 66 if progression_phase_id < 5 else 76 if progression_phase_id < 7 else 110 if progression_phase_id < 8 else 115 if progression_phase_id < 9 else 120 if progression_phase_id < 10 else 125 if progression_phase_id < 11 else 130 if progression_phase_id < 12 else 135 if progression_phase_id < 13 else 174 if progression_phase_id < 14 else 187 if progression_phase_id < 15 else 213 if progression_phase_id < 16 else 226 if progression_phase_id < 17 else 245 if progression_phase_id < 18 else 0
    bot_active_alone = module_options['mod-playerbots']['config']['active_alone']

    config = {
        'authserver.conf': {
            'enabled': build_auth,
            'options': {
                'LoginDatabaseInfo': f'"{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{mysql_database_auth}"',
                'Updates.EnableDatabases': 0
            }
        },
        'worldserver.conf': {
            'enabled': build_world,
            'options': {
                'RealmID': world_realm_id,
                'WorldServerPort': world_realm_port,
                'LoginDatabaseInfo': f'"{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{mysql_database_auth}"',
                'WorldDatabaseInfo': f'"{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{mysql_database_world}"',
                'CharacterDatabaseInfo': f'"{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{mysql_database_characters}"',
                'DataDir': f'"{data_dir}"',
                'Updates.EnableDatabases': 0,
                'RealmZone': 8,
                'Visibility.Distance.Continents': world_visibility_continents,
                'Visibility.Distance.Instances': world_visibility_instances,
                'Visibility.Distance.BGArenas': world_visibility_battlegrounds,
                'MapUpdate.Threads': multiprocessing.cpu_count() if world_map_update_threads == -1 or world_map_update_threads == 0 else world_map_update_threads,
                'GM.LoginState': 1,
                'GM.Visible': 0,
                'GM.Chat': 1,
                'GM.WhisperingTo': 0,
                'GM.InGMList.Level': 1,
                'GM.InWhoList.Level': 0,
                'StrictPlayerNames': 3,
                'StrictPetNames': 3,
                'HeroicCharactersPerRealm': 10,
                'CharacterCreating.MinLevelForHeroicCharacter': 0,
                'DBC.EnforceItemAttributes': 0,
                'Quests.IgnoreRaid': 1,
                'Quests.IgnoreAutoAccept': 1,
                'DungeonFinder.CastDeserter': 0,
                'StrictCharterNames': 3,
                'Battleground.CastDeserter': 0,
                'StrictChannelNames': 3,
                'Minigob.Manabonk.Enable': 0,
                'Daze.Enabled': 0,
                'InfiniteAmmo.Enabled': 1
            }
        },
        'modules/mod_dungeon_clear.conf': {
            'enabled': build_world and dungeon_clear_enabled,
            'options': {}
        },
        'modules/mod_learnspells.conf': {
            'enabled': build_world and learnspells_enabled,
            'options': {
                'LearnSpells.Gamemasters.Enabled': 1,
                'LearnSpells.Riding.Apprentice.Enabled': 1,
                'LearnSpells.Riding.Apprentice.RequiredLevel': apprentice_riding_level,
                'LearnSpells.Riding.Journeyman.Enabled': 1,
                'LearnSpells.Riding.Journeyman.RequiredLevel': journeyman_riding_level,
                'LearnSpells.Riding.Expert.Enabled': 0 if progression_phase_id < 7 else 1,
                'LearnSpells.Riding.Artisan.Enabled': 0 if progression_phase_id < 13 else 1,
                'LearnSpells.Riding.ColdWeatherFlying.Enabled': 0 if progression_phase_id < 13 else 1,
                'LearnSpells.Riding.ColdWeatherFlying.RequiredLevel': 68
            }
        },
        'modules/mod_progression.conf': {
            'enabled': build_world and progression_enabled,
            'options': {
                'Progression.Phase': progression_phase_id,
                'Progression.QuestInfo.Enforced': 0,
                'Progression.DualTalent.Enforced': 0,
                'Progression.TradableBindsOnPickup.Enforced': 0,
                'Progression.DungeonFinder.Enforced': 0,
                'Progression.Multiplier.Healing': '1.0'
            }
        },
        'modules/mod_weekendbonus.conf': {
            'enabled': build_world and weekendbonus_enabled,
            'options': {}
        },
        'modules/playerbots.conf': {
            'enabled': build_world and playerbots_enabled,
            'options': {
                'AiPlayerbot.MinRandomBots': min_random_bots,
                'AiPlayerbot.MaxRandomBots': max_random_bots,
                'AiPlayerbot.RandomBotAccountCount': int(max_random_bots / (9 if progression_phase_id < 13 else 10) + 1) if min_random_bots > 0 else 0,
                'AiPlayerbot.AddClassAccountPoolSize': 0,
                'AiPlayerbot.AddClassCommand': 0,
                'AiPlayerbot.SelfBotLevel': 2,
                'AiPlayerbot.UseGroundMountAtMinLevel': apprentice_riding_level,
                'AiPlayerbot.UseFastGroundMountAtMinLevel': journeyman_riding_level,
                'AiPlayerbot.TellWhenMissingBuffReagents': 0,
                'AiPlayerbot.AltMaintenanceAmmo': 0,
                'AiPlayerbot.AltMaintenanceFood': 0,
                'AiPlayerbot.AltMaintenanceReagents': 0,
                'AiPlayerbot.AltMaintenanceConsumables': 1,
                'AiPlayerbot.AltMaintenancePotions': 1,
                'AiPlayerbot.AltMaintenanceBags': 0,
                'AiPlayerbot.AltMaintenanceMounts': 0,
                'AiPlayerbot.AltMaintenanceSkills': 0,
                'AiPlayerbot.AltMaintenanceClassSpells': 0,
                'AiPlayerbot.AltMaintenanceAvailableSpells': 0,
                'AiPlayerbot.AltMaintenanceSpecialSpells': 0,
                'AiPlayerbot.AltMaintenanceTalentTree': 1,
                'AiPlayerbot.AltMaintenanceGlyphs': 1,
                'AiPlayerbot.AltMaintenanceGemsEnchants': 1,
                'AiPlayerbot.AltMaintenancePet': 1,
                'AiPlayerbot.AltMaintenancePetTalents': 1,
                'AiPlayerbot.AltMaintenanceReputation': 0,
                'AiPlayerbot.AltMaintenanceAttunementQuests': 0,
                'AiPlayerbot.AltMaintenanceKeyring': 0,
                'AiPlayerbot.AutoGearQualityLimit': item_quality_limit,
                'AiPlayerbot.AutoGearScoreLimit': item_level_limit,
                'AiPlayerbot.RandomBotMinLevel': 1,
                'AiPlayerbot.RandomBotMaxLevel': 60 if progression_phase_id < 7 else 70 if progression_phase_id < 13 else 80,
                'AiPlayerbot.DisableDeathKnightLogin': 0 if progression_phase_id < 13 else 1,
                'AiPlayerbot.DisableRandomLevels': 1,
                'AiPlayerbot.RandombotStartingLevel': 60 if progression_phase_id < 7 else 70 if progression_phase_id < 13 else 80,
                'AiPlayerbot.RandomGearQualityLimit': item_quality_limit,
                'AiPlayerbot.RandomGearScoreLimit': item_level_limit,
                'AiPlayerbot.PreferClassArmorType': 1,
                'AiPlayerbot.PreferredSpecWeapons': 1,
                'AiPlayerbot.HunterWolfPet': 1,
                'AiPlayerbot.BotActiveAlone': bot_active_alone,
                'AiPlayerbot.botActiveAloneSmartScale': 0,
                'AiPlayerbot.AutoLearnQuestSpells': 0 if learnspells_enabled else 1,
                'AiPlayerbot.AutoLearnTrainerSpells': 0 if learnspells_enabled else 1,
                'AiPlayerbot.RandomBotMaps': '0,1' if progression_phase_id < 7 else '0,1,530' if progression_phase_id < 13 else '0,1,530,571',
                'AiPlayerbot.WorldBuffMatrix': '# WARRIOR ARMS 1:0,1,0,80,80:53760,57358; # WARRIOR FURY 2:0,1,1,80,80:53760,57358; # WARRIOR PROTECTION 3:0,1,2,80,80:53758,57356; # PALADIN HOLY 4:0,2,0,80,80:53749,57332,60347; # PALADIN PROTECTION 5:0,2,1,80,80:53758,57356; # PALADIN RETRIBUTION 6:0,2,2,80,80:53760,57371; # HUNTER BEAST 7:0,3,0,80,80:53760,57325; # HUNTER MARKSMANSHIP 8:0,3,1,80,80:53760,57358; # HUNTER SURVIVAL 9:0,3,2,80,80:53760,57367; # ROGUE ASSASSINATION 10:0,4,0,80,80:53760,57325; # ROGUE COMBAT 11:0,4,1,80,80:53760,57358; # ROGUE SUBTLETY 12:0,4,2,80,80:53760,57367; # PRIEST DISCIPLINE 13:0,5,0,80,80:53755,57327; # PRIEST HOLY 14:0,5,1,80,80:53755,57327; # PRIEST SHADOW 15:0,5,2,80,80:53755,57327; # DEATH KNIGHT BLOOD 16:0,6,0,80,80:53758,57356; # DEATH KNIGHT FROST 17:0,6,1,80,80:53760,57358; # DEATH KNIGHT UNHOLY 18:0,6,2,80,80:53760,57358; # DEATH KNIGHT BLOOD DPS 19:0,6,3,80,80:53760,57371; # SHAMAN ELEMENTAL 20:0,7,0,80,80:53755,57327; # SHAMAN ENHANCEMENT 21:0,7,1,80,80:53760,57325; # SHAMAN RESTORATION 22:0,7,2,80,80:53755,57327; # MAGE ARCANE 23:0,8,0,80,80:53755,57327; # MAGE FIRE 24:0,8,1,80,80:53755,57327; # MAGE FROST 25:0,8,2,80,80:53755,57327; # WARLOCK AFFLICTION 26:0,9,0,80,80:53755,57327; # WARLOCK DEMONOLOGY 27:0,9,1,80,80:53755,57327; # WARLOCK DESTRUCTION 28:0,9,2,80,80:53755,57327; # DRUID BALANCE 29:0,11,0,80,80:53755,57327; # DRUID FERAL BEAR 30:0,11,1,80,80:53749,53763,57367; # DRUID RESTORATION 31:0,11,2,80,80:54212,57334; # DRUID FERAL CAT 32:0,11,3,80,80:53760,57358; 33:1,1,0,60,69:16323,24799,12179,24425,22817,22888,23735,15366,22818; 34:2,1,0,60,69:16323,24799,12179,24425,22817,22888,23735,15366,22818,16609; 35:1,1,1,60,69:16323,24799,12179,24425,22817,22888,23735,15366,22818; 36:2,1,1,60,69:16323,24799,12179,24425,22817,22888,23735,15366,22818,16609; 37:1,1,2,60,69:22817,22818,24425,22888,15366,17626,25661,12178,23737; 38:2,1,2,60,69:22817,22818,24425,22888,15366,17626,25661,12178,23737,16609; 39:1,2,0,60,69:17627,18194,12176,24425,23766,22820,22818,15366; 40:2,2,0,60,69:17627,18194,12176,24425,23766,22820,22818,15366,16609; 41:1,2,1,60,69:18191,12178,24382,10667,22888,24425,23737,22818,22817,22820,15366; 42:2,2,1,60,69:18191,12178,24382,10667,22888,24425,23737,22818,22817,22820,15366,16609; 43:1,2,2,60,69:12179,24799,17538,24363,22888,24425,23768,22818,22817,22820,15366; 44:2,2,2,60,69:12179,24799,17538,24363,22888,24425,23768,22818,22817,22820,15366,16609; 45:1,3,0,60,69:22817,15366,22818,24425,23768,22888,17538,18192,12174; 46:2,3,0,60,69:22817,15366,22818,24425,23768,22888,17538,18192,12174,16609; 47:1,3,1,60,69:22817,15366,22818,24425,23768,22888,17538,18192,12174; 48:2,3,1,60,69:22817,15366,22818,24425,23768,22888,17538,18192,12174,16609; 49:1,3,2,60,69:22817,15366,22818,24425,23768,22888,17538,18192,12174; 50:2,3,2,60,69:22817,15366,22818,24425,23768,22888,17538,18192,12174,16609; 51:1,4,0,60,69:22888,24425,23736,22818,22817,15366,17538,18192,12174; 52:2,4,0,60,69:22888,24425,23736,22818,22817,15366,17538,18192,12174,16609; 53:0,4,1,60,69:22888,24425,23736,22818,22817,15366,17538,18192,12174; 54:0,4,2,60,69:22888,24425,23736,22818,22817,15366,17538,18192,12174,16609; 55:1,5,0,60,69:17627,18194,12177,22888,24425,23738,22818,22820,15366; 56:2,5,0,60,69:17627,18194,12177,22888,24425,23738,22818,22820,15366,16609; 57:1,5,1,60,69:17627,18194,12177,22888,24425,23738,22818,22820,15366; 58:2,5,1,60,69:17627,18194,12177,22888,24425,23738,22818,22820,15366,16609; 59:1,5,2,60,69:17627,18194,12177,22888,24425,23738,22818,22820,15366; 60:2,5,2,60,69:17627,18194,12177,22888,24425,23738,22818,22820,15366,16609; 61:1,7,0,60,69:17628,18194,12176,22888,24425,23768,22818,22820,15366; 62:2,7,0,60,69:17628,18194,12176,22888,24425,23768,22818,22820,15366,16609; 63:1,7,1,60,69:17538,24799,12179,22888,24425,23768,22818,22817,22820,15366; 64:2,7,1,60,69:17538,24799,12179,22888,24425,23768,22818,22817,22820,15366,16609; 65:1,7,2,60,69:17627,18194,12176,22888,24425,23766,22818,22820,15366; 66:2,7,2,60,69:17627,18194,12176,22888,24425,23766,22818,22820,15366,16609; 67:1,8,0,60,69:17628,18194,12176,22888,24425,23768,22818,22820,15366; 68:2,8,0,60,69:17628,18194,12176,22888,24425,23768,22818,22820,15366,16609; 69:1,8,1,60,69:17628,18194,12176,22888,24425,23768,22818,22820,15366; 70:2,8,1,60,69:17628,18194,12176,22888,24425,23768,22818,22820,15366,16609; 71:1,8,2,60,69:17628,18194,12176,22888,24425,23768,22818,22820,15366; 72:2,8,2,60,69:17628,18194,12176,22888,24425,23768,22818,22820,15366,16609; 73:1,9,0,60,69:17628,25661,22888,24425,23768,22818,22820,15366; 74:2,9,0,60,69:17628,25661,22888,24425,23768,22818,22820,15366,16609; 75:1,9,1,60,69:17628,25661,22888,24425,23768,22818,22820,15366; 76:2,9,1,60,69:17628,25661,22888,24425,23768,22818,22820,15366,16609; 77:1,9,2,60,69:17628,25661,22888,24425,23768,22818,22820,15366; 78:2,9,2,60,69:17628,25661,22888,24425,23768,22818,22820,15366,16609; 79:1,11,0,60,69:22888,24425,23768,22818,22820,15366; 80:2,11,0,60,69:22888,24425,23768,22818,22820,15366,16609; 81:1,11,1,60,69:17626,17540,18192,12174,22888,24425,23767,22818,22817,15366; 82:2,11,1,60,69:17626,17540,18192,12174,22888,24425,23767,22818,22817,15366,16609; 83:1,11,2,60,69:17627,18194,12176,22888,24425,23738,22818,22820,15366; 84:2,11,2,60,69:17627,18194,12176,22888,24425,23738,22818,22820,15366,16609; 85:1,11,3,60,69:17538,24799,12179,22888,24425,23768,22818,22817,15366; 86:2,11,3,60,69:17538,24799,12179,22888,24425,23768,22818,22817,15366,16609; 87:0,1,0,70,79:35076,28520,33256; 88:0,1,1,70,79:35076,28520,33256; 89:0,1,2,70,79:35076,28518,33257; 90:0,2,0,70,79:35076,17627,33268; 91:0,2,1,70,79:35076,28518,33257; 92:0,2,2,70,79:35076,28520,33256; 93:0,3,0,70,79:35076,28520,33261; 94:0,3,1,70,79:35076,28520,33261; 95:0,3,2,70,79:35076,28520,33261; 96:0,4,0,70,79:35076,28520,33259; 97:0,4,1,70,79:35076,28520,33259; 98:0,4,2,70,79:35076,28520,33261; 99:0,5,0,70,79:35076,17627,33268; 100:0,5,1,70,79:35076,17627,33268; 101:0,5,2,70,79:35076,28540,33263; 102:0,7,0,70,79:35076,28521,33263; 103:0,7,1,70,79:35076,28520,33259; 104:0,7,2,70,79:35076,17627,33268; 105:0,8,0,70,79:35076,17627,33263; 106:0,8,1,70,79:35076,28540,33263; 107:0,8,2,70,79:35076,28540,33263; 108:0,9,0,70,79:35076,28540,33263; 109:0,9,1,70,79:35076,28540,33263; 110:0,9,2,70,79:35076,28540,33263; 111:0,11,0,70,79:35076,28521,33263; 112:0,11,1,70,79:35076,28518,33257; 113:0,11,2,70,79:35076,17627,33268; 114:0,11,3,70,79:35076,28520,33261',
                'PlayerbotsDatabaseInfo': f'"{mysql_hostname};{mysql_port};{mysql_username};{mysql_password};{mysql_database_playerbots}"',
                'Playerbots.Updates.EnableDatabases': 0,
                'AiPlayerbot.CommandServerPort': 0,
                'AiPlayerbot.RandomBotTalk': 0,
                'AiPlayerbot.RandomBotSuggestDungeons': 0,
                'AiPlayerbot.ToxicLinksRepliesChance': 0,
                'AiPlayerbot.ThunderfuryRepliesChance': 0,
                'AIPlayerbot.GuildFeedback': 0,
                'AiPlayerbot.GuildRepliesRate': 0,
                'AiPlayerbot.EnableBroadcasts': 0
            }
        },
        'modules/skip_dk_module.conf': {
            'enabled': build_world and skip_dk_starting_area_enabled,
            'options': {
                'Skip.Deathknight.Starter.Announce.enable': 0,
                'Skip.Deathknight.Starter.Enable': 0
            }
        }
    }

    for name, config_options in config.items():
        dist_file = os.path.join(install_dir, 'etc', f'{name}.dist')
        config_file = os.path.join(install_dir, 'etc', name)
        set_options = config_options['options']
        base_file_name = os.path.basename(name)

        if not config_options['enabled']:
            print(f'{colorama.Fore.CYAN}Skipping {base_file_name}{colorama.Style.RESET_ALL}')
            os.path.exists(dist_file) and os.remove(dist_file)
            os.path.exists(config_file) and os.remove(config_file)
            continue

        print(f'{colorama.Fore.MAGENTA}Updating {base_file_name}{colorama.Style.RESET_ALL}')

        try:
            shutil.copy(dist_file, config_file)
        except:
            print(f'{colorama.Fore.RED}Failed to update {base_file_name}{colorama.Style.RESET_ALL}')
            sys.exit(1)

        with open(config_file, 'r+') as f:
            lines = f.readlines()
            f.seek(0)
            for line in lines:
                if '=' in line:
                    key = line.split('=', 1)[0].strip()
                    if key in set_options:
                        print(f'{colorama.Fore.YELLOW}Setting {key} to {set_options[key]}{colorama.Style.RESET_ALL}')
                        line = f'{key} = {set_options[key]}\n'
                f.write(line)
            f.truncate()

        print(f'{colorama.Fore.MAGENTA}Finished updating {base_file_name}{colorama.Style.RESET_ALL}')

    print(f'{colorama.Fore.GREEN}Finished updating config files...{colorama.Style.RESET_ALL}')

def GetFileHash(file):
    with open(file, 'rb') as f:
        return hashlib.file_digest(f, 'sha1').hexdigest()

def ImportDatabases():
    print(f'{colorama.Fore.GREEN}Importing database files...{colorama.Style.RESET_ALL}')

    mysql_cnf = os.path.join(cwd, 'mysql.cnf')

    with open(mysql_cnf, 'w') as f:
        f.write(f'[client]\nhost="{mysql_hostname}"\nport="{mysql_port}"\nuser="{mysql_username}"\npassword="{mysql_password}"')

    databases = {
        mysql_database_auth: [
            {
                'enabled': True,
                'path': os.path.join(src_dir, 'data', 'sql', 'base', 'db_auth'),
                'description': ''
            },
            {
                'enabled': True,
                'path': os.path.join(src_dir, 'data', 'sql', 'updates', 'db_auth'),
                'description': 'RELEASED'
            },
            {
                'enabled': True,
                'path': os.path.join(src_dir, 'data', 'sql', 'custom', 'db_auth'),
                'description': 'CUSTOM'
            },
            {
                'enabled': True,
                'path': os.path.join(sql_dir, 'auth'),
                'description': ''
            }
        ],
        mysql_database_characters: [
            {
                'enabled': build_world,
                'path': os.path.join(src_dir, 'data', 'sql', 'base', 'db_characters'),
                'description': ''
            },
            {
                'enabled': build_world,
                'path': os.path.join(src_dir, 'data', 'sql', 'updates', 'db_characters'),
                'description': 'RELEASED'
            },
            {
                'enabled': build_world,
                'path': os.path.join(src_dir, 'data', 'sql', 'custom', 'db_characters'),
                'description': 'CUSTOM'
            },
            {
                'enabled': build_world and playerbots_enabled,
                'path': os.path.join(src_dir, 'modules', 'mod-playerbots', 'data', 'sql', 'characters', 'base'),
                'description': 'MODULE'
            },
            {
                'enabled': build_world and playerbots_enabled,
                'path': os.path.join(src_dir, 'modules', 'mod-playerbots', 'data', 'sql', 'characters', 'updates'),
                'description': 'MODULE'
            },
            {
                'enabled': build_world,
                'path': os.path.join(sql_dir, 'characters'),
                'description': ''
            }
        ],
        mysql_database_world: [
            {
                'enabled': build_world,
                'path': os.path.join(src_dir, 'data', 'sql', 'base', 'db_world'),
                'description': ''
            },
            {
                'enabled': build_world,
                'path': os.path.join(src_dir, 'data', 'sql', 'updates', 'db_world'),
                'description': 'RELEASED'
            },
            {
                'enabled': build_world,
                'path': os.path.join(src_dir, 'data', 'sql', 'custom', 'db_world'),
                'description': 'CUSTOM'
            },
            {
                'enabled': build_world and playerbots_enabled,
                'path': os.path.join(src_dir, 'modules', 'mod-playerbots', 'data', 'sql', 'world', 'base'),
                'description': 'MODULE'
            },
            {
                'enabled': build_world and playerbots_enabled,
                'path': os.path.join(src_dir, 'modules', 'mod-playerbots', 'data', 'sql', 'world', 'updates'),
                'description': 'MODULE'
            },
            {
                'enabled': build_world and progression_enabled,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_00', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 1,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_01', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 2,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_02', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 3,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_03', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 4,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_04', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 5,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_05', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 6,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_06', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 7,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_07', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 8,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_08', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 9,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_09', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 10,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_10', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 11,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_11', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 12,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_12', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 13,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_13', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 14,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_14', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 15,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_15', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 16,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_16', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 17,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_17', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and progression_enabled and progression_phase_id >= 18,
                'path': os.path.join(src_dir, 'modules', 'mod-progression', 'src', 'phase_18', 'sql'),
                'description': ''
            },
            {
                'enabled': build_world and skip_dk_starting_area_enabled,
                'path': os.path.join(src_dir, 'modules', 'mod-skip-dk-starting-area', 'data', 'sql', 'db-world'),
                'description': 'MODULE'
            },
            {
                'enabled': build_world,
                'path': os.path.join(sql_dir, 'world'),
                'description': ''
            }
        ],
        mysql_database_playerbots: [
            {
                'enabled': build_world and playerbots_enabled,
                'path': os.path.join(src_dir, 'modules', 'mod-playerbots', 'data', 'sql', 'playerbots', 'base'),
                'description': ''
            },
            {
                'enabled': build_world and playerbots_enabled,
                'path': os.path.join(src_dir, 'modules', 'mod-playerbots', 'data', 'sql', 'playerbots', 'updates'),
                'description': 'RELEASED'
            },
            {
                'enabled': build_world and playerbots_enabled,
                'path': os.path.join(src_dir, 'modules', 'mod-playerbots', 'data', 'sql', 'playerbots', 'custom'),
                'description': 'CUSTOM'
            }
        ]
    }

    for name, entries in databases.items():
        if not any(e['enabled'] for e in entries):
            print(f'{colorama.Fore.CYAN}Skipping {name}{colorama.Style.RESET_ALL}')
            continue

        print(f'{colorama.Fore.MAGENTA}Importing files for {name}{colorama.Style.RESET_ALL}')

        for entry in entries:
            if not entry['enabled']:
                continue

            path = entry['path']
            description = entry['description']
            is_update = bool(description)

            tables = []
            updates = []

            try:
                with pymysql.connect(host=mysql_hostname, port=mysql_port, user=mysql_username, password=mysql_password, db=name) as connect:
                    with connect.cursor() as cursor:
                        if is_update:
                            cursor.execute('SELECT `name`, `hash` FROM `updates`;')
                            updates = [[row[0], row[1]] for row in cursor.fetchall()]
                        else:
                            cursor.execute('SHOW TABLES;')
                            tables = [row[0] for row in cursor.fetchall()]
            except:
                print(f'{colorama.Fore.RED}Failed to load {'updates' if is_update else 'table data'} from {name}{colorama.Style.RESET_ALL}')
                os.path.exists(mysql_cnf) and os.remove(mysql_cnf)
                sys.exit(1)

            for file in sorted(os.listdir(path)):
                file_path = os.path.join(path, file)
                file_short_name = file.replace('.sql', '')

                if not os.path.isfile(file_path) or not file.endswith('.sql'):
                    continue

                sha = GetFileHash(file_path).upper()

                if (is_update and [file, sha] in updates) or (not is_update and file_short_name in tables):
                    print(f'{colorama.Fore.YELLOW}Skipping {file}{colorama.Style.RESET_ALL}')
                    continue

                print(f'{colorama.Fore.YELLOW}Importing {file}{colorama.Style.RESET_ALL}')

                try:
                    subprocess.run(f'mysql --defaults-extra-file={mysql_cnf} {name} < {file_path}', shell=True, check=True)
                except:
                    print(f'{colorama.Fore.RED}Failed to import {file} to {name}{colorama.Style.RESET_ALL}')
                    os.path.exists(mysql_cnf) and os.remove(mysql_cnf)
                    sys.exit(1)

                if is_update:
                    try:
                        with pymysql.connect(host=mysql_hostname, port=mysql_port, user=mysql_username, password=mysql_password, db=name) as connect:
                            with connect.cursor() as cursor:
                                cursor.execute('DELETE FROM `updates` WHERE `name` = %s;', (file,))
                                cursor.execute('INSERT INTO `updates` (`name`, `hash`, `state`) VALUES (%s, %s, %s);', (file, sha, description))
                                connect.commit()
                    except:
                        print(f'{colorama.Fore.RED}Failed to add file hash for {file} to {name}{colorama.Style.RESET_ALL}')
                        os.path.exists(mysql_cnf) and os.remove(mysql_cnf)
                        sys.exit(1)

        print(f'{colorama.Fore.MAGENTA}Finished importing files for {name}{colorama.Style.RESET_ALL}')

    os.path.exists(mysql_cnf) and os.remove(mysql_cnf)

    print(f'{colorama.Fore.GREEN}Finished importing database files...{colorama.Style.RESET_ALL}')

def UpdateRealmlistAndMotd():
    print(f'{colorama.Fore.GREEN}Updating realmlist and motd...{colorama.Style.RESET_ALL}')

    if not build_world:
        print(f'{colorama.Fore.CYAN}Skipped because world is not enabled{colorama.Style.RESET_ALL}')
    else:
        try:
            with pymysql.connect(host=mysql_hostname, port=mysql_port, user=mysql_username, password=mysql_password, db=mysql_database_auth) as connect:
                with connect.cursor() as cursor:
                    print(f'{colorama.Fore.YELLOW}Updating realmlist{colorama.Style.RESET_ALL}')
                    cursor.execute('SELECT * FROM `realmlist` WHERE `id` = %s;', world_realm_id)
                    row = cursor.fetchone()
                    if row:
                        cursor.execute('UPDATE `realmlist` SET `name` = %s, `address` = %s, `localAddress` = %s, `port` = %s WHERE `id` = %s;',
                        (world_realm_name, world_realm_address, world_realm_address, world_realm_port, world_realm_id))
                    else:
                        cursor.execute('INSERT INTO `realmlist` (`id`, `name`, `address`, `localAddress`, `port`) VALUES (%s, %s, %s, %s, %s);',
                        (world_realm_id, world_realm_name, world_realm_address, world_realm_address, world_realm_port))

                    print(f'{colorama.Fore.YELLOW}Updating message of the day{colorama.Style.RESET_ALL}')
                    cursor.execute('SELECT * FROM `motd` WHERE `realmid` = %s;', world_realm_id)
                    row = cursor.fetchone()
                    if row:
                        cursor.execute('UPDATE `motd` SET `text` = %s WHERE `realmid` = %s;', (f'Welcome to {options.get('world.name', 'AzerothCore')}', world_realm_id))
                    else:
                        cursor.execute('INSERT INTO `motd` (`realmid`, `text`) VALUES (%s, %s);', (world_realm_id, f'Welcome to {world_realm_name}.'))

                    connect.commit()
        except:
            print(f'{colorama.Fore.RED}Failed to update realmlist and motd{colorama.Style.RESET_ALL}')
            sys.exit(1)

    print(f'{colorama.Fore.GREEN}Finished updating realmlist and motd...{colorama.Style.RESET_ALL}')

def DownloadClientData():
    print(f'{colorama.Fore.GREEN}Downloading client data...{colorama.Style.RESET_ALL}')

    if not build_world:
        print(f'{colorama.Fore.CYAN}Skipped because world is not enabled{colorama.Style.RESET_ALL}')
    else:
        print(f'{colorama.Fore.MAGENTA}Checking the installed version{colorama.Style.RESET_ALL}')

        version_file = os.path.join(cwd, 'data.version')
        archive = os.path.join(cwd, 'data.zip')

        local_version = 0
        if os.path.isfile(version_file):
            with open(version_file, 'r') as f:
                local_version = f.read().strip()

        required_folders = ['Cameras', 'dbc', 'maps', 'mmaps', 'vmaps']

        if any(not os.path.exists(os.path.join(data_dir, folder)) for folder in required_folders):
            local_version = 0

        print(f'{colorama.Fore.YELLOW}{'No installed version found' if not local_version else f'Found version {local_version}'}{colorama.Style.RESET_ALL}')
        print(f'{colorama.Fore.MAGENTA}Finished checking the installed version{colorama.Style.RESET_ALL}')
        print(f'{colorama.Fore.MAGENTA}Checking the latest version{colorama.Style.RESET_ALL}')

        try:
            remote_version = sorted(git.cmd.Git().ls_remote('--tags', 'https://github.com/wowgaming/client-data.git').split('\n'), reverse=True)[0].rsplit('/', 1)[1].replace('v', '')
        except:
            print(f'{colorama.Fore.RED}Failed to retreive the latest version{colorama.Style.RESET_ALL}')
            sys.exit(1)

        print(f'{colorama.Fore.YELLOW}Found version {remote_version}{colorama.Style.RESET_ALL}')

        print(f'{colorama.Fore.MAGENTA}Finished checking the latest version{colorama.Style.RESET_ALL}')

        if not local_version == remote_version:
            [shutil.rmtree(os.path.join(data_dir, folder), ignore_errors=True) for folder in required_folders]
            os.path.exists(archive) and os.remove(archive)

            print(f'{colorama.Fore.MAGENTA}Downloading the latest version{colorama.Style.RESET_ALL}')

            response = requests.get(f'https://github.com/wowgaming/client-data/releases/download/v{remote_version}/data.zip', stream=True)
            if response.status_code != 200:
                print(f'{colorama.Fore.RED}Failed to download the latest version{colorama.Style.RESET_ALL}')
                sys.exit(1)

            try:
                with open(archive, 'wb') as f, tqdm(total=int(response.headers.get('content-length', 0)), unit='iB', unit_scale=True, unit_divisor=1024) as bar:
                    [bar.update(f.write(chunk)) for chunk in response.iter_content(1024)]
            except:
                print(f'{colorama.Fore.RED}Failed to download the latest version{colorama.Style.RESET_ALL}')
                sys.exit(1)

            print(f'{colorama.Fore.MAGENTA}Finished downloading the latest version{colorama.Style.RESET_ALL}')
            print(f'{colorama.Fore.MAGENTA}Extracting the latest version{colorama.Style.RESET_ALL}')

            try:
                with ZipFile(archive) as zf:
                    members = zf.infolist()
                    total = sum(m.file_size for m in members)

                    with tqdm(total=total, unit='B', unit_scale=True, unit_divisor=1024) as bar:
                        for member in members:
                            target = Path(data_dir) / member.filename

                            if member.is_dir():
                                target.mkdir(parents=True, exist_ok=True)
                                continue

                            target.parent.mkdir(parents=True, exist_ok=True)

                            with zf.open(member) as src, open(target, 'wb') as dst:
                                while chunk := src.read(1024 * 1024):
                                    dst.write(chunk)
                                    bar.update(len(chunk))
            except:
                print(f'{colorama.Fore.RED}Failed to extract the latest version{colorama.Style.RESET_ALL}')
                sys.exit(1)

            with open(version_file, 'w') as f: f.write(remote_version)

            os.path.exists(archive) and os.remove(archive)

            print(f'{colorama.Fore.MAGENTA}Finished extracting latest version{colorama.Style.RESET_ALL}')
        else:
            print(f'{colorama.Fore.YELLOW}Data files are up-to-date{colorama.Style.RESET_ALL}')

    print(f'{colorama.Fore.GREEN}Finished downloading client data...{colorama.Style.RESET_ALL}')

def CopyDbcFiles():
    print(f'{colorama.Fore.GREEN}Copying dbc files...{colorama.Style.RESET_ALL}')

    if not build_world:
        print(f'{colorama.Fore.CYAN}Skipped because world is not enabled{colorama.Style.RESET_ALL}')
    else:
        files = [f for f in sorted(os.listdir(dbc_dir)) if f.endswith('.dbc') and os.path.isfile(os.path.join(dbc_dir, f))]

        if files:
            for file in files:
                print(f'{colorama.Fore.YELLOW}Copying {file}{colorama.Style.RESET_ALL}')

                try:
                    shutil.copyfile(os.path.join(dbc_dir, file), os.path.join(data_dir, 'dbc', file))
                except:
                    print(f'{colorama.Fore.RED}Failed to copy {file}{colorama.Style.RESET_ALL}')
                    sys.exit(1)
        else:
            print(f'{colorama.Fore.YELLOW}No files found in directory{colorama.Style.RESET_ALL}')

    print(f'{colorama.Fore.GREEN}Finished copying dbc files...{colorama.Style.RESET_ALL}')

def IsScreenActive(name) -> bool:
    result = subprocess.run(
        ['screen', '-list'],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True
    )
    return name in result.stdout

def WaitForShutdown():
    subprocess.run([
        'screen', '-S', f'world-{world_realm_id}', '-p', '0',
        '-X', 'stuff', 'server shutdown 10^m'
    ], check=True)

    for _ in range(30):
        if not IsScreenActive(f'world-{world_realm_id}'):
            return
        time.sleep(1)

def StopServer():
    print(f'{colorama.Fore.GREEN}Stopping the server...{colorama.Style.RESET_ALL}')

    auth_running = build_auth and IsScreenActive('auth')
    world_running = build_world and IsScreenActive(f'world-{world_realm_id}')

    if auth_running or world_running:
        if world_running:
            print(f'{colorama.Fore.YELLOW}Telling the worldserver to shut down{colorama.Style.RESET_ALL}')
            WaitForShutdown()
            world_running = build_world and IsScreenActive(f'world-{world_realm_id}')

        if auth_running:
            print(f'{colorama.Fore.YELLOW}Stopping authserver{colorama.Style.RESET_ALL}')

        if auth_running or world_running:
            try:
                subprocess.run('./stop.sh', cwd=bin_dir, check=True)
            except:
                print(f'{colorama.Fore.RED}Failed to stop the server{colorama.Style.RESET_ALL}')
    else:
        print(f'{colorama.Fore.RED}The server is not running{colorama.Style.RESET_ALL}')

    print(f'{colorama.Fore.GREEN}Finished stopping the server...{colorama.Style.RESET_ALL}')

def StartServer():
    print(f'{colorama.Fore.GREEN}Starting the server...{colorama.Style.RESET_ALL}')

    auth_needed = build_auth and not IsScreenActive('auth')
    world_needed = build_world and not IsScreenActive(f'world-{world_realm_id}')

    if auth_needed or world_needed:
        try:
            subprocess.run('./start.sh', cwd=bin_dir, check=True)
        except:
            print(f'{colorama.Fore.RED}Failed to start the server{colorama.Style.RESET_ALL}')

        if auth_needed:
            print(f'{colorama.Fore.YELLOW}To access the authserver screen: screen -r auth{colorama.Style.RESET_ALL}')

        if world_needed:
            print(f'{colorama.Fore.YELLOW}To access the worldserver screen: screen -r world-{world_realm_id}{colorama.Style.RESET_ALL}')
    else:
        print(f'{colorama.Fore.RED}The server is already running{colorama.Style.RESET_ALL}')

    print(f'{colorama.Fore.GREEN}Finished starting the server...{colorama.Style.RESET_ALL}')

arguments = [
    [ [ 'install', 'setup', 'update' ], 'Downloads the source code, with enabled modules, and compiles it' ],
    [ [ 'config', 'conf', 'cfg', 'settings', 'options' ], 'Updates all config files, including enabled modules, with options specified' ],
    [ [ 'database', 'db' ], 'Import all files to the specified databases' ],
    [ 'data', 'Download and extract the client data files'],
    [ 'dbc', 'Copy modified client data files to the proper folder' ],
    [ 'all', 'Run all parameters listed above, excluding reset but including stop and start' ],
    [ 'start', 'Starts the compiled processes, based off of the choice for compilation' ],
    [ 'stop', 'Stops the compiled processes, based off of the choice for compilation' ],
    [ 'restart', 'Stops and then starts the compiled processes, based off of the choice for compilation' ],
]

commands = {
    'install': [StopServer, DownloadSourceCode, GenerateProject, CompileSourceCode, CreateRequiredScripts],
    'setup': [StopServer, DownloadSourceCode, GenerateProject, CompileSourceCode, CreateRequiredScripts],
    'update': [StopServer, DownloadSourceCode, GenerateProject, CompileSourceCode, CreateRequiredScripts],
    'config': [UpdateConfigs],
    'conf': [UpdateConfigs],
    'cfg': [UpdateConfigs],
    'settings': [UpdateConfigs],
    'options': [UpdateConfigs],
    'db': [ImportDatabases, UpdateRealmlistAndMotd],
    'database': [ImportDatabases],
    'data': [DownloadClientData],
    'dbc': [CopyDbcFiles],
    'start': [StartServer],
    'stop': [StopServer],
    'restart': [StopServer, StartServer],
    'all': [StopServer, DownloadSourceCode, GenerateProject, CompileSourceCode, CreateRequiredScripts, UpdateConfigs, ImportDatabases, UpdateRealmlistAndMotd, DownloadClientData, CopyDbcFiles, StartServer]
}

def PrintAvailableArguments():
    print(f'{colorama.Fore.GREEN}Available arguments{colorama.Style.RESET_ALL}')

    max_len = max(len('/'.join(arg[0]) if isinstance(arg[0], list) else arg[0]) for arg in arguments)

    for arg in arguments:
        param = '/'.join(arg[0]) if isinstance(arg[0], list) else arg[0]
        desc = arg[1]
        print(f'{colorama.Fore.YELLOW}{param}{colorama.Fore.WHITE}{' ' * (max_len - len(param))} | '
              f'{colorama.Fore.BLUE}{desc}{colorama.Style.RESET_ALL}')

    sys.exit(0)

os.system('clear')

if len(sys.argv) < 2:
    PrintAvailableArguments()

argument = sys.argv[1].lower()

funcs = commands.get(argument)
if funcs:
    for func in funcs:
        func()
else:
    PrintAvailableArguments()

print(f'{colorama.Fore.CYAN}The script finished successfully...{colorama.Style.RESET_ALL}')
