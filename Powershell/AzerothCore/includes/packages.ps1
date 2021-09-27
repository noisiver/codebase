$packages = @(
    ('cmake', 'CMake 3.20'),
    ('git', 'Git'),
    ('mysql', 'MySQL'),
    ('vs', 'Visual Studio Community 2019')
)

function Check-Packages
{
    Write-Host -ForegroundColor Green "Checking required packages"
    $error = $false
    foreach($app in $packages)
    {
        $short = $app[0]
        $long = $app[1]

        Write-Host -NoNewLine -ForegroundColor Yellow "Checking $long : "

        if (-Not (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $short }) -ne $null)
        {
            Write-Host -ForegroundColor Red "Not found"
            $error = $true
        }
    }

    if ($error)
    {
        Write-Host -ForegroundColor Red "`nThe script is unable to continue due to missing packages"
        exit
    }
}
