#######################################################################
# SETTINGS
#

gitcmd = 'https://github.com/' # git@github.com:

settings = {
    'build.auth': True,
    'build.world': True,
    'database.host': '127.0.0.1',
    'database.port': 3306,
    'database.username': 'acore',
    'database.password': 'acore',
    'database.auth': 'acore_auth',
    'database.characters': 'acore_characters',
    'database.playerbots': 'acore_playerbots',
    'database.world': 'acore_world',
    'git.branch': 'master',
    'git.repository': 'azerothcore/azerothcore-wotlk',
    'module.ah_bot': False,
    'module.ah_bot.seller.enabled': False,
    'module.ah_bot.buyer.enabled': False,
    'module.ah_bot.seller.use_buyprice': False,
    'module.ah_bot.buyer.use_buyprice': False,
    'module.ah_bot.account_id': 0,
    'module.ah_bot.character_guid': 0,
    'module.ah_bot.items_per_cycle': 200,
    'module.ah_bot.max_item_level': 0,
    'module.appreciation': False,
    'module.appreciation.require_certificate': True,
    'module.appreciation.level_boost.enabled': True,
    'module.appreciation.level_boost.level': 60,
    'module.appreciation.level_boost.included_copper': 2500000,
    'module.appreciation.unlock_continents.enabled': True,
    'module.appreciation.unlock_continents.eastern_kingdoms': True,
    'module.appreciation.unlock_continents.kalimdor': True,
    'module.appreciation.unlock_continents.outland': True,
    'module.appreciation.unlock_continents.northrend': False,
    'module.appreciation.reward_at_max_level': False,
    'module.archmage_timear': False,
    'module.assistant': False,
    'module.assistant.heirlooms.enabled': True,
    'module.assistant.glyphs.enabled': True,
    'module.assistant.gems.enabled': True,
    'module.assistant.containers.enabled': True,
    'module.assistant.utilities.enabled': True,
    'module.assistant.utilities.name_change.cost': 100000,
    'module.assistant.utilities.customize.cost': 500000,
    'module.assistant.utilities.race_change.cost': 5000000,
    'module.assistant.utilities.faction_change.cost': 10000000,
    'module.assistant.flightpaths.vanilla.enabled': True,
    'module.assistant.flightpaths.vanilla.required_level': 60,
    'module.assistant.flightpaths.vanilla.cost': 250000,
    'module.assistant.flightpaths.burning_crusade.enabled': True,
    'module.assistant.flightpaths.burning_crusade.required_level': 70,
    'module.assistant.flightpaths.burning_crusade.cost': 1000000,
    'module.assistant.flightpaths.wrath_of_the_lich_king.enabled': False,
    'module.assistant.flightpaths.wrath_of_the_lich_king.required_level': 80,
    'module.assistant.flightpaths.wrath_of_the_lich_king.cost': 2500000,
    'module.assistant.professions.apprentice.enabled': True,
    'module.assistant.professions.apprentice.cost': 1000000,
    'module.assistant.professions.journeyman.enabled': True,
    'module.assistant.professions.journeyman.cost': 2500000,
    'module.assistant.professions.expert.enabled': True,
    'module.assistant.professions.expert.cost': 5000000,
    'module.assistant.professions.artisan.enabled': True,
    'module.assistant.professions.artisan.cost': 7500000,
    'module.assistant.professions.master.enabled': False,
    'module.assistant.professions.master.cost': 12500000,
    'module.assistant.professions.grand_master.enabled': False,
    'module.assistant.professions.grand_master.cost': 25000000,
    'module.assistant.instances.enabled': True,
    'module.assistant.instances.heroic.enabled': True,
    'module.assistant.instances.heroic.cost': 100000,
    'module.assistant.instances.raid.enabled': True,
    'module.assistant.instances.raid.cost': 1000000,
    'module.groupquests': False,
    'module.junktogold': False,
    'module.learnspells': False,
    'module.learnspells.gamemasters': False,
    'module.learnspells.class_spells': True,
    'module.learnspells.talent_ranks': True,
    'module.learnspells.proficiencies': True,
    'module.learnspells.spells_from_quests': True,
    'module.learnspells.riding.apprentice': False,
    'module.learnspells.riding.journeyman': False,
    'module.learnspells.riding.expert': False,
    'module.learnspells.riding.artisan': False,
    'module.learnspells.riding.cold_weather_flying': False,
    'module.playerbots': False,
    'module.playerbots.random_bots.accounts': 200,
    'module.playerbots.random_bots.minimum': 50,
    'module.playerbots.random_bots.maximum': 50,
    'module.playerbots.random_bots.min_level': 1,
    'module.playerbots.random_bots.max_level': 80,
    'module.playerbots.random_bots.disable_death_knight': False,
    'module.playerbots.random_bots.disable_random_levels': False,
    'module.playerbots.random_bots.starting_level': 5,
    'module.playerbots.random_bots.autogear_quality_limit': 3,
    'module.playerbots.random_bots.autogear_score_limit': 0,
    'module.playerbots.random_bots.group_with_nearby': False,
    'module.playerbots.random_bots.enabled_maps': '0,1,530,571',
    'module.playerbots.random_bots.auto_join_battlegrounds': False,
    'module.playerbots.random_bots.auto_join_battlegrounds.warsong_gulch.bracket': 7,
    'module.playerbots.random_bots.auto_join_battlegrounds.warsong_gulch.instances': 0,
    'module.playerbots.random_bots.arena_teams.2v2': 10,
    'module.playerbots.random_bots.arena_teams.3v3': 10,
    'module.playerbots.random_bots.arena_teams.5v5': 5,
    'module.playerbots.max_added': 40,
    'module.playerbots.max_added_per_class': 40,
    'module.playerbots.allow_player_bots': False,
    'module.playerbots.self_bot_level': 1,
    'module.playerbots.allow_summon_in_combat': True,
    'module.playerbots.allow_summon_when_master_dead': True,
    'module.playerbots.allow_summon_when_bot_dead': True,
    'module.playerbots.revive_when_summoned': 1,
    'module.playerbots.repair_when_summoned': True,
    'module.playerbots.say_when_collecting_items': True,
    'module.playerbots.auto_avoid_aoe': True,
    'module.playerbots.tell_when_avoid_aoe': True,
    'module.playerbots.autogear_quality_limit': 3,
    'module.playerbots.autogear_score_limit': 0,
    'module.playerbots.limit_enchant_by_expansion': True,
    'module.playerbots.limit_gear_by_expansion': True,
    'module.playerbots.equipment_persistence.enabled': False,
    'module.playerbots.equipment_persistence.level': 80,
    'module.playerbots.bots_active_alone': 100,
    'module.progression': False,
    'module.progression.aura': 4,
    'module.progression.patch': 21,
    'module.progression.reset': False,
    'module.progression.multiplier.damage': 0.6,
    'module.progression.multiplier.healing': 0.5,
    'module.recruitafriend': False,
    'module.recruitafriend.duration': 90,
    'module.recruitafriend.max_account_age': 7,
    'module.recruitafriend.rewards.days': 30,
    'module.recruitafriend.rewards.swift_zhevra': True,
    'module.recruitafriend.rewards.touring_rocket': True,
    'module.recruitafriend.rewards.celestial_steed': True,
    'module.skip_dk_starting_area': False,
    'module.weekendbonus': False,
    'telegram.chat_id': '0',
    'telegram.token': '0',
    'world.id': 1,
    'world.address': '127.0.0.1',
    'world.allow_player_commands': True,
    'world.game_type': 0,  # 0 (Normal), 1 (PVP) - See GameType in worldserver.conf
    'world.enable_daze': True,
    'world.expansion': 2, # 0 (Vanilla), 1 (The Burning Crusade), 2 (Wrath of the Lich King)
    'world.local_address': '127.0.0.1',
    'world.data_directory': '.',
    'world.name': 'AzerothCore',
    'world.port': 8085,
    'world.preload_grids': False,
    'world.realm_zone': 1, # 1 (Development), 8 (English) - See RealmZone in worldserver.conf
    'world.set_creatures_active': False,
    'world.warden': True
}

