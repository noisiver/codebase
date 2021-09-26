$root = Get-Location

Clear-Host
Write-Host -ForegroundColor Green "Initializing..."

$includes = @("configuration")
foreach ($include in $includes)
{
    if (Test-Path -Path includes\$include.ps1)
    {
        Write-Host -ForegroundColor Yellow "Loading include $include"
        . includes\$include.ps1
    }
    else
    {
        Write-Host -ForegroundColor Red "Failed to load include $include"
        exit
    }
}

Load-Configuration
