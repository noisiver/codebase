$packages = @(
    ('cmake', 'CMake 3.20'),
    ('git', 'Git'),
    ('mysql', 'MySQL'),
    ('visual studio', 'Visual Studio Community 2019')
)

function Load-Packages
{
    Clear-Host

    Write-Host -ForegroundColor Green "Checking required packages"
    $error_occured = $false
    foreach($app in $packages)
    {
        $short = $app[0]
        $long = $app[1]

        Write-Host -NoNewLine -ForegroundColor Yellow "Checking $long : "

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

    if ($error_occured)
    {
        Write-Host -ForegroundColor Red "`nThe script is unable to continue due to missing packages"
        exit
    }
}
