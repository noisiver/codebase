# AzerothCore
This is the content I use with my World of Warcraft: Wrath of the Lich King (3.3.5a) server. The core I use is [AzerothCore](https://github.com/azerothcore/azerothcore-wotlk).

The server is not public, only I play on it and I multibox so things like having group-looted quest items for me is a must. I use the Bash script to manage the server on a few Proxmox Containers running Debian 11. The Authserver and Worldserver can be run on separate systems. I also have a few containers specifically for MySQL-databases, so the script won't handle the MySQL-server.

The script supports Debian 11, Ubuntu 20.04, Ubuntu 20.10, Ubuntu 21.04 and Ubuntu 21.10.

I never run the script as anything other than root so I unfortunately will not be adding support for non-root users.

I should note that everything is tested on Containers (LXC) and might not work properly on a regular installation. If something causes a problem, I'll look into fixing it.

# Commands
Using the script with no parameters, or invalid parameters, will print some information about available parameters and subparameters.

# First time
Running the script for the first time will generate a default options file named options.xml that you can edit. Make sure to edit it or the script will fail at some point.

# Important information
**Do not** download the files inside the core folder. Download only the file named azerothcore.sh and run it.

The script will download the files inside of the core folder automatically. I decided on this approach to easier update the script across all my VMs so I don't have to upload the updated script to each system.

The file named source is what actually runs on the system. The file named version is what tells the main script when there's an update to the source file available.

The only caveat is when I update the base script. That won't happen often, though.

# Credit
All respect goes to the amazing people developing the core for us to use.

Anyone is free to use this content for themselves or on a public server, but do not take credit for the code.
