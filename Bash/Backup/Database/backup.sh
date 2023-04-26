#!/bin/bash
DISTRIBUTION=("debian11" "ubuntu20.04" "ubuntu20.10" "ubuntu21.04" "ubuntu21.10" "ubuntu22.04")

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
MYSQL_CNF="$ROOT/mysql.cnf"

# A function to install the options package
function options_package
{
    # Different distributions are handled in their own way. This is unnecessary but will help if other distributions are added in the future
    if [[ $OS == "ubuntu" ]] || [[ $OS == "debian" ]]; then
        # Check if the package is installed
        if [ $(dpkg-query -W -f='${Status}' libxml2-utils 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            clear

            # Perform an update to make sure nothing is missing
            if [[ $EUID != 0 ]]; then
                sudo apt-get --yes update
            else
                apt-get --yes update
            fi

            # Install the package that is missing
            if [[ $EUID != 0 ]]; then
                sudo apt-get --yes install libxml2-utils
            else
                apt-get --yes install libxml2-utils
            fi
        fi
    fi
}

# A function to install the mysql client package
function database_package
{
    # Different distributions are handled in their own way. This is unnecessary but will help if other distributions are added in the future
    if [[ $OS == "ubuntu" ]] || [[ $OS == "debian" ]]; then
        # Check if the package is installed
        if [ $(dpkg-query -W -f='${Status}' mysql-client 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            clear

            # Perform an update to make sure nothing is missing
            if [[ $EUID != 0 ]]; then
                sudo apt-get --yes update
            else
                apt-get --yes update
            fi

            # Install the package that is missing
            if [[ $EUID != 0 ]]; then
                sudo apt-get --yes install mysql-client
            else
                apt-get --yes install mysql-client
            fi
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
        <mysql>
            <!-- The ip-address or hostname used to connect to the database server -->
            <hostname>${1:-127.0.0.1}</hostname>
            <!-- The port used to connect to the database server -->
            <port>${2:-3306}</port>
            <!-- The username used to connect to the database server -->
            <username>${3:-backup}</username>
            <!-- The password used to connect to the database server -->
            <password>${4:-backup}</password>
        </mysql>
        <local_backups>
            <!-- Enable to store backups locally -->
            <enabled>${5:-true}</enabled>
            <!-- The location to store local backups -->
            <location>${6:-/opt/backup/database/local}</location>
            <!-- The amount of files to save locally -->
            <max_files>${7:-24}</max_files>
        </local_backups>
        <cloud_backups>
            <!-- Enable the use of cloud storage. Note: It has to be set up ahead of time! -->
            <enabled>${8:-false}</enabled>
            <!-- The type of cloud storage to use. Accepted values are gdrive and mega -->
            <type>${9:-gdrive}</type>
            <!-- The location to store cloud backups -->
            <location>${10:-/opt/backup/database/cloud}</location>
            <!-- The amount of files to store on the cloud -->
            <max_files>${11:-24}</max_files>
        </cloud_backups>
    </options>" | xmllint --format - > $OPTIONS
}

# A function that sends all variables to the store_options function
function save_options
{
    store_options \
    $OPTION_MYSQL_HOSTNAME \
    $OPTION_MYSQL_PORT \
    $OPTION_MYSQL_USERNAME \
    $OPTION_MYSQL_PASSWORD \
    $OPTION_LOCAL_BACKUPS_ENABLED \
    $OPTION_LOCAL_BACKUPS_LOCATION \
    $OPTION_LOCAL_BACKUPS_MAX_FILES \
    $OPTION_CLOUD_BACKUPS_ENABLED \
    $OPTION_CLOUD_BACKUPS_TYPE \
    $OPTION_CLOUD_BACKUPS_LOCATION \
    $OPTION_CLOUD_BACKUPS_MAX_FILES
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

    # Load the /options/mysql/hostname option
    OPTION_MYSQL_HOSTNAME="$(echo "cat /options/mysql/hostname/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [ -z $OPTION_MYSQL_HOSTNAME ] || [[ $OPTION_MYSQL_HOSTNAME == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/mysql/hostname is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MYSQL_HOSTNAME="127.0.0.1"
        RESET=true
    fi

    # Load the /options/mysql/port option
    OPTION_MYSQL_PORT="$(echo "cat /options/mysql/port/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MYSQL_PORT =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/mysql/port is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MYSQL_PORT="3306"
        RESET=true
    fi

    # Load the /options/mysql/username option
    OPTION_MYSQL_USERNAME="$(echo "cat /options/mysql/username/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [ -z $OPTION_MYSQL_USERNAME ] || [[ $OPTION_MYSQL_USERNAME == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/mysql/username is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MYSQL_USERNAME="backup"
        RESET=true
    fi

    # Load the /options/mysql/password option
    OPTION_MYSQL_PASSWORD="$(echo "cat /options/mysql/password/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [ -z $OPTION_MYSQL_PASSWORD ] || [[ $OPTION_MYSQL_PASSWORD == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/mysql/password is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MYSQL_PASSWORD="backup"
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
        OPTION_LOCAL_BACKUPS_LOCATION="/opt/backup/database/local"
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

    # Load the /options/cloud_backups/enabled option
    OPTION_CLOUD_BACKUPS_ENABLED="$(echo "cat /options/cloud_backups/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_CLOUD_BACKUPS_ENABLED != "true" && $OPTION_CLOUD_BACKUPS_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/cloud_backups/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_CLOUD_BACKUPS_ENABLED="false"
        RESET=true
    fi

    # Load the /options/cloud_backups/type option
    OPTION_CLOUD_BACKUPS_TYPE="$(echo "cat /options/cloud_backups/type/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_CLOUD_BACKUPS_TYPE != "gdrive" && $OPTION_CLOUD_BACKUPS_TYPE != "mega" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/cloud_backups/type is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_CLOUD_BACKUPS_TYPE="gdrive"
        RESET=true
    fi

    # Load the /options/cloud_backups/location option
    OPTION_CLOUD_BACKUPS_LOCATION="$(echo "cat /options/cloud_backups/location/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [ -z $OPTION_CLOUD_BACKUPS_LOCATION ] || [[ $OPTION_CLOUD_BACKUPS_LOCATION == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/cloud_backups/location is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_CLOUD_BACKUPS_LOCATION="/opt/backup/database/cloud"
        RESET=true
    fi

    # Load the /options/cloud_backups/max_files option
    OPTION_CLOUD_BACKUPS_MAX_FILES="$(echo "cat /options/cloud_backups/max_files/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_CLOUD_BACKUPS_MAX_FILES =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/cloud_backups/max_files is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_CLOUD_BACKUPS_MAX_FILES="24"
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

# A function to export all database tables
function backup_database
{
    # Make sure all required packages are installed
    database_package

    clear

    printf "${COLOR_GREEN}Backing up the databases...${COLOR_END}\n"

    # Create the mysql.cnf file to prevent warnings during import
    echo "[client]" > $MYSQL_CNF
    echo "host=\"$OPTION_MYSQL_HOSTNAME\"" >> $MYSQL_CNF
    echo "port=\"$OPTION_MYSQL_PORT\"" >> $MYSQL_CNF
    echo "user=\"$OPTION_MYSQL_USERNAME\"" >> $MYSQL_CNF
    echo "password=\"$OPTION_MYSQL_PASSWORD\"" >> $MYSQL_CNF

    # Check if the temporary folder already exists
    if [[ -d $ROOT/tmp ]]; then
        # Remove the temporary folder
        rm -rf $ROOT/tmp
    fi

    # Check to make sure a backup for the current date and time doesn't exist already
    if [[ $OPTION_LOCAL_BACKUPS_ENABLED == "true" && ! -f $OPTION_LOCAL_BACKUPS_LOCATION/$BACKUP_DATE.tar.gz ]] || [[ $OPTION_CLOUD_BACKUPS_ENABLED == "true" && ! -f $OPTION_CLOUD_BACKUPS_LOCATION/$BACKUP_DATE.tar.gz ]]; then
        # Make sure we can connect to the database server
        if [[ -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names -e "SHOW DATABASES;"` ]]; then
            # We can't access the database
            printf "${COLOR_RED}The database server at $OPTION_MYSQL_HOSTNAME is inaccessible by user $OPTION_MYSQL_USERNAME.${COLOR_END}\n"

            # Remove the mysql conf
            rm -rf $MYSQL_CNF

            # Terminate script on error
            exit $?
        fi

        # Get the list of databases to export
        DATABASES="$(mysql --defaults-extra-file=$MYSQL_CNF -Bse 'SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME NOT IN ("'information_schema'", "'mysql'", "'performance_schema'", "'sys'", "'phpmyadmin'", "'aowow'") AND SCHEMA_NAME NOT LIKE "'%world%'"')"

        # Loop through each database
        for DATABASE in $DATABASES; do
            printf "${COLOR_ORANGE}Backing up database $DATABASE${COLOR_END}\n"

            # Create the temporary folder
            mkdir -p $ROOT/tmp/$BACKUP_DATE/$DATABASE

            # Loop through each table
            for TABLE in `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names -e "SHOW TABLES FROM $DATABASE"`; do
                # Export the table data
                mysqldump --defaults-extra-file=$MYSQL_CNF --hex-blob $DATABASE $TABLE > $ROOT/tmp/$BACKUP_DATE/$DATABASE/$TABLE.sql

                # Stop the script on error
                if [ $? -ne 0 ]; then
                    exit $?
                fi
            done
        done

        # Switch to the temporary folder
        cd $ROOT/tmp/$BACKUP_DATE

        printf "${COLOR_ORANGE}Creating the compressed archive${COLOR_END}\n"

        # Create the compressed archive
        tar -czvf $ROOT/tmp/$BACKUP_DATE.tar.gz * > /dev/null 2>&1

        # Stop the script on error
        if [ $? -ne 0 ]; then
            exit $?
        fi

        # Check if the local storage is enabled
        if [ $OPTION_LOCAL_BACKUPS_ENABLED == "true" ]; then
            # Check if the local storage folder exists
            if [[ ! -d $OPTION_LOCAL_BACKUPS_LOCATION ]]; then
                # Create the folder
                mkdir -p $OPTION_LOCAL_BACKUPS_LOCATION
            fi

            printf "${COLOR_ORANGE}Copying the archive to the local storage${COLOR_END}\n"

            # Copy the archive to the local storage
            cp -r $ROOT/tmp/$BACKUP_DATE.tar.gz $OPTION_LOCAL_BACKUPS_LOCATION/$BACKUP_DATE.tar.gz

            MAX_LOCAL_FILES=$((OPTION_LOCAL_BACKUPS_MAX_FILES + 1))
            ls -tp $OPTION_LOCAL_BACKUPS_LOCATION/* | grep -v '/$' | tail -n +$MAX_LOCAL_FILES | xargs -d '\n' -r rm --
        fi

        # Check if the local storage is enabled
        if [ $OPTION_CLOUD_BACKUPS_ENABLED == "true" ]; then
            # Check if the local storage folder exists
            if [[ ! -d $OPTION_CLOUD_BACKUPS_LOCATION ]]; then
                # Create the folder
                mkdir -p $OPTION_CLOUD_BACKUPS_LOCATION
            fi

            # Check if google drive is used
            if [[ $OPTION_CLOUD_BACKUPS_TYPE == "gdrive" ]]; then
                # Switch to the google drive folder
                cd $OPTION_CLOUD_BACKUPS_TYPE

                # Download any changes from google drive
                /snap/bin/drive pull -no-prompt > /dev/null 2>&1

                # Stop the script on error
                if [ $? -ne 0 ]; then
                    exit $?
                fi
            fi

            # Copy the archive to the local storage
            cp -r $ROOT/tmp/$BACKUP_DATE.tar.gz $OPTION_CLOUD_BACKUPS_LOCATION/$BACKUP_DATE.tar.gz

            MAX_CLOUD_FILES=$((OPTION_CLOUD_BACKUPS_MAX_FILES + 1))
            ls -tp $OPTION_CLOUD_BACKUPS_LOCATION/* | grep -v '/$' | tail -n +$MAX_CLOUD_FILES | xargs -d '\n' -r rm --

            # Check what type of cloud storage is used
            if [[ $OPTION_CLOUD_BACKUPS_TYPE == "gdrive" ]]; then
                # Switch to the google drive folder
                cd $OPTION_CLOUD_BACKUPS_LOCATION

                # Upload all changes to google drive
                /snap/bin/drive push -no-prompt > /dev/null 2>&1

                # Stop the script on error
                if [ $? -ne 0 ]; then
                    exit $?
                fi

                # Empty the google drive trash
                /snap/bin/drive emptytrash -no-prompt > /dev/null 2>&1

                # Stop the script on error
                if [ $? -ne 0 ]; then
                    exit $?
                fi
            elif [[ $OPTION_CLOUD_BACKUPS_TYPE == "mega" ]]; then
                mega-put $OPTION_CLOUD_BACKUPS_LOCATION /

                MEGA_DIRECTORY=${OPTION_CLOUD_BACKUPS_LOCATION##*/}
                MEGA_FILE_COUNT=$(mega-ls /$MEGA_DIRECTORY | wc -l)
                MEGA_REMOVED_FILE_COUNT=$((MEGA_FILE_COUNT - OPTION_CLOUD_BACKUPS_MAX_FILES))

                if [[ $MEGA_REMOVED_FILE_COUNT > 0 ]]; then
                    for f in `mega-ls /$MEGA_DIRECTORY | head -n $MEGA_REMOVED_FILE_COUNT`; do
                        mega-rm -r -f /$MEGA_DIRECTORY/$f
                    done
                fi
            fi
        fi

        # Remove the temporary folder
        rm -rf $ROOT/tmp
    else
        if [[ $OPTION_LOCAL_BACKUPS_ENABLED == "false" && $OPTION_CLOUD_BACKUPS_ENABLED == "false" ]]; then
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
backup_database
