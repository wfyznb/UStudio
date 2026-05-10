$repoPath = "c:\Users\jijijijhi\Desktop\AnimeStudio-master"
$gitExe = "C:\Program Files\Git\bin\git.exe"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"

Set-Location $repoPath

$status = & $gitExe status --porcelain 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Output "[$timestamp] Git status failed: $status"
    exit 1
}

if (-not $status) {
    Write-Output "[$timestamp] No changes detected, skipping."
    exit 0
}

& $gitExe add -A 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Output "[$timestamp] Git add failed"
    exit 1
}

$commitMsg = "auto: sync changes at $timestamp"
& $gitExe commit -m $commitMsg 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Output "[$timestamp] Git commit failed (may have no changes)"
    exit 1
}

$pushResult = & $gitExe push origin master 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Output "[$timestamp] Git push failed: $pushResult"
    exit 1
}

Write-Output "[$timestamp] Changes pushed successfully"
