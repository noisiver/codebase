#!/bin/bash
DISTRIBUTION=("debian11" "ubuntu20.04" "ubuntu20.10" "ubuntu21.04" "ubuntu21.10")

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID

    if [[ ! " ${DISTRIBUTION[@]} " =~ " ${OS}${VERSION} " ]]; then
        printf "${COLOR_RED}This distribution is currently not supported${COLOR_END}\n"
        exit $?
    fi
fi
