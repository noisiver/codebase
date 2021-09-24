$dateTime = Get-Date -Format "yyyy-MM-dd_HH-mm"

if (-Not (Test-Path -PathType Leaf -Path "bin\mysql.cnf"))
{
    Write-Host -ForegroundColor Red "Unable to locate the required mysql configuration file."
    Exit
}

if (-Not (Test-Path -PathType Leaf -Path "bin\mysql.exe"))
{
    Write-Host -ForegroundColor Red "Unable to locate the required mysql executable."
    Exit
}

if (-Not (Test-Path -PathType Container -Path "database"))
{
    New-Item -ItemType Directory -Path "database" -Force | Out-Null
}

$databases = .\bin\mysql.exe --defaults-extra-file="bin\mysql.cnf" -Bse "SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME NOT IN ('information_schema', 'mysql', 'performance_schema') AND SCHEMA_NAME NOT LIKE '%world%' AND SCHEMA_NAME NOT LIKE '%logs%' AND SCHEMA_NAME NOT LIKE '%aowow%'"

foreach ($db in $databases)
{
    Write-Host -ForegroundColor Green "Performing a backup of $db"
    if (-Not (Test-Path -PathType Container -Path "database\$db\$dateTime"))
    {
        New-Item -ItemType Container -Path "database\$db\$dateTime" | Out-Null
    }

    $tables = .\bin\mysql.exe --defaults-extra-file="bin\mysql.cnf" -Bse "USE $db;SHOW TABLES"
    foreach ($tbl in $tables)
    {
        Write-Host -ForegroundColor Yellow "Exporting table $tbl"
        .\bin\mysqldump.exe --defaults-extra-file="bin\mysql.cnf" --extended-insert=FALSE $db $tbl > "database\$db\$dateTime\$tbl.sql"
    }

    Write-Host -ForegroundColor Yellow "Creating archive database\$db\$dateTime.zip`n"
    .\bin\7z.exe a -mx9 "database\$db\$dateTime.zip" ".\database\$db\$dateTime\*" | Out-Null

    Remove-Item -Path "database\$db\$dateTime" -Force -Recurse

    $files = Get-ChildItem -Path "database\$db\*.zip" -Recurse | Where-Object {-not $_.PsIsContainer}
    if ($files.Count -gt 10)
    {
        $files | Sort-Object CreationTime | Select-Object -First ($files.Count - 10) | Remove-Item -Force
    }
}

Write-Host -ForegroundColor Green "Actions completed"
