DELETE FROM `recruit_a_friend_accounts`;
INSERT INTO `recruit_a_friend_accounts` (`account_id`, `recruiter_id`, `status`) VALUES
(4, 3, 2),
(5, 4, 2),
(6, 5, 2),
(7, 6, 2),
(8, 7, 2),
(9, 8, 2),
(10, 9, 2),
(11, 10, 2),
(12, 11, 2);

UPDATE `account` SET `recruiter`=3 WHERE `id`=4;
UPDATE `account` SET `recruiter`=4 WHERE `id`=5;
UPDATE `account` SET `recruiter`=5 WHERE `id`=6;
UPDATE `account` SET `recruiter`=6 WHERE `id`=7;
UPDATE `account` SET `recruiter`=7 WHERE `id`=8;
UPDATE `account` SET `recruiter`=8 WHERE `id`=9;
UPDATE `account` SET `recruiter`=9 WHERE `id`=10;
UPDATE `account` SET `recruiter`=10 WHERE `id`=11;
UPDATE `account` SET `recruiter`=11 WHERE `id`=12;
