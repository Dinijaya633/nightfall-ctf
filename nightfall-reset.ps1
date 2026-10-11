<#
  nightfall-reset.ps1
  Resets NIGHTFALL to a clean, known-good state from a SQL backup.
  Usage:  .\nightfall-reset.ps1 -BackupFile "C:\path\to\backup.sql"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$BackupFile
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $BackupFile)) {
    Write-Host "[FAIL] Backup file not found: $BackupFile" -ForegroundColor Red
    exit 1
}

Write-Host "======================================" -ForegroundColor Cyan
Write-Host " NIGHTFALL - Reset" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Using backup: $BackupFile"
Write-Host ""

Write-Host "[1/4] Recreating challenge + gateway containers..." -ForegroundColor Yellow
docker compose up -d --force-recreate challenge-osint challenge-web challenge-linux gateway-web gateway-ssh

Write-Host ""
Write-Host "[2/4] Waiting for MariaDB to be ready..." -ForegroundColor Yellow
$ok = $false
for ($i = 0; $i -lt 30; $i++) {
    $res = docker exec nightfall-mariadb mariadb-admin ping -uroot -proot_password 2>$null
    if ($res -match 'mysqld is alive') { $ok = $true; break }
    Start-Sleep -Seconds 1
}
if (-not $ok) {
    Write-Host "[FAIL] MariaDB did not come up in 30s" -ForegroundColor Red
    exit 1
}
Write-Host "  [ OK ] MariaDB is ready" -ForegroundColor Green

Write-Host ""
Write-Host "[3/4] Restoring CTFd database..." -ForegroundColor Yellow
docker exec nightfall-mariadb mariadb -uroot -proot_password -e "DROP DATABASE IF EXISTS ctfd; CREATE DATABASE ctfd;"
Get-Content -Raw $BackupFile | docker exec -i nightfall-mariadb mariadb -uroot -proot_password

Write-Host ""
Write-Host "[4/4] Restarting CTFd..." -ForegroundColor Yellow
docker restart nightfall-ctfd | Out-Null

Write-Host ""
Write-Host "Reset complete." -ForegroundColor Green
Write-Host "Open http://localhost:8000 to verify." -ForegroundColor Cyan
