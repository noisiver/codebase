#!/bin/bash
DISTRIBUTION=("debian11" "ubuntu20.04" "ubuntu20.10" "ubuntu21.04" "ubuntu21.10")

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID

    if [[ ! " ${DISTRIBUTION[@]} " =~ " ${OS}${VERSION} " ]]; then
        echo -e "\e[0;31mThis distribution is currently not supported\e[0m"
        exit $?
    fi
fi

# Define colors for easier access
COLOR_BLACK="\e[0;30m"
COLOR_RED="\e[0;31m"
COLOR_GREEN="\e[0;32m"
COLOR_ORANGE="\e[0;33m"
COLOR_BLUE="\e[0;34m"
COLOR_PURPLE="\e[0;35m"
COLOR_CYAN="\e[0;36m"
COLOR_LIGHT_GRAY="\e[0;37m"
COLOR_DARK_GRAY="\e[1;30m"
COLOR_LIGHT_RED="\e[1;31m"
COLOR_LIGHT_GREEN="\e[1;32m"
COLOR_YELLOW="\e[1;33m"
COLOR_LIGHT_BLUE="\e[1;34m"
COLOR_LIGHT_PURPLE="\e[1;35m"
COLOR_LIGHT_CYAN="\e[1;36m"
COLOR_WHITE="\e[1;37m"
COLOR_END="\e[0m"

# Define the current directory
ROOT=$(pwd)

# Define the current date and time
BACKUP_DATE=$(date +"%Y-%m-%d_%H-%M")

# Define required files
OPTIONS="$ROOT/options.xml"

