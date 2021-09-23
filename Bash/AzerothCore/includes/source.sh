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

    echo "#!/bin/bash" > $CORE_DIRECTORY/bin/start.sh
    echo "#!/bin/bash" > $CORE_DIRECTORY/bin/stop.sh

    if [ $1 == 0 ] || [ $1 == 1 ]; then
        echo "screen -AmdS auth ./auth.sh" >> $CORE_DIRECTORY/bin/start.sh
        echo "screen -X -S \"auth\" quit" >> $CORE_DIRECTORY/bin/stop.sh

        echo "#!/bin/sh" > $CORE_DIRECTORY/bin/auth.sh
        echo "while :; do" >> $CORE_DIRECTORY/bin/auth.sh
        echo "./authserver" >> $CORE_DIRECTORY/bin/auth.sh
        echo "sleep 20" >> $CORE_DIRECTORY/bin/auth.sh
        echo "done" >> $CORE_DIRECTORY/bin/auth.sh

        chmod +x $CORE_DIRECTORY/bin/auth.sh
    else
        if [ -f $CORE_DIRECTORY/bin/auth.sh ]; then
            rm -rf $CORE_DIRECTORY/bin/auth.sh
        fi
    fi

    if [ $1 == 0 ] || [ $1 == 2 ]; then
        echo "screen -AmdS world ./world.sh" >> $CORE_DIRECTORY/bin/start.sh
        echo "screen -X -S \"world\" quit" >> $CORE_DIRECTORY/bin/stop.sh

        echo "#!/bin/sh" > $CORE_DIRECTORY/bin/world.sh
        echo "while :; do" >> $CORE_DIRECTORY/bin/world.sh
        echo "./worldserver" >> $CORE_DIRECTORY/bin/world.sh
        echo "sleep 20" >> $CORE_DIRECTORY/bin/world.sh
        echo "done" >> $CORE_DIRECTORY/bin/world.sh

        chmod +x $CORE_DIRECTORY/bin/world.sh
    else
        if [ -f $CORE_DIRECTORY/bin/world.sh ]; then
            rm -rf $CORE_DIRECTORY/bin/world.sh
        fi
    fi

    chmod +x $CORE_DIRECTORY/bin/start.sh
    chmod +x $CORE_DIRECTORY/bin/stop.sh
}

function fetch_client_data
{
    if [ ! -d $CORE_DIRECTORY/bin/Cameras ] || [ ! -d $CORE_DIRECTORY/bin/dbc ] || [ ! -d $CORE_DIRECTORY/bin/maps ] || [ ! -d $CORE_DIRECTORY/bin/mmaps ] || [ ! -d $CORE_DIRECTORY/bin/vmaps ]; then
        CORE_INSTALLED_CLIENT_DATA=0
    fi

    if [ $CORE_INSTALLED_CLIENT_DATA != $CORE_REQUIRED_CLIENT_DATA ]; then
        if [ -d $CORE_DIRECTORY/bin/Cameras ] || [ -d $CORE_DIRECTORY/bin/dbc ] || [ -d $CORE_DIRECTORY/bin/maps ] || [ -d $CORE_DIRECTORY/bin/mmaps ] || [ -d $CORE_DIRECTORY/bin/vmaps ]; then
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
}
