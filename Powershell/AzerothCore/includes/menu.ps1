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
        0 { Exit-Menu }
        default { Main-Menu }

    }
}

function Source-Menu
{
    Clear-Host
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
        0 { Main-Menu }
        default { Source-Menu }

    }
}

function Exit-Menu
{
    Print-Quote
}