# A function to install the options package
function options_package
{
    # Different distributions are handled in their own way. This is unnecessary but will help if other distributions are added in the future
    if [[ $OS == "ubuntu" ]] || [[ $OS == "debian" ]]; then
        # Check if the package is installed
        if [ $(dpkg-query -W -f='${Status}' libxml2-utils 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            clear

            # Perform an update to make sure nothing is missing
            apt-get --yes update
            if [ $? -ne 0 ]; then
                exit $?
            fi

            # Install the package that is missing
            apt-get --yes install libxml2-utils
            if [ $? -ne 0 ]; then
                exit $?
            fi
        fi
    fi
}

# A function to save all options to the file
function store_options
{
    echo "<?xml version=\"1.0\"?>
    <options>
        <!-- The location where the archives created by amp are stored -->
        <backup_location>${1:-/home/amp/.ampdata/instances/ADS01/Backups}</backup_location>
        <local_backups>
            <!-- Enable to store backups locally -->
            <enabled>${1:-true}</enabled>
            <!-- The location to store local backups -->
            <location>${2:-/opt/backup/amp}</location>
            <!-- The amount of files to save locally -->
            <max_files>${3:-24}</max_files>
        </local_backups>
        <gdrive_backups>
            <!-- Enable the use of google drive. Note: It has to be set up ahead of time! -->
            <enabled>${4:-false}</enabled>
            <!-- The amount of files to store on google drive -->
            <max_files>${5:-24}</max_files>
        </gdrive_backups>
    </options>" | xmllint --format - > $OPTIONS
}

# A function that sends all variables to the store_options function
function save_options
{
    store_options \
    $OPTION_BACKUP_LOCATION \
    $OPTION_LOCAL_BACKUPS_ENABLED \
    $OPTION_LOCAL_BACKUPS_LOCATION \
    $OPTION_LOCAL_BACKUPS_MAX_FILES \
    $OPTION_GDRIVE_BACKUPS_ENABLED \
    $OPTION_GDRIVE_BACKUPS_MAX_FILES
}

# A function that loads options from the file
function load_options
{
    # Install required package
    options_package

    # Check if the file is missing
    if [ ! -f $OPTIONS ]; then
        # Create the file with the default options
        printf "${COLOR_RED}The options file is missing. Creating one with the default options.${COLOR_END}\n"
        printf "${COLOR_RED}Make sure to edit it to prevent issues that might occur otherwise.${COLOR_END}\n"
        store_options
        exit $?
    fi

    # Load the /options/backup_location option
    OPTION_BACKUP_LOCATION="$(echo "cat /options/backup_location/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [ -z $OPTION_BACKUP_LOCATION ] || [[ $OPTION_BACKUP_LOCATION == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/backup_location is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_BACKUP_LOCATION="/home/amp/.ampdata/instances/ADS01/Backups"
        RESET=true
    fi

    # Load the /options/local_backups/enabled option
    OPTION_LOCAL_BACKUPS_ENABLED="$(echo "cat /options/local_backups/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_LOCAL_BACKUPS_ENABLED != "true" && $OPTION_LOCAL_BACKUPS_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/local_backups/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_LOCAL_BACKUPS_ENABLED="false"
        RESET=true
    fi

    # Load the /options/local_backups/location option
    OPTION_LOCAL_BACKUPS_LOCATION="$(echo "cat /options/local_backups/location/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [ -z $OPTION_LOCAL_BACKUPS_LOCATION ] || [[ $OPTION_LOCAL_BACKUPS_LOCATION == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/local_backups/location is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_LOCAL_BACKUPS_LOCATION="/opt/backup/database"
        RESET=true
    fi

    # Load the /options/local_backups/max_files option
    OPTION_LOCAL_BACKUPS_MAX_FILES="$(echo "cat /options/local_backups/max_files/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_LOCAL_BACKUPS_MAX_FILES =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/local_backups/max_files is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_LOCAL_BACKUPS_MAX_FILES="24"
        RESET=true
    fi

    # Load the /options/gdrive_backups/enabled option
    OPTION_GDRIVE_BACKUPS_ENABLED="$(echo "cat /options/gdrive_backups/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_GDRIVE_BACKUPS_ENABLED != "true" && $OPTION_GDRIVE_BACKUPS_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/gdrive_backups/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_GDRIVE_BACKUPS_ENABLED="false"
        RESET=true
    fi

    # Load the /options/gdrive_backups/max_files option
    OPTION_GDRIVE_BACKUPS_MAX_FILES="$(echo "cat /options/gdrive_backups/max_files/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_GDRIVE_BACKUPS_MAX_FILES =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/gdrive_backups/max_files is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_GDRIVE_BACKUPS_MAX_FILES="24"
        RESET=true
    fi

    # Check if any option calls for a reset
    if [ $RESET ]; then
        # Tell the user that the invalid options should be changed, then terminate the script
        printf "${COLOR_RED}Make sure to change the options listed above to prevent any unwanted issues.${COLOR_END}\n"
        save_options
        exit $?
    fi
}

# A function to copy all backups from amp
function backup_amp
{
    clear

    printf "${COLOR_GREEN}Backing up amp...${COLOR_END}\n"

    # Check to make sure a backup for the current date and time doesn't exist already
    if [[ $OPTION_LOCAL_BACKUPS_ENABLED == "true" ]] || [[ $OPTION_GDRIVE_BACKUPS_ENABLED == "true" ]]; then
        # Check if the local storage is enabled
        if [ $OPTION_LOCAL_BACKUPS_ENABLED == "true" ]; then
            # Check if the local storage folder exists
            if [[ ! -d $OPTION_LOCAL_BACKUPS_LOCATION ]]; then
                # Create the folder
                mkdir -p $OPTION_LOCAL_BACKUPS_LOCATION
            fi

            printf "${COLOR_ORANGE}Copying the archives to the local storage${COLOR_END}\n"

            # Copy the archives to the local storage
            cp -n $OPTION_BACKUP_LOCATION/*.zip $OPTION_LOCAL_BACKUPS_LOCATION

            MAX_LOCAL_FILES=$((OPTION_LOCAL_BACKUPS_MAX_FILES + 1))
            ls -tp $OPTION_LOCAL_BACKUPS_LOCATION/* | grep -v '/$' | tail -n +$MAX_LOCAL_FILES | xargs -d '\n' -r rm --
        fi

        # Check if the local storage is enabled
        if [ $OPTION_GDRIVE_BACKUPS_ENABLED == "true" ]; then
            printf "${COLOR_ORANGE}Uploading the archives to google drive${COLOR_END}\n"

            # Switch to the google drive folder
            cd $HOME/gdrive

            # Download any changes from google drive
            drive pull -no-prompt > /dev/null 2>&1

            # Stop the script on error
            if [ $? -ne 0 ]; then
                exit $?
            fi

            # Check if the local storage folder exists
            if [[ ! -d $HOME/gdrive/amp ]]; then
                # Create the folder
                mkdir -p $HOME/gdrive/amp
            fi

            # Copy the archives to google drive
            cp -n $OPTION_BACKUP_LOCATION/*.zip $HOME/gdrive/amp

            MAX_LOCAL_FILES=$((OPTION_GDRIVE_BACKUPS_MAX_FILES + 1))
            ls -tp $HOME/gdrive/amp/* | grep -v '/$' | tail -n +$MAX_LOCAL_FILES | xargs -d '\n' -r rm --

            # Upload all changes to google drive
            drive push -no-prompt > /dev/null 2>&1

            # Stop the script on error
            if [ $? -ne 0 ]; then
                exit $?
            fi


            # Empty the google drive trash
            drive emptytrash -no-prompt > /dev/null 2>&1

            # Stop the script on error
            if [ $? -ne 0 ]; then
                exit $?
            fi

        fi

        # Remove the temporary folder
        rm -rf $ROOT/tmp
    else
        if [[ $OPTION_LOCAL_BACKUPS_ENABLED == "false" && $OPTION_GDRIVE_BACKUPS_ENABLED == "false" ]]; then
            printf "${COLOR_RED}All backup storage options are disabled.${COLOR_END}\n"
        else
            printf "${COLOR_RED}A backup of the current date and time has already been created.${COLOR_END}\n"
        fi
    fi

    printf "${COLOR_GREEN}Finished backing up the databases...${COLOR_END}\n"

    # Remove the mysql conf
    rm -rf $MYSQL_CNF
}

load_options
backup_amp
