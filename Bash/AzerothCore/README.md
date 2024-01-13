# Information
The purpose of this script is to fully manage realms running using AzerothCore. A few commands will perform every step of the setup of a realm. It supports running as a regular realm or as a cluster, running multiple realms or nodes on a single system etc.

The script will not manage the database server nor will it create the databases or the mysql user.

The steps included with this script are as follows.
- Install, and update, authserver and worldserver along with any enabled modules.
- Download, and update, client data files. It will automatically get the latest available version and update if needed.
- Copy custom DBC files to the client data files.
- Import database tables, updates and any custom files for the core as well as any enabled modules.
- Update config files for the core as well as any enabled modules.
- Create auto-restarter scripts that it uses to start the compiled binaries.
- Start and shut down the compiled binaries.

It's possible to add modules on top of what is supported by this script but you'll have to manage config and database files yourself. The script disabled the autoupdater and won't handle files it doesn't know to look for.

To automate the process of copying custom dbc files they need to be placed in a folder called `dbc` in the same folder as the script. The same is true for custom sql files except they need be placed in `sql/auth`, `sql/characters` or `sql/world` depending on the database they should be executed on. The folders will be created by the script when using related parameters.

# Supported distributions
The script supports Ubuntu 22.04 and Debian 12.

If you're using Ubuntu 22.04 you can safely ignore these instructions.

Debian 12 requires you to manually install `mysql-apt-config` before running this script. This is because although MariaDB is supported by AzerothCore it has several issues and isn't worth the trouble. It's a simple process and I'm including the specific steps below. It does include removing anything related to MariaDB so if you already have a server running you should export any data you wanna keep first.

If you're running this as root you can remove all occurrences of `sudo`.

- `sudo apt autoremove *mariadb*`
- `sudo apt update && sudo apt install --yes wget`
- `wget https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb`
- `sudo apt install --yes ./mysql-apt-config_0.8.29-1_all.deb`
- Select OK and press enter whenever prompted by a GUI but don't change anything else
- `sudo apt update`

If you want to run the database server on this machine you can run `sudo apt install --yes mysql-server` now.

# Config
The script will load config options from a mysql database. By default it will connect to a database server on 127.0.0.1 with the username and password both being acore. These options and the realm id are the only options set inside the script itself. When using a cluster the node id is also used but if you're not using that there's no need to change it. These options are also what the script uses when importing database files and what it writes to the config files. I recommend importing the included SQL file to acore_auth.

The table created might seem overwhelming but is actually quite simple. The id column defines the realm id, node is the node id, setting is which setting and value is the value of the setting. If id or node is set to -1 it will be applied to any realm that doesn't have a setting set with the realm and node id. Every realms needs to include every setting even if you don't change them. The script will fail if any setting is missing. Below is a description of each setting.

