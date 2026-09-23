#Requires -Version 7.0
<#
  sync-notes.ps1
  Obsidian EZNote -> quartz-notes/content 一键同步骨架

  用法（笔记整理好后）:
    pwsh -File sync-notes.ps1           # 复制 md + 提交推送
    pwsh -File sync-notes.ps1 -NoPush   # 只复制提交，不推送

  当前状态: 笔记未迁移，content 保持为空；仅搭好工作流。
#>
[CmdletBinding()]
param(
    [switch]$NoPush
)

$ErrorActionPreference = "Stop"

$Vault = "D:/BPP/EZNote"
$Repo = "D:/BPP/Repos/quartz-notes"
$Content = Join-Path $Repo "content"
$ExcludeDirs = @(".obsidian", ".git", "desktop.ini")

if (-not (Test-Path $Vault)) { throw "Vault not found: $Vault" }
if (-not (Test-Path $Content)) { New-Item -ItemType Directory -Path $Content | Out-Null }

Write-Host "==> Sync $Vault -> $Content"

$mdFiles = Get-ChildItem -Path $Vault -Recurse -Filter "*.md" -File |
    Where-Object {
        $rel = $_.FullName.Substring($Vault.Length)
        -not ($ExcludeDirs | Where-Object { $rel -match [regex]::Escape($_) })
    }

foreach ($file in $mdFiles) {
    $rel = $file.FullName.Substring($Vault.Length).TrimStart("/", "\")
    $dest = Join-Path $Content $rel
    $destDir = Split-Path $dest -Parent
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
    Copy-Item -Path $file.FullName -Destination $dest -Force
    Write-Host "  + $rel"
}

if ($mdFiles.Count -eq 0) {
    Write-Host "==> No .md files in vault yet; content left as-is."
    return
}

Push-Location $Repo
try {
    git add -A
    $status = git status --porcelain
    if (-not $status) {
        Write-Host "==> No changes to sync."
        return
    }

    git commit -m "sync: update notes from EZNote"
    Write-Host "==> Committed."

    if (-not $NoPush) {
        git push origin v5
        Write-Host "==> Pushed to origin/v5. GitHub Actions will build and deploy Pages."
    }
}
finally {
    Pop-Location
}
