#!/bin/bash
function start_process
{
    clear

    echo -e "\e[0;32mStarting processes\e[0m"

    if [[ -z `screen -list | grep -E "auth"` ]] && [[ -z `screen -list | grep -E "world"` ]]; then
        if [ -f $CORE_DIRECTORY/bin/start.sh ]; then
            echo -e "\e[0;33mStarting the server process\e[0m"

            cd $CORE_DIRECTORY/bin && ./start.sh
        else
            echo -e "\e[0;33mUnable to locate the required executable\e[0m"

            exit $?
        fi
    else
        echo -e "\e[0;33mThe server is already running\e[0m"
    fi
}

function stop_process
{
    clear

    echo -e "\e[0;32mStopping processes\e[0m"

    if [[ ! -z `screen -list | grep -E "world"` ]]; then
        echo -e "\e[0;33mTelling the world server to save\e[0m"

        screen -S world -p 0 -X stuff "saveall^m"

        sleep 3
    fi

    if [[ ! -z `screen -list | grep -E "auth"` ]] || [[ ! -z `screen -list | grep -E "world"` ]]; then
        if [ -f $CORE_DIRECTORY/bin/stop.sh ]; then
            echo -e "\e[0;33mStopping the server process\e[0m"

            cd $CORE_DIRECTORY/bin && ./stop.sh
        else
            echo -e "\e[0;33mUnable to locate the required executable\e[0m"

            exit $?
        fi
    else
        echo -e "\e[0;33mNo running server found\e[0m"
    fi
}