- `build.auth`: Can be set to **true** or **false** and determines if authserver should be built when running the script
- `build.world`: Can be set to **true** or **false** and determines if worldserver should be built when running the script
- `database.auth`: This is the name of the auth database used by AzerothCore
- `database.characters`: This is the name of the characters database used by AzerothCore
- `database.playerbots`: This is the name of the playerbots database used by AzerothCore. If the playerbots module isn't enabled this can safely be ignored
- `database.world`: This is the name of the world database used by AzerothCore
- `git.branch`: This is the name of the branch for the set github repository. This is an option for advanced users
- `git.repository`: This is the name of the github repository to use. It's not the full url but only includes the username and repository name. A url of `https://github.com/azerothcore/azerothcore-wotlk` mean the value of this setting is `azerothcore/azerothcore-wotlk`. This is an option for advanced users
- `module.ah_bot`: Can be set to **true** or **false** and enables the auction house bot module
- `module.ah_bot.account`: This is the account id used by the auction house bot
- `module.ah_bot.buy_items`: Can be set to **true** or **false** and determines if the bot should buy items that players put up for sale
- `module.ah_bot.character`: This is the character guid used by the auction house bot
- `module.ah_bot.items`: This is the amount of items that the bot will post on each auction house
- `module.ah_bot.items_per_cycle`: This is the amount of items the bot will post each time it runs a cycle. I don't recommend that you change this
- `module.ah_bot.max_item_level`: This is the higest item level of items that the bot will put up for sale
- `module.ah_bot.sell_items`: Can be set to **true** or **false** and determines if the bot should sell items
- `module.ah_bot.use_buyprice`: Can be set to **true** or **false** and determines if the bot should use buyprice instead of sellprice from item templates when selling items
- `module.appreciation`: Can be set to **true** or **false** and enables the appreciation module
- `module.appreciation.level_boost`: Can be set to **true** or **false** and determines if players can get level boosts from the npc
- `module.appreciation.level_boost.included_copper`: This is how much copper the player will receive when performing a level boost
- `module.appreciation.level_boost.level`: Can be set to **60**, **70** or **80** and defines the level the player will be given when performing a level boost
- `module.appreciation.require_certificate` Can be set to **true** or **false** and determines if players need a *Token of Appreciation* to use any of the services provided by the npc
- `module.appreciation.reward_at_max_level`: Can be set to **true** or **false** and determines if players should be rewarded with a *Token of Appreciation* when reaching max level
- `module.appreciation.unlock_continents`: Can be set to **true** or **false** and determines if players can unlock flight paths from the npc
- `module.assistant`: Can be set to **true** or **false** and enables the assistant module
- `module.assistant.fp.tbc`: Can be set to **true** or **false** and determines if players can unlock flight paths in Outland via the assistant
- `module.assistant.fp.tbc.cost`: This is the amount of copper required to unlock flight paths in Outland via the assistant
- `module.assistant.fp.tbc.required_level`: This is the level required to unlock flight paths in Outland via the assistant
- `module.assistant.fp.vanilla`: Can be set to **true** or **false** and determines if players can unlock flight paths in Eastern Kingdoms and Kalimdor via the assistant
- `module.assistant.fp.vanilla.cost`: This is the amount of copper required to unlock flight paths in Eastern Kingdoms and Kalimdor via the assistant
- `module.assistant.fp.vanilla.required_level`: This is the level required to unlock flight paths in Eastern Kingdoms and Kalimdor via the assistant
- `module.assistant.fp.wotlk`: Can be set to **true** or **false** and determines if players can unlock flight paths in Northrend via the assistant
- `module.assistant.fp.wotlk.cost`: This is the amount of copper required to unlock flight paths in Northrend via the assistant
- `module.assistant.fp.wotlk.required_level`: This is the level required to unlock flight paths in Northrend via the assistant
- `module.assistant.professions.apprentice`: Can be set to **true** or **false** and determines if players can boost their professions up to a skill value of 75
- `module.assistant.professions.apprentice.cost`: This is the amount of copper required to boost a profession to a skill value of 75
- `module.assistant.professions.artisan`: Can be set to **true** or **false** and determines if players can boost their professions up to a skill value of 300
- `module.assistant.professions.artisan.cost`: This is the amount of copper required to boost a profession to a skill value of 300
- `module.assistant.professions.expert`: Can be set to **true** or **false** and determines if players can boost their professions up to a skill value of 225
- `module.assistant.professions.expert.cost`: This is the amount of copper required to boost a profession to a skill value of 225
- `module.assistant.professions.grand_master`: Can be set to **true** or **false** and determines if players can boost their professions up to a skill value of 450
- `module.assistant.professions.grand_master.cost`: This is the amount of copper required to boost a profession to a skill value of 450
- `module.assistant.professions.journeyman`: Can be set to **true** or **false** and determines if players can boost their professions up to a skill value of 150
- `module.assistant.professions.journeyman.cost`: This is the amount of copper required to boost a profession to a skill value of 150
- `module.assistant.professions.master`: Can be set to **true** or **false** and determines if players can boost their professions up to a skill value of 375
- `module.assistant.professions.master.cost`: This is the amount of copper required to boost a profession to a skill value of 375
- `module.assistant.utilities`: Can be set to **true** or **false** and determines if players can obtain various features from the assistant, such as name change and faction change
- `module.assistant.vendor.containers`: Can be set to **true** or **false** and determines if players can obtain bags and quivers from the assistant
- `module.assistant.vendor.gems`: Can be set to **true** or **false** and determines if players can obtain gems from the assistant
- `module.assistant.vendor.glyphs`: Can be set to **true** or **false** and determines if players can obtain glyphs from the assistant
- `module.assistant.vendor.heirlooms`: Can be set to **true** or **false** and determines if players can obtain heirlooms from the assistant
- `module.groupquests`: Can be set to **true** or **false** and enables the group quests module
- `module.junktogold`: Can be set to **true** or **false** and enables the junk-to-gold module
- `module.learnspells`: Can be set to **true** or **false** and enables the learn spells module
- `module.learnspells.class_spells`: Can be set to **true** or **false** and determines if players will learn class spells
- `module.learnspells.proficiencies`: Can be set to **true** or **false** and determines if players will proficiencies
- `module.learnspells.quest_spells`: Can be set to **true** or **false** and determines if players will learn spells normally obtained from quests
- `module.learnspells.riding.apprentice`: Can be set to **true** or **false** and determines if players will learn apprentice riding and mounts
- `module.learnspells.riding.artisan`: Can be set to **true** or **false** and determines if players will learn artisan riding and mounts
- `module.learnspells.riding.cold_weather_flying`: Can be set to **true** or **false** and determines if players will learn cold weather flying
- `module.learnspells.riding.expert`: Can be set to **true** or **false** and determines if players will learn expert riding and mounts
- `module.learnspells.riding.journeyman`: Can be set to **true** or **false** and determines if players will learn journeyman riding and mounts
- `module.learnspells.talent_ranks`: Can be set to **true** or **false** and determines if players will learn talent ranks
- `module.playerbots`: Can be set to **true** or **false** and enables the playerbots module
- `module.playerbots.accounts`: This is the amount of random bot accounts to create
- `module.playerbots.bots`: This is the amount of random bots to log into the world
- `module.playerbots.random_level`: Can be set to **true** or **false** and determines if random bots will be set to random levels
- `module.playerbots.start_level`: This is the starting level for random bots if random_level is set to **false**
- `module.progression`: Can be set to **true** or **false** and enables the progression module
- `module.progression.aura`: Can be set to **0**, **1**, **2**, **3** or **4** and determines the aura used inside Icecrown Citadel
- `module.progression.enforce.dungeonfinder`: Can be set to **true** or **false** and determines if the dungeon finder is disabled before patch 3.3
- `module.progression.enforce.questinfo`: Can be set to **true** or **false** and determines if the quest-related information in tooltips and on the map is disabled before patch 3.3
- `module.progression.patch`: Can be set to **0**, **1**, **2**, **3** or **4** and determines the patch used
- `module.progression.reset`: Can be set to **true** or **false** and determines if database files from the progression module should be imported every time
- `module.recruitafriend`: Can be set to **true** or **false** and enables the recruit-a-friend module
- `module.recruitafriend.account_age`: This is how many days since account creation it can be recruited
- `module.recruitafriend.celestial_steed`: Can be set to **true** or **false** and determines if players should be rewarded with the Celestial Steed mount for recruiting players
- `module.recruitafriend.duration`: This is the amount of days that a referral stays active
- `module.recruitafriend.reward_days`: This is the amount of days since recruiting a player both accounts are given rewards
- `module.recruitafriend.swift_zhevra`: Can be set to **true** or **false** and determines if players should be rewarded with the Swift Zhevra mount for recruiting players
- `module.recruitafriend.touring_rocket`: Can be set to **true** or **false** and determines if players should be rewarded with the X-53 Touring Rocket mount for recruiting players
- `module.skip_dk_starting_area`: Can be set to **true** or **false** and enables the skip-dk-starting-area module
- `module.weekendbonus`: Can be set to **true** or **false** and enables the weekend-bonus module
- `module.weekendbonus.multiplier.experience`: This is a multiplier for experience points earned on weekends
- `module.weekendbonus.multiplier.money`: This is a multiplier for money looted and earned from quests on weekends
- `module.weekendbonus.multiplier.professions`: This is a multiplier for profession skill ups on weekends
- `module.weekendbonus.multiplier.proficiencies`: This is a multiplier for weapon and defense skill ups on weekends
- `module.weekendbonus.multiplier.reputation`: This is a multiplier for reputation earned on weekends
- `telegram.chat_id`: Can be set to **0** or a chat id provided by Telegram. Setting either this or token to **0** will disable Telegram It is used to send messages using Telegram if errors occur
- `telegram.token`: Can be set to **0** or a token provided by Telegram. Setting either this or chat_id to **0** will disable Telegram. It is used to send messages using Telegram if errors occur
- `world.address`: This is the address used to connect to the world server from the client
- `world.cluster`: Can be set to **true** or **false** and determines if cluster should be enabled. This requires a special fork of AzerothCore and is intended for advanced users
- `world.cluster.auth_address`: This is the address of the node running the ToCloud9 services. The game client has to be able to connect to it
- `world.cluster.maps`: Can be set to **all** or map ids separated by a comma and determines what maps are enabled on a cluster node. Example: **0,1,369,530,571,609**
- `world.cluster.node_address`: This is the address of the node. The game client has to be able to connect to it
- `world.data_directory`: This is the path where client data files will be stored. Never finish this with a slash! Can be set to current directory by using a single period (**.**) or a folder called data inside the current directory (**./data**) or use an absolute path (**/home/acore/data**)
- `world.expansion`: Can be set to **0**, **1** or **2** and determines the expansion used
- `world.leave_group_on_logout`: Can be set to **true** or **false** and determines if players should leave groups when logging out
- `world.motd`: This is the message shown to players when entering the world
- `world.name`: This is the name of the realm as shown in the realm selection list and on the character selection screen
- `world.player_limit`: This is the max amount of players that can be logged in at the same time
- `world.port`: This is the port used by the world server
- `world.preload_grids`: Can be set to **true** or **false** and determines if map grids should be loaded into memory on startup
- `world.quest_in_raid`: Can be set to **true** or **false** and determines if players can complete all quests while in a raid group
- `world.raid_min_level`: This is the minimum level required to join raid groups
- `world.rate.experience`: This is a multiplier for experience points gained
- `world.rate.money`: This is a multiplier for money looted and earned from quests
- `world.rate.reputation`: This is a multiplier for reputation gained
- `world.realm_zone`: This determines the zone of the realm. As an example **1** is Development, **2** is United States
- `world.set_creatures_active`: Can be set to **true** or **false** and determines if creatures with waypoints should be set as active on startup
- `world.type`: This determines the game type of the realm. As an example **0** is Normal and **1** is PvP
- `world.warden`: Can be set to **true** or **false** and determines if the warden anti-cheat system will be used

# Parameters
The script accepts the parameters listed below. For clarification I'm including the full command for running the script with each parameter. Some of them have multiple possible words to use so if a slash is used to separate words then any of the words can be used but not all of them combined.

- `./azerothcore.sh install/setup/update`: Install required packages, download the source code of both AzerothCore and all enabled modules, compile the source code and download client data files
- `./azerothcore.sh database/db`: Import database files for both the core and all enabled modules
- `./azerothcore.sh config/conf/cfg/settings/options`: Update config files for both the core and all enabled modules
- `./azerothcore.sh dbc`: Copy dbc files placed in the folder named `dbc` to the client data files 
- `./azerothcore.sh start`: Start the compiled binaries if they aren't running already
- `./azerothcore.sh stop`: Stop the compiled binaries if they are running
- `./azerothcore.sh restart`: Stop and then start the compiled binaries
- `./azerothcore.sh all`: Run through all of the parameters listed above except `restart`

Running the script without any parameters will print a list of the parameters too.
