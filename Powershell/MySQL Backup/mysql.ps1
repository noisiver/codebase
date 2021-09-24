Write-Host -ForegroundColor Green "Starting backup..."

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
    Write-Host -ForegroundColor Yellow "Exporting database $db"
    if (-Not (Test-Path -PathType Container -Path "database\$db"))
    {
        New-Item -ItemType Container -Path "database\$db" | Out-Null
    }

    $tables = .\bin\mysql.exe --defaults-extra-file="bin\mysql.cnf" -Bse "USE $db;SHOW TABLES"
    foreach ($tbl in $tables)
    {
        #Write-Host -ForegroundColor Yellow "Exporting table $tbl"
        .\bin\mysqldump.exe --defaults-extra-file="bin\mysql.cnf" --extended-insert=FALSE $db $tbl > "database\$db\$tbl.sql"
    }
}

Write-Host -ForegroundColor Yellow "Creating archive $dateTime.zip"
.\bin\7z.exe a -mx9 "C:\Users\Administrator\My Drive\$dateTime.zip" ".\database\*" | Out-Null

Remove-Item -Path "database" -Force -Recurse

$files = Get-ChildItem -Path "C:\Users\Administrator\My Drive\*.zip" -Recurse | Where-Object {-not $_.PsIsContainer}
if ($files.Count -gt 72)
{
    $files | Sort-Object CreationTime | Select-Object -First ($files.Count - 72) | Remove-Item -Force
}