modules = [
    [ 'module.ah_bot', settings['module.ah_bot'], 'azerothcore/mod-ah-bot', 'master', 'mod-ah-bot' ],
    [ 'module.appreciation', settings['module.appreciation'], 'noisiver/mod-appreciation', 'master', 'mod-appreciation' ],
    [ 'module.archmage_timear', settings['module.archmage_timear'], 'noisiver/mod-archmage-timear', 'master', 'mod-archmage-timear' ],
    [ 'module.assistant', settings['module.assistant'], 'noisiver/mod-assistant', 'master', 'mod-assistant' ],
    [ 'module.groupquests', settings['module.groupquests'], 'noisiver/mod-groupquests', 'master', 'mod-groupquests' ],
    [ 'module.junktogold', settings['module.junktogold'], 'noisiver/mod-junk-to-gold', 'master', 'mod-junk-to-gold' ],
    [ 'module.learnspells', settings['module.learnspells'], 'noisiver/mod-learnspells', 'master', 'mod-learnspells' ],
    [ 'module.playerbots', settings['module.playerbots'], 'liyunfan1223/mod-playerbots', 'master', 'mod-playerbots' ],
    [ 'module.progression', settings['module.progression'], 'noisiver/mod-progression', 'master', 'mod-progression' ],
    [ 'module.recruitafriend', settings['module.recruitafriend'], 'noisiver/mod-recruitafriend', 'master', 'mod-recruitafriend' ],
    [ 'module.skip_dk_starting_area', settings['module.skip_dk_starting_area'], 'noisiver/mod-skip-dk-starting-area', 'noisiver', 'mod-skip-dk-starting-area' ],
    [ 'module.weekendbonus', settings['module.weekendbonus'], 'noisiver/mod-weekendbonus', 'master', 'mod-weekendbonus' ]
]

windows_paths = {
    'msbuild': 'C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/MSBuild/Current/Bin',
    'mysql': 'C:/Program Files/MySQL/MySQL Server 8.4',
    'openssl': 'C:/Program Files/OpenSSL-Win64',
    'cmake': 'C:/Program Files/CMake'
}

#
#######################################################################
