# AzerothCore
This is the content I use with my World of Warcraft: Wrath of the Lich King (3.3.5a) server. The core I use is [AzerothCore](https://github.com/azerothcore/azerothcore-wotlk).

This script does the following:
- Download the source code and the source of any enabled module
- Compile the source code
- Download the client data files. It will find the latest available version automatically
- Import database tables and updates. It will skip already existing tables to make sure there's no loss in data
- Update configuration files based on values set in the xml file
- Start and stop the server

The script supports Debian 11, Ubuntu 21.04 and Ubuntu 21.10.

I never run the script as anything other than root so I unfortunately will not be adding support for non-root users.

Creating the following folder in the same location as the script will let you automatically import custom content to the world database.
- **sql/world** | *Placing sql queries inside this folder will automatically import them to the world database*

# Commands
Using the script with no parameters, or invalid parameters, will print some information about available parameters and subparameters.

# First time
Running the script for the first time will generate a default options file named options.xml, options-minimal.xml for the minimal version, that you have to edit. Make sure to edit it or the script will fail at some point.

# Credit
All respect goes to the amazing people developing the core for us to use.

Anyone is free to use this content for themselves or on a public server, but do not take credit for the code.
