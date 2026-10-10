# ==============================================================================
# Script: restore_config.ps1
# Mục đích: Hoàn tác về chế độ duyệt lệnh thủ công (OFF) cho Google Antigravity
# Tác giả: Antigravity Community
# ==============================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Yellow
Write-Host "   Antigravity Auto-Proceed Restore Tool                  " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Yellow

$geminiConfigDir = Join-Path $HOME ".gemini\config"
$configFile = Join-Path $geminiConfigDir "config.json"
$projectsDir = Join-Path $geminiConfigDir "projects"

if (-not (Test-Path $configFile)) {
    Write-Host "[!] Không tìm thấy file: $configFile" -ForegroundColor Red
    exit 1
}

# 1. Khôi phục config.json
try {
    $rawContent = Get-Content -Path $configFile -Raw -Encoding UTF8
    $json = $rawContent | ConvertFrom-Json

    if ($json.PSObject.Properties['userSettings']) {
        $json.userSettings.autoExecutionPolicy = "CASCADE_COMMANDS_AUTO_EXECUTION_OFF"
        $updatedJson = $json | ConvertTo-Json -Depth 32
        [System.IO.File]::WriteAllText($configFile, $updatedJson, [System.Text.Encoding]::UTF8)
        Write-Host "[v] Đã đưa Global config.json về: 'CASCADE_COMMANDS_AUTO_EXECUTION_OFF'" -ForegroundColor Green
    }
} catch {
    Write-Host "[!] Lỗi khi xử lý file config.json: $_" -ForegroundColor Red
    exit 1
}

# 2. Khôi phục các project
if (Test-Path $projectsDir) {
    $projectFiles = Get-ChildItem -Path $projectsDir -Filter "*.json" -File
    $count = 0
    foreach ($proj in $projectFiles) {
        try {
            $projRaw = Get-Content -Path $proj.FullName -Raw -Encoding UTF8
            $projJson = $projRaw | ConvertFrom-Json
            if ($projJson.PSObject.Properties['settings'] -and $projJson.settings -ne $null) {
                if ($projJson.settings.PSObject.Properties['autoExecutionPolicy']) {
                    $projJson.settings.autoExecutionPolicy = "CASCADE_COMMANDS_AUTO_EXECUTION_OFF"
                    $projUpdated = $projJson | ConvertTo-Json -Depth 32
                    [System.IO.File]::WriteAllText($proj.FullName, $projUpdated, [System.Text.Encoding]::UTF8)
                    $count++
                }
            }
        } catch {
            Write-Host "[!] Bỏ qua file: $($proj.Name)" -ForegroundColor DarkGray
        }
    }
    if ($count -gt 0) {
        Write-Host "[v] Đã đưa $count project về chế độ duyệt tay." -ForegroundColor Green
    }
}

Write-Host "----------------------------------------------------------" -ForegroundColor Yellow
Write-Host "[HOÀN TẤT] Antigravity đã trở về chế độ yêu cầu duyệt lệnh thủ công." -ForegroundColor Green
Write-Host "[LƯU Ý] Vui lòng khởi động lại (Reload/Restart) Antigravity." -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Yellow
