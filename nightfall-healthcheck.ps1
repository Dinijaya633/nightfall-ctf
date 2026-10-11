<#
  nightfall-healthcheck.ps1
  Verifies all NIGHTFALL services are up, their ports respond,
  and the network isolation is correct.
#>

$ErrorActionPreference = 'Continue'

Write-Host "======================================" -ForegroundColor Cyan
Write-Host " NIGHTFALL - Health Check" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

try {
    docker info *> $null
    Write-Host "[ OK ] Docker engine is running" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Docker engine is NOT running" -ForegroundColor Red
    exit 1
}

$expected = @(
    'nightfall-ctfd',
    'nightfall-mariadb',
    'nightfall-challenge-osint',
    'nightfall-challenge-web',
    'nightfall-challenge-linux',
    'nightfall-gateway-web',
    'nightfall-gateway-ssh'
)

Write-Host ""
Write-Host "Containers:" -ForegroundColor Yellow
foreach ($c in $expected) {
    $state = (docker inspect -f '{{.State.Status}}' $c 2>$null)
    if ($state -eq 'running') {
        Write-Host "  [ OK ] $c" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $c  (state: $state)" -ForegroundColor Red
    }
}

function Test-Port {
    param([int]$Port, [string]$Label)
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $client.Connect('127.0.0.1', $Port)
        $client.Close()
        Write-Host "  [ OK ] $Label  (port $Port)" -ForegroundColor Green
    } catch {
        Write-Host "  [FAIL] $Label  (port $Port)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Published ports:" -ForegroundColor Yellow
Test-Port -Port 8000 -Label 'CTFd'
Test-Port -Port 8081 -Label 'Web Gateway (NF03)'
Test-Port -Port 8082 -Label 'OSINT (NF01/NF02)'
Test-Port -Port 2222 -Label 'SSH Gateway (NF06)'

Write-Host ""
Write-Host "Network isolation:" -ForegroundColor Yellow
$cf = docker network inspect challenge_front --format '{{.Internal}}' 2>$null
$cn = docker network inspect control_net    --format '{{.Internal}}' 2>$null
$ni = docker network inspect nightfall_ingress --format '{{.Internal}}' 2>$null

if ($cf -eq 'true') { Write-Host "  [ OK ] challenge_front is internal"  -ForegroundColor Green } else { Write-Host "  [FAIL] challenge_front is NOT internal" -ForegroundColor Red }
if ($cn -eq 'true') { Write-Host "  [ OK ] control_net is internal"      -ForegroundColor Green } else { Write-Host "  [FAIL] control_net is NOT internal" -ForegroundColor Red }
if ($ni -eq 'false'){ Write-Host "  [ OK ] nightfall_ingress is external" -ForegroundColor Green } else { Write-Host "  [FAIL] nightfall_ingress is NOT external" -ForegroundColor Red }

Write-Host ""
Write-Host "CTFd HTTP check:" -ForegroundColor Yellow
try {
    $r = Invoke-WebRequest -Uri 'http://localhost:8000' -UseBasicParsing -TimeoutSec 5
    if ($r.StatusCode -eq 200) {
        Write-Host "  [ OK ] CTFd responds with HTTP 200" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] CTFd returned HTTP $($r.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  [FAIL] CTFd did not respond" -ForegroundColor Red
}

Write-Host ""

Write-Host ""
Write-Host "Challenge pages (HTTP):" -ForegroundColor Yellow
foreach ($u in @(
    @{Url='http://localhost:8081/incident-review'; Label='NF03 Incident Review'},
    @{Url='http://localhost:8082/';                Label='NF01/NF02 OSINT site'}
)) {
    try {
        $r = Invoke-WebRequest -Uri $u.Url -UseBasicParsing -TimeoutSec 5
        Write-Host ("  [ OK ] {0} (HTTP {1})" -f $u.Label, $r.StatusCode) -ForegroundColor Green
    } catch {
        Write-Host ("  [FAIL] {0}" -f $u.Label) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Done." -ForegroundColor Cyan

