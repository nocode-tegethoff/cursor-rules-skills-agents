param(
    [string]$Script = "test",
    [switch]$Help
)

if ($Help) {
    Write-Host "Usage: scripts/run-tests.ps1 [-Script <npm-script-name>] [--Help]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Runs the project's primary test script from the repository root." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Parameters:" -ForegroundColor Cyan
    Write-Host "  -Script  Name of the package.json script to run (default: 'test')." -ForegroundColor Cyan
    Write-Host "  -Help    Show this help message and exit." -ForegroundColor Cyan
    exit 0
}

$skillRoot = Split-Path -Parent $PSScriptRoot           # .../run-tests-fix-failures
$cursorDir = Split-Path -Parent $skillRoot              # .../.cursor
$repoRoot  = Split-Path -Parent $cursorDir              # workspace root

Set-Location $repoRoot

function Get-PackageManager {
    if (Test-Path "pnpm-lock.yaml") { return "pnpm" }
    if (Test-Path "yarn.lock")      { return "yarn" }
    if (Test-Path "package-lock.json") { return "npm" }
    return "npm"
}

$pm = Get-PackageManager

switch ($pm) {
    "pnpm" { $cmd = "pnpm run $Script" }
    "yarn" { $cmd = "yarn $Script" }
    default { $cmd = "npm run $Script" }
}

Write-Host "Running tests with: $cmd" -ForegroundColor Yellow

& $env:ComSpec /c $cmd
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
    Write-Error "Test command failed with exit code $exitCode"
}

exit $exitCode

