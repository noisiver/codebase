/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table player_totem_model
DROP TABLE IF EXISTS `player_totem_model`;
CREATE TABLE IF NOT EXISTS `player_totem_model` (
  `TotemSlot` tinyint unsigned NOT NULL,
  `RaceId` tinyint unsigned NOT NULL,
  `DisplayId` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`TotemSlot`,`RaceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table player_totem_model: ~20 rows (approximately)
INSERT INTO `player_totem_model` (`TotemSlot`, `RaceId`, `DisplayId`) VALUES
	(1, 2, 30758),
	(1, 3, 30754),
	(1, 6, 4589),
	(1, 8, 30762),
	(1, 11, 19074),
	(2, 2, 30757),
	(2, 3, 30753),
	(2, 6, 4588),
	(2, 8, 30761),
	(2, 11, 19073),
	(3, 2, 30759),
	(3, 3, 30755),
	(3, 6, 4587),
	(3, 8, 30763),
	(3, 11, 19075),
	(4, 2, 30756),
	(4, 3, 30736),
	(4, 6, 4590),
	(4, 8, 30760),
	(4, 11, 19071);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
