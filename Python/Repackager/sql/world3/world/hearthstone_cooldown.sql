-- Set a 15 minute cooldown
SET @MINUTES := 15;
SET @COOLDOWN := (@MINUTES * 60000);
UPDATE `item_template` SET `spellcooldown_1`=@COOLDOWN, `spellcategorycooldown_1`=@COOLDOWN WHERE `entry`=6948;
