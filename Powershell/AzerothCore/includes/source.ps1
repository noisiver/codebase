function Clone-Source
{
    Clear-Host
    Write-Host -ForegroundColor Green "Downloading the source code"

    if (-not (Test-Path -PathType Container -Path "$root\source"))
    {
        git clone --recursive --branch master https://github.com/azerothcore/azerothcore-wotlk.git $root\source
        if (-not $?)
        {
            cd $root
            Write-Host -ForegroundColor Red "An error has occured"
        }
    }
    else
    {
        cd $root\source

        git fetch --all
        if (-not $?)
        {
            cd $root
            Write-Host -ForegroundColor Red "An error has occured"
        }

        git reset --hard origin/master
        if (-not $?)
        {
            cd $root
            Write-Host -ForegroundColor Red "An error has occured"
        }

        git submodule update
        if (-not $?)
        {
            cd $root
            Write-Host -ForegroundColor Red "An error has occured"
        }
    }

    if ($xml.config.world.module.ahbot.enabled -eq "true")
    {
        if (-not (Test-Path -PathType Container -Path "$root\source\modules\mod-ah-bot"))
        {
            git clone --recursive --branch master https://github.com/azerothcore/mod-ah-bot.git $root\source\modules\mod-ah-bot
            if (-not $?)
            {
                cd $root
                Write-Host -ForegroundColor Red "An error has occured"
            }
        }
        else
        {
            cd $root\source\modules\mod-ah-bot

            git fetch --all
            if (-not $?)
            {
                cd $root
                Write-Host -ForegroundColor Red "An error has occured"
            }

            git reset --hard origin/master
            if (-not $?)
            {
                cd $root
                Write-Host -ForegroundColor Red "An error has occured"
            }

            git submodule update
            if (-not $?)
            {
                cd $root
                Write-Host -ForegroundColor Red "An error has occured"
            }
        }
    }
    else
    {
        if (Test-Path -PathType Container -Path "$root\source\modules\mod-ah-bot")
        {
            Remove-Item -Recurse -Force $root\source\modules\mod-ah-bot
            if (-not $?)
            {
                cd $root
                Write-Host -ForegroundColor Red "An error has occured"
            }

            if (Test-Path -PathType Container -Path "$root\source\build")
            {
                Remove-Item -Recurse -Force $root\source\build
                if (-not $?)
                {
                    cd $root
                    Write-Host -ForegroundColor Red "An error has occured"
                }
            }
        }
    }

    if ($xml.config.world.module.eluna.enabled -eq "true")
    {
        if (-not (Test-Path -PathType Container -Path "$root\source\modules\eluna"))
        {
            git clone --recursive --branch master https://github.com/azerothcore/mod-eluna-lua-engine.git $root\source\modules\eluna
            if (-not $?)
            {
                cd $root
                Write-Host -ForegroundColor Red "An error has occured"
            }
        }
        else
        {
            cd $root\source\modules\eluna

            git fetch --all
            if (-not $?)
            {
                cd $root
                Write-Host -ForegroundColor Red "An error has occured"
            }

            git reset --hard origin/master
            if (-not $?)
            {
                cd $root
                Write-Host -ForegroundColor Red "An error has occured"
            }

            git submodule update
            if (-not $?)
            {
                cd $root
                Write-Host -ForegroundColor Red "An error has occured"
            }
        }
    }
    else
    {
        if (Test-Path -PathType Container -Path "$root\source\modules\eluna")
        {
            Remove-Item -Recurse -Force $root\source\modules\eluna
            if (-not $?)
            {
                cd $root
                Write-Host -ForegroundColor Red "An error has occured"
            }

            if (Test-Path -PathType Container -Path "$root\source\build")
            {
                Remove-Item -Recurse -Force $root\source\build
                if (-not $?)
                {
                    cd $root
                    Write-Host -ForegroundColor Red "An error has occured"
                }
            }
        }
    }

    cd $root
}

function Compile-Source
{
    Clear-Host
    Write-Host -ForegroundColor Green "Compiling the source code"

    New-Item -ItemType Directory -Force -Path $root\source\build | Out-Null

    cd $root\source\build

    cmake ../ -DCMAKE_INSTALL_PREFIX=$root\source -DWITH_WARNINGS=0 -DTOOLS=0 -DSCRIPTS=static
    if (-not $?)
    {
        cd $root
        Write-Host -ForegroundColor Red "An error has occured"
    }

    MSBuild.exe AzerothCore.sln /t:Clean
    if (-not $?)
    {
        cd $root
        Write-Host -ForegroundColor Red "An error has occured"
    }

    MSBuild.exe AzerothCore.sln /p:Configuration=Release
    if (-not $?)
    {
        cd $root
        Write-Host -ForegroundColor Red "An error has occured"
    }

    cd $root
}
