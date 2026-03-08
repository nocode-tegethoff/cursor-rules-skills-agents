param(
    [ValidateSet("preview", "production")]
    [string]$Environment = "preview",

    [switch]$Help
)

if ($Help) {
    Write-Host "Usage: scripts/deploy-vercel.ps1 [-Environment preview|production] [--Help]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Deploys the Next.js app to Vercel using the Vercel CLI." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Parameters:" -ForegroundColor Cyan
    Write-Host "  -Environment  Target environment: 'preview' (default) or 'production'." -ForegroundColor Cyan
    Write-Host "  -Help         Show this help message and exit." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Notes:" -ForegroundColor Cyan
    Write-Host "  - Requires Vercel CLI installed and authenticated (see Vercel docs via context7 MCP)." -ForegroundColor Cyan
    Write-Host "  - Assumes project is already linked to the correct Vercel project." -ForegroundColor Cyan
    exit 0
}

$skillRoot = Split-Path -Parent $PSScriptRoot           # .../deploy-app
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
    "pnpm" { $buildCmd = "pnpm build" }
    "yarn" { $buildCmd = "yarn build" }
    default { $buildCmd = "npm run build" }
}

Write-Host "Running build: $buildCmd" -ForegroundColor Yellow
& $env:ComSpec /c $buildCmd
$buildExit = $LASTEXITCODE

if ($buildExit -ne 0) {
    Write-Error "Build failed with exit code $buildExit. Aborting deployment."
    exit $buildExit
}

switch ($Environment) {
    "production" {
        $vercelCmd = "npx vercel --prod"
    }
    default {
        # preview / staging deployment
        $vercelCmd = "npx vercel"
    }
}

Write-Host "Deploying with: $vercelCmd" -ForegroundColor Yellow
& $env:ComSpec /c $vercelCmd
$deployExit = $LASTEXITCODE

if ($deployExit -ne 0) {
    Write-Error "Vercel deployment failed with exit code $deployExit"
}

exit $deployExit

