<#
  nightfall-reset.ps1
  Resets NIGHTFALL to a known-good state from a SQL backup.
  Usage:  .\nightfall-reset.ps1 -BackupFile ".\backups\nightfall-golden.sql"
  Needs a .env file (copy .env.example to .env first).
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$BackupFile
)

$ErrorActionPreference = 'Continue'

function Fail($msg) {
    Write-Host "[FAIL] $msg" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $BackupFile)) { Fail "Backup file not found: $BackupFile" }
$BackupFile = (Resolve-Path $BackupFile).Path
Set-Location $PSScriptRoot

$envFile = Join-Path $PSScriptRoot ".env"
if (-not (Test-Path $envFile)) { Fail ".env not found. Copy .env.example to .env first." }
$line = Get-Content $envFile | Where-Object { $_ -match '^MYSQL_ROOT_PASSWORD=' } | Select-Object -First 1
if (-not $line) { Fail "MYSQL_ROOT_PASSWORD is not set in .env" }
$rootPw = ($line -replace '^MYSQL_ROOT_PASSWORD=', '').Trim()

Write-Host "======================================" -ForegroundColor Cyan
Write-Host " NIGHTFALL - Reset" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Using backup: $BackupFile"
Write-Host ""

Write-Host "[1/4] Recreating challenge + gateway containers..." -ForegroundColor Yellow
docker compose up -d --force-recreate challenge-osint challenge-web challenge-linux gateway-web gateway-ssh
if ($LASTEXITCODE -ne 0) { Fail "Could not recreate containers" }

Write-Host ""
Write-Host "[2/4] Waiting for MariaDB to be ready..." -ForegroundColor Yellow
$ok = $false
for ($i = 0; $i -lt 40; $i++) {
    $res = docker exec nightfall-mariadb mariadb-admin ping -uroot "-p$rootPw" 2>$null
    if ($res -match 'mysqld is alive') { $ok = $true; break }
    Start-Sleep -Seconds 1
}
if (-not $ok) { Fail "MariaDB did not come up in 40s" }
Write-Host "  [ OK ] MariaDB is ready" -ForegroundColor Green

Write-Host ""
Write-Host "[3/4] Restoring CTFd database..." -ForegroundColor Yellow
$tmp = Join-Path $env:TEMP "nightfall-restore.sql"
$sql = [System.IO.File]::ReadAllText($BackupFile)
[System.IO.File]::WriteAllText($tmp, $sql, (New-Object System.Text.UTF8Encoding($false)))
docker exec nightfall-mariadb mariadb -uroot "-p$rootPw" -e "DROP DATABASE IF EXISTS ctfd; CREATE DATABASE ctfd;"
if ($LASTEXITCODE -ne 0) { Fail "Could not recreate the ctfd database" }
docker cp $tmp nightfall-mariadb:/tmp/restore.sql
docker exec nightfall-mariadb sh -c "mariadb -uroot -p'$rootPw' < /tmp/restore.sql"
if ($LASTEXITCODE -ne 0) { Fail "Restore failed" }
docker exec nightfall-mariadb rm -f /tmp/restore.sql
Remove-Item $tmp -Force
Write-Host "  [ OK ] Database restored" -ForegroundColor Green

Write-Host ""
Write-Host "[4/4] Restarting CTFd..." -ForegroundColor Yellow
docker restart nightfall-ctfd | Out-Null

Write-Host ""
Write-Host "Reset complete." -ForegroundColor Green
Write-Host "Open http://localhost:8000 to verify." -ForegroundColor Cyan
