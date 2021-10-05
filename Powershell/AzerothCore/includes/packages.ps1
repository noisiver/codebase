$packages = @(
    ('cmake', 'CMake 3.20'),
    ('git', 'Git'),
    ('mysql', 'MySQL'),
    ('visual studio', 'Visual Studio Community 2019')
)

function Check-Packages
{
    Clear-Host

    Write-Host -ForegroundColor Green "Checking required packages"
    $error_occured = $false
    foreach($app in $packages)
    {
        $short = $app[0]
        $long = $app[1]

        Write-Host -NoNewLine -ForegroundColor Yellow "Checking $long : "

        if ($short -eq "boost")
        {
            if (Test-Path 'env:BOOST_ROOT')
            {
                Write-Host -ForegroundColor Green "Found"
            }
            else
            {
                Write-Host -ForegroundColor Red "Not found"
                $error_occured = $true
            }
        }
        else
        {
            if ((Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -like "*$short*" }) -or (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -like "*$short*" }))
            {
                Write-Host -ForegroundColor Green "Found"
            }
            else
            {
                Write-Host -ForegroundColor Red "Not found"
                $error_occured = $true
            }
        }
    }

    if ($error_occured)
    {
        Write-Host -ForegroundColor Red "`nThe script is unable to continue due to missing packages"
        exit
    }
}

$commands = @(
    ("CMake", "cmake"),
    ("Git", "git"),
    ("MySQL", "mysql"),
    ("MSBuild", "msbuild")
)

function Check-Commands
{
    Clear-Host

    Write-Host -ForegroundColor Green "Checking required commands"
    $error_occured = $false

    foreach($cmd in $commands)
    {
        $name = $cmd[0]
        $c = $cmd[1]

        Write-Host -NoNewLine -ForegroundColor Yellow "Checking $name : "

        if (Get-Command $c -errorAction SilentlyContinue)
        {
            Write-Host -ForegroundColor Green "Found"
        }
        else
        {
            Write-Host -ForegroundColor Red "Not found"
            $error_occured = $true
        }
    }

    if ($error_occured)
    {
        Write-Host -ForegroundColor Red "`nThe script is unable to continue due to missing commands"
        Write-Host -ForegroundColor Red "Make sure that the required software paths are defined in the system"
        exit
    }
}
