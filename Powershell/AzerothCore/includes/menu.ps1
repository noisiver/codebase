#$s = Read-Host -Prompt "Choose an option: "
#Write-Host $s

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

    Write-Host -NoNewLine -ForegroundColor Cyan "Choose an option: "
    $s = Read-Host

    switch ($s)
    {
        1 { Write-Host "Manage the source code" }
        2 { Write-Host "Manage the databases" }
        3 { Write-Host "Manage the configuration options" }
        4 { Write-Host "Manage the compiled binaries" }
        default { Main-Menu }

    }
}