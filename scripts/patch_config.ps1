# ==============================================================================
# Script: patch_config.ps1
# Mục đích: Bật chế độ "Always Proceed" (EAGER) cho Google Antigravity
# Tác giả: Antigravity Community
# ==============================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Antigravity Auto-Proceed Enabler (Patch Tool)         " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$geminiConfigDir = Join-Path $HOME ".gemini\config"
$configFile = Join-Path $geminiConfigDir "config.json"
$projectsDir = Join-Path $geminiConfigDir "projects"

# 1. Kiểm tra file config.json chính
if (-not (Test-Path $configFile)) {
    Write-Host "[!] Không tìm thấy file: $configFile" -ForegroundColor Red
    Write-Host "[!] Hãy chắc chắn bạn đã từng cài đặt và mở Antigravity ít nhất 1 lần." -ForegroundColor Yellow
    exit 1
}

# 2. Tạo bản sao lưu (Backup)
$timestamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
$backupFile = "$configFile.bak_$timestamp"
Copy-Item -Path $configFile -Destination $backupFile -Force
Write-Host "[+] Đã tạo bản sao lưu an toàn tại:" -ForegroundColor Green
Write-Host "    $backupFile" -ForegroundColor DarkGray

# 3. Patch file config.json chính
try {
    $rawContent = Get-Content -Path $configFile -Raw -Encoding UTF8
    $json = $rawContent | ConvertFrom-Json

    if (-not $json.PSObject.Properties['userSettings']) {
        $json | Add-Member -MemberType NoteProperty -Name "userSettings" -Value ([PSCustomObject]@{})
    }

    $oldPolicy = $json.userSettings.autoExecutionPolicy
    $json.userSettings.autoExecutionPolicy = "CASCADE_COMMANDS_AUTO_EXECUTION_EAGER"

    $updatedJson = $json | ConvertTo-Json -Depth 32
    [System.IO.File]::WriteAllText($configFile, $updatedJson, [System.Text.Encoding]::UTF8)

    Write-Host "[v] Đã cập nhật Global config.json:" -ForegroundColor Green
    Write-Host "    Từ: '$oldPolicy' -> 'CASCADE_COMMANDS_AUTO_EXECUTION_EAGER'" -ForegroundColor Yellow
} catch {
    Write-Host "[!] Lỗi khi xử lý file config.json: $_" -ForegroundColor Red
    exit 1
}

# 4. Patch các file project hiện có
if (Test-Path $projectsDir) {
    $projectFiles = Get-ChildItem -Path $projectsDir -Filter "*.json" -File
    $count = 0
    foreach ($proj in $projectFiles) {
        try {
            $projRaw = Get-Content -Path $proj.FullName -Raw -Encoding UTF8
            $projJson = $projRaw | ConvertFrom-Json
            if ($projJson.PSObject.Properties['settings'] -and $projJson.settings -ne $null) {
                if ($projJson.settings.PSObject.Properties['autoExecutionPolicy']) {
                    $projJson.settings.autoExecutionPolicy = "CASCADE_COMMANDS_AUTO_EXECUTION_EAGER"
                    $projUpdated = $projJson | ConvertTo-Json -Depth 32
                    [System.IO.File]::WriteAllText($proj.FullName, $projUpdated, [System.Text.Encoding]::UTF8)
                    $count++
                }
            }
        } catch {
            Write-Host "[!] Bỏ qua file project lỗi: $($proj.Name)" -ForegroundColor DarkGray
        }
    }
    if ($count -gt 0) {
        Write-Host "[v] Đã cập nhật $count project cấu hình sang EAGER." -ForegroundColor Green
    }
}

Write-Host "----------------------------------------------------------" -ForegroundColor Cyan
Write-Host "[THÀNH CÔNG] Toàn bộ cấu hình đã được chuyển sang chế độ Always Proceed!" -ForegroundColor Green
Write-Host "[LƯU Ý] Vui lòng khởi động lại (Reload/Restart) ứng dụng Antigravity để áp dụng." -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
