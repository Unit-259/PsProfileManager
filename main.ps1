function Show-WelcomeMessage {
    Clear-Host
    Write-Host "PowerShell Profile Manager" -ForegroundColor White -BackgroundColor DarkCyan
    Write-Host "--------------------------------" -ForegroundColor DarkCyan
    Write-Host "Manage and view your PowerShell profiles easily."
    Write-Host "This tool scans for existing profiles and allows you to modify them." -ForegroundColor Gray
    Write-Host "`nPress Enter to continue..." -ForegroundColor DarkYellow
    $null = Read-Host
}

function Display-ProfilePathsAndChoose {
    $profileNames = @{
        "1" = $PROFILE
        "2" = $PROFILE.CurrentUserAllHosts
        "3" = $PROFILE.AllUsersCurrentHost
        "4" = $PROFILE.AllUsersAllHosts
    }

    Write-Host "`nAvailable PowerShell profiles:" -ForegroundColor Green
    foreach ($number in $profileNames.Keys) {
        $name = switch ($number) {
            "1" { "Current User, Current Host" }
            "2" { "Current User, All Hosts" }
            "3" { "All Users, Current Host" }
            "4" { "All Users, All Hosts" }
        }
        $emoji = if (Test-Path $profileNames[$number]) { "✅" } else { "❌" }
        $color = if (Test-Path $profileNames[$number]) { "Green" } else { "Red" }
        Write-Host "[$emoji] $number. $name" -ForegroundColor $color
    }
    
    $choice = Read-Host "`nPlease select a profile to use (enter the number):"
    return $profileNames[$choice]
}

function Create-ProfileFiles {
    param([string]$moduleRoot)

    $files = @("AsciiHeader.ps1", "CustomFunctions.ps1", "GlobalVariables.ps1", "LocalModules.ps1", "CustomPrompt.ps1")
    
    foreach ($file in $files) {
        $filePath = Join-Path $moduleRoot $file
        if (-not (Test-Path $filePath)) {
            New-Item $filePath -ItemType File | Out-Null
            # Optionally, add default content to the files here
        }
    }

    Write-Host "Necessary files created in $moduleRoot" -ForegroundColor Green
}

function Handle-Profile {
    $profilePath = Display-ProfilePathsAndChoose
    $moduleRoot = Split-Path $profilePath

    if (Test-Path $profilePath) {
        $overwrite = Read-Host "`nProfile exists at $profilePath. Do you want to overwrite it? (Y/N)"
        if ($overwrite -eq 'Y') {
            $backup = Read-Host "Do you want to make a backup of the existing profile? (Y/N)"
            if ($backup -eq 'Y') {
                $backupPath = "$profilePath.bak"
                Copy-Item $profilePath $backupPath -Force
                Write-Host "Backup created at $backupPath" -ForegroundColor Green
            }
            # Additional logic for overwriting the profile goes here
        }
    } else {
        $createFiles = Read-Host "Profile does not exist. Do you want to create the necessary files at $moduleRoot? (Y/N)"
        if ($createFiles -eq 'Y') {
            Create-ProfileFiles -moduleRoot $moduleRoot
        }
    }
}

# Main Execution
Show-WelcomeMessage
Handle-Profile
