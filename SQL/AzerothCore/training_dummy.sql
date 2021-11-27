-- Remove the flag from training dummies that prevents skill up
UPDATE `creature_template` SET `flags_extra`=0 WHERE `entry` IN (32666, 32667, 31144, 31146);
