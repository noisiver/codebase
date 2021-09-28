function Main-Menu
{
    Clear-Host
    Write-Host -ForegroundColor Magenta "AzerothCore"
    Write-Host -NoNewLine -ForegroundColor Cyan "1) "
    Write-Host -ForegroundColor Yellow "Manage the source code"
    Write-Host -NoNewLine -ForegroundColor Cyan "2) "
    Write-Host -ForegroundColor Yellow "Manage the databases"
    Write-Host -NoNewLine -ForegroundColor Cyan "3) "
    Write-Host -ForegroundColor Yellow "Manage the configuration options"
    Write-Host -NoNewLine -ForegroundColor Cyan "4) "
    Write-Host -ForegroundColor Yellow "Manage the compiled binaries"
    Write-Host -NoNewLine -ForegroundColor Cyan "0) "
    Write-Host -ForegroundColor Yellow "Exit"

    Write-Host -NoNewLine -ForegroundColor Cyan "Choose an option: "
    $s = Read-Host

    switch ($s)
    {
        1 { Source-Menu }
        2 { Write-Host "Manage the databases" }
        3 { Write-Host "Manage the configuration options" }
        4 { Write-Host "Manage the compiled binaries" }
        0 { Print-Quote }
        default { Main-Menu }

    }
}

function Source-Menu([int]$page)
{
    Clear-Host
    if ($page -eq 0)
    {
        Write-Host -ForegroundColor Magenta "Manage the source code"
        Write-Host -NoNewLine -ForegroundColor Cyan "1) "
        Write-Host -ForegroundColor Yellow "Manage the available modules"
        Write-Host -NoNewLine -ForegroundColor Cyan "2) "
        Write-Host -ForegroundColor Yellow "Download the latest version of the repository"
        Write-Host -NoNewLine -ForegroundColor Cyan "3) "
        Write-Host -ForegroundColor Yellow "Compile the source code into binaries"
        Write-Host -NoNewLine -ForegroundColor Cyan "4) "
        Write-Host -ForegroundColor Yellow "Download the client data files"
        Write-Host -NoNewLine -ForegroundColor Cyan "0) "
        Write-Host -ForegroundColor Yellow "Return to the previous menu"

        Write-Host -NoNewLine -ForegroundColor Cyan "Choose an option: "
        $s = Read-Host

        switch ($s)
        {
            1 { Source-Menu 1 }
            2 { Source-Menu 2 }
            0 { Main-Menu }
            default { Source-Menu 0 }

        }
    }
    elseif ($page -eq 1)
    {
        Write-Host -ForegroundColor Magenta "Manage the available modules"
        Write-Host -NoNewLine -ForegroundColor Cyan "1) "
        Write-Host -NoNewline -ForegroundColor Yellow "Auction House Bot: "
        if ($xml.config.world.module.ahbot.enabled -eq "true") { Write-Host -ForegroundColor Green "Enabled" } else { Write-Host -ForegroundColor Red "Disabled" }
        Write-Host -NoNewLine -ForegroundColor Cyan "2) "
        Write-Host -NoNewline -ForegroundColor Yellow "Eluna LUA Engine: "
        if ($xml.config.world.module.eluna.enabled -eq "true") { Write-Host -ForegroundColor Green "Enabled" } else { Write-Host -ForegroundColor Red "Disabled" }
        Write-Host -NoNewLine -ForegroundColor Cyan "0) "
        Write-Host -ForegroundColor Yellow "Return to the previous menu"

        Write-Host -NoNewLine -ForegroundColor Cyan "Choose an option: "
        $s = Read-Host

        switch ($s)
        {
            1 { if ($xml.config.world.module.ahbot.enabled -eq "true") { $xml.config.world.module.ahbot.enabled = "false" } else { $xml.config.world.module.ahbot.enabled = "true" }; $xml.Save($configFile); Source-Menu 1 }
            2 { if ($xml.config.world.module.eluna.enabled -eq "true") { $xml.config.world.module.eluna.enabled = "false" } else { $xml.config.world.module.eluna.enabled = "true" }; $xml.Save($configFile); Source-Menu 1 }
            0 { Source-Menu 0 }
            default { Source-Menu 1 }

        }
    }
    elseif ($page -eq 2)
    {
        Source-Menu 0
    }
}
