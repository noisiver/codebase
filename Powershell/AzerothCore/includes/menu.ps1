function Main-Menu
{
    Clear-Host
    Write-Host -ForegroundColor Magenta "AzerothCore"
    Write-Host -NoNewLine -ForegroundColor Cyan "1) "
    Write-Host -ForegroundColor Yellow "Manage the source code"
    Write-Host -NoNewLine -ForegroundColor Cyan "2) "
    Write-Host -ForegroundColor Yellow "Manage the modules"
    Write-Host -NoNewLine -ForegroundColor Cyan "3) "
    Write-Host -ForegroundColor Yellow "Manage the databases"
    Write-Host -NoNewLine -ForegroundColor Cyan "4) "
    Write-Host -ForegroundColor Yellow "Manage the configuration options"
    Write-Host -NoNewLine -ForegroundColor Cyan "5) "
    Write-Host -ForegroundColor Yellow "Manage the core processes"

    Write-Host -NoNewLine -ForegroundColor Cyan "Choose an option: "
    $s = Read-Host

    switch($s)
    {
        1 { Source-Menu }
        2 { Write-Host "Manage the modules" }
        3 { Write-Host "Manage the databases" }
        4 { Write-Host "Manage the configuration options" }
        5 { Write-Host "Manage the core processes" }
        default { Print-Quote }
    }
}

function Source-Menu
{
    Clear-Host
    Write-Host -ForegroundColor Magenta "Managing the source code"
    Write-Host -NoNewLine -ForegroundColor Cyan "1) "
    Write-Host -ForegroundColor Yellow "Download the latest version of the source code"
    Write-Host -NoNewLine -ForegroundColor Cyan "2) "
    Write-Host -ForegroundColor Yellow "Compile the source code into binaries"
    Write-Host -NoNewLine -ForegroundColor Cyan "3) "
    Write-Host -ForegroundColor Yellow "Download the client data files"

    Write-Host -NoNewLine -ForegroundColor Cyan "Choose an option: "
    $s = Read-Host

    switch($s)
    {
        1 { Clone-Source; Source-Menu }
        2 { Compile-Source; Source-Menu }
        3 { Write-Host "Download the client data files" }
        default { Main-Menu }
    }
}
