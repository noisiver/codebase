Clear-Host

$includes = @("packages", "configuration", "menu")
foreach ($include in $includes)
{
    if (Test-Path -Path includes\$include.ps1)
    {
        . includes\$include.ps1
    }
    else
    {
        Write-Host -ForegroundColor Yellow "Unable to access $include"
        exit
    }
}

Check-Packages

if ($args.Count -gt 0)
{
    if ($args.Count -eq 1)
    {
        if ($args[0] -eq "start")
        {
        }
        elseif ($args[0] -eq "stop")
        {
        }
        else
        {
            Write-Host -ForegroundColor Green "Invalid arguments"
            Write-Host -ForegroundColor Yellow "The supplied arguments are invalid"
        }
    }
    elseif ($args.Count -eq 2)
    {
        if ($args[0] -eq "auth" -or $args[0] -eq "world" -or $args[0] -eq "all")
        {
            if ($args[1] -eq "setup" -or $args[1] -eq "install" -or $args[1] -eq "update")
            {
            }
            elseif ($args[1] -eq "database" -or $args[1] -eq "db")
            {
            }
            elseif ($args[1] -eq "cfg" -or $args[1] -eq "conf" -or $args[1] -eq "config" -or $args[1] -eq "configuration")
            {
            }
            elseif ($args[1] -eq "all")
            {
            }
            else
            {
                Write-Host -ForegroundColor Green "Invalid arguments"
                Write-Host -ForegroundColor Yellow "The supplied arguments are invalid"
            }
        }
        else
        {
            Write-Host -ForegroundColor Green "Invalid arguments"
            Write-Host -ForegroundColor Yellow "The supplied arguments are invalid"
        }
    }
}
else
{
    Main-Menu
}
