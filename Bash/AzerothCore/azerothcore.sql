DROP TABLE IF EXISTS `realm_settings`;
CREATE TABLE `realm_settings` (
	`id` INT(10) NOT NULL DEFAULT '-1',
	`setting` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`value` TEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`, `node`, `setting`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

INSERT INTO `realm_settings` (`id`, `setting`, `value`) VALUES
(-1, 'build.auth', 'true'),
(-1, 'build.world', 'true'),
(-1, 'database.auth', 'acore_auth'),
(-1, 'database.characters', 'acore_characters'),
(-1, 'database.playerbots', 'acore_playerbots'),
(-1, 'database.world', 'acore_world'),
(-1, 'git.branch', 'master'),
(-1, 'git.repository', 'azerothcore/azerothcore-wotlk'),
(-1, 'module.ah_bot', 'false'),
(-1, 'module.appreciation', 'false'),
(-1, 'module.appreciation.level_boost.level', '60'),
(-1, 'module.archmage_timear', 'false'),
(-1, 'module.assistant', 'false'),
(-1, 'module.groupquests', 'false'),
(-1, 'module.junktogold', 'false'),
(-1, 'module.learnspells', 'false'),
(-1, 'module.playerbots', 'false'),
(-1, 'module.playerbots.bots', '50'),
(-1, 'module.progression', 'false'),
(-1, 'module.progression.aura', '4'),
(-1, 'module.progression.patch', '21'),
(-1, 'module.recruitafriend', 'false'),
(-1, 'module.skip_dk_starting_area', 'false'),
(-1, 'module.weekendbonus', 'false'),
(-1, 'telegram.chat_id', '0'),
(-1, 'telegram.token', '0'),
(-1, 'world.address', '127.0.0.1'),
(-1, 'world.data_directory', '.'),
(-1, 'world.name', 'AzerothCore'),
(-1, 'world.port', '8085'),
(-1, 'world.preload_grids', 'false'),
(-1, 'world.set_creatures_active', 'false'),
(-1, 'world.warden', 'true');
