#!/bin/bash
if [[ $OS == "ubuntu" ]] || [[ $OS == "debian" ]]; then
    if [ $(dpkg-query -W -f='${Status}' libxml2-utils 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        clear

        apt-get update -y
        if [ $? -ne 0 ]; then
            exit $?
        fi

        apt-get install -y libxml2-utils
        if [ $? -ne 0 ]; then
            exit $?
        fi
    fi
fi

function install_clone_packages
{
    if [[ $OS == "ubuntu" ]] || [[ $OS == "debian" ]]; then
        if [ $(dpkg-query -W -f='${Status}' git 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            clear

            apt-get update -y
            if [ $? -ne 0 ]; then
                exit $?
            fi

            apt-get install -y git
            if [ $? -ne 0 ]; then
                exit $?
            fi
        fi
    fi
}

function install_compile_packages
{
    if [[ $OS == "ubuntu" ]] || [[ $OS == "debian" ]]; then
        PACKAGES=("cmake" "make" "gcc" "clang" "screen" "curl" "unzip" "g++" "libssl-dev" "libbz2-dev" "libreadline-dev" "libncurses-dev" "libace-6.*" "libace-dev" "libmariadb-dev-compat" "mariadb-client")

        if [[ $OS == "ubuntu" ]]; then
            PACKAGES="${PACKAGES} libboost1.71-all-dev"

            if [[ $VERSION == "20.04" ]] || [[ $VERSION == "20.10" ]]; then
                PACKAGES="${PACKAGES} libmariadbclient-dev"
            fi
        elif [[ $OS == "debian" ]]; then
            PACKAGES="${PACKAGES} libboost1.74-all-dev"
        fi

        for p in "${PACKAGES[@]}"; do
            if [ $(dpkg-query -W -f='${Status}' $p 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
                INSTALL+=($p)
            fi
        done

        if [ ${#INSTALL[@]} -gt 0 ]; then
            clear

            apt-get update -y
            if [ $? -ne 0 ]; then
                exit $?
            fi

            apt-get install -y ${INSTALL[*]}
            if [ $? -ne 0 ]; then
                exit $?
            fi
        fi
    fi
}

function install_database_packages
{
    if [[ $OS == "ubuntu" ]] || [[ $OS == "debian" ]]; then
        if [ $(dpkg-query -W -f='${Status}' mariadb-client 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            clear

            apt-get update -y
            if [ $? -ne 0 ]; then
                exit $?
            fi

            apt-get install -y mariadb-client
            if [ $? -ne 0 ]; then
                exit $?
            fi
        fi
    fi
}
