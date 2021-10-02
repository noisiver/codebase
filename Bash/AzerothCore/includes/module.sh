#!/bin/bash
function transfer_lua_scripts
{
    if [[ $MODULE_ELUNA_ENABLED == "true" ]] && [[ -d $ROOT/lua ]] && [[ ! -z "$(ls -A $ROOT/lua/)" ]]; then
        clear

        printf "${COLOR_GREEN}Copying lua scripts${COLOR_END}\n"

        if [[ -d $CORE_DIRECTORY/bin/lua_scripts ]]; then
            rm -rf $CORE_DIRECTORY/bin/lua_scripts
        fi

        if [[ ! -d $CORE_DIRECTORY/bin/lua_scripts ]]; then
            mkdir $CORE_DIRECTORY/bin/lua_scripts
        fi

        for f in $ROOT/lua/*; do
            if [ -d $f ]; then
                printf "${COLOR_ORANGE}Copying directory "$(basename $f)"${COLOR_END}\n"
            else
                printf "${COLOR_ORANGE}Copying file "$(basename $f)"${COLOR_END}\n"
            fi

            cp -r $f $CORE_DIRECTORY/bin/lua_scripts/
        done
    fi
}
