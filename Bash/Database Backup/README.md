# Database Backup
This is the backup script I use to perform a full backup of all databases from my MariaDB server.

I run a server for Vanilla, one for The Burning Crusade, one for Wrath of the Lich King and one for Cataclysm. I, because of this, need the script to export everything except the default mysql databases and databases that does not contain the word 'world', 'logs' or 'hotfixes and then compress it.

# Usage
The script is run by using ./backup.sh after changing the settings within the backup.xml file (copy backup.xml.dist to backup.xml if needed).

# Credit
All respect goes to the amazing people developing the core for us to use.

Anyone is free to use this content for themselves or on a public server, but do not take credit for the code.
