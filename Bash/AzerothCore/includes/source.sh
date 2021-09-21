#!/bin/bash
function clone_source
{
    install_build_packages

    clear

    if [ ! -d $CORE_DIRECTORY ]; then
        git clone --recursive --branch master https://github.com/azerothcore/azerothcore-wotlk.git $CORE_DIRECTORY
        if [ $? -ne 0 ]; then
            exit $?
        fi
    else
        cd $CORE_DIRECTORY

        git fetch --all
        if [ $? -ne 0 ]; then
            exit $?
        fi

        git reset --hard origin/master
        if [ $? -ne 0 ]; then
            exit $?
        fi

        git submodule update
        if [ $? -ne 0 ]; then
            exit $?
        fi
    fi

    if [ $MODULE_ELUNA_ENABLED == "true" ]; then
        if [ ! -d $CORE_DIRECTORY/modules/eluna ]; then
            git clone --recursive --branch master https://github.com/azerothcore/mod-eluna-lua-engine.git $CORE_DIRECTORY/modules/eluna
            if [ $? -ne 0 ]; then
                exit $?
            fi
        else
            cd $CORE_DIRECTORY/modules/eluna

            git fetch --all
            if [ $? -ne 0 ]; then
                exit $?
            fi

            git reset --hard origin/master
            if [ $? -ne 0 ]; then
                exit $?
            fi

            git submodule update
            if [ $? -ne 0 ]; then
                exit $?
            fi
        fi
    else
        if [ -d $CORE_DIRECTORY/modules/eluna ]; then
            rm -rf $CORE_DIRECTORY/modules/eluna

            if [ -d $CORE_DIRECTORY/build ]; then
                rm -rf $CORE_DIRECTORY/build
            fi
        fi
    fi

    if [ $1 ]; then
        if [ $1 == 0 ]; then
            source_menu
        fi
    fi
}

function compile_source
{
    mkdir -p $CORE_DIRECTORY/build && cd $_
    cmake ../ -DCMAKE_INSTALL_PREFIX=$CORE_DIRECTORY -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=0 -DTOOLS=0 -DSCRIPTS=static
    if [ $? -ne 0 ]; then
        exit $?
    fi

    make -j $(nproc)
    if [ $? -ne 0 ]; then
        exit $?
    fi

    make install
    if [ $? -ne 0 ]; then
        exit $?
    fi

    if [ $1 ]; then
        if [ $1 == 0 ]; then
            source_menu
        fi
    fi
}

function fetch_client_data
{
    if [ $CORE_INSTALLED_CLIENT_DATA != $CORE_REQUIRED_CLIENT_DATA ]; then
        if [[ -d $CORE_DIRECTORY/bin/Cameras ]] || [[ -d $CORE_DIRECTORY/bin/dbc ]] || [[ -d $CORE_DIRECTORY/bin/maps ]] || [[ -d $CORE_DIRECTORY/bin/mmaps ]] || [[ -d $CORE_DIRECTORY/bin/vmaps ]]; then
            rm -rf $CORE_DIRECTORY/bin/Cameras $CORE_DIRECTORY/bin/dbc $CORE_DIRECTORY/bin/maps $CORE_DIRECTORY/bin/mmaps $CORE_DIRECTORY/bin/vmaps
        fi

        curl -L https://github.com/wowgaming/client-data/releases/download/v${CORE_REQUIRED_CLIENT_DATA}/data.zip > $CORE_DIRECTORY/bin/data.zip
        if [ $? -ne 0 ]; then
            exit $?
        fi

        unzip -o "$CORE_DIRECTORY/bin/data.zip" -d "$CORE_DIRECTORY/bin/"
        if [ $? -ne 0 ]; then
            exit $?
        fi

        rm -rf $CORE_DIRECTORY/bin/data.zip
        if [ $? -ne 0 ]; then
            exit $?
        fi

        CORE_INSTALLED_CLIENT_DATA=$CORE_REQUIRED_CLIENT_DATA
        generate_settings
    fi

    if [ $1 ]; then
        if [ $1 == 0 ]; then
            source_menu
        fi
    fi
}
