DELETE FROM `disables` WHERE `sourceType`=0 AND `entry`=1604;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `comment`) VALUES
(0, 1604, 8, 'Disable Dazed');
