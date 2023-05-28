function Get-SpotifyInstalls {
    # Retrieve all installed Spotify versions
    $spotifyVersions = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
    Where-Object { $_.DisplayName -eq "Spotify" } |
    Select-Object -Property @{Name = "Name"; Expression = { $_.DisplayName } },
    @{Name = "Version"; Expression = { $_.DisplayVersion } },
    InstallLocation,
    @{Name = "IsStore"; Expression = { $false } }

    # Retrieve the installed Spotify version from the Microsoft Store
    $storeVersion = Get-AppxPackage -Name "SpotifyAB.SpotifyMusic"
    if ($storeVersion) {
        $spotifyVersions = @($spotifyVersions) + @(New-Object PSObject -Property @{
                Name            = $storeVersion.Name
                Version         = $storeVersion.Version
                InstallLocation = $storeVersion.InstallLocation
                IsStore         = $true
            })
    }
    

    # Output the installed versions and their locations
    return $spotifyVersions
}

function Get-SpicetifyPatchedVersion {
    $configPath = "C:\Users\$env:UserName\AppData\Roaming\spicetify\config-xpui.ini"
    # Read the current patched Spotify version from config-xpui.ini
 
    $patchedVersion = Get-Content -Path $configPath -Raw | Select-String -Pattern 'version\s*=\s*(\S+)' | ForEach-Object {
        $_.Matches.Groups[1].Value
    }

    return $patchedVersion
}

function Stop-Spotify {
    $spotifyProcess = Get-Process -Name Spotify -ErrorAction SilentlyContinue
    if ($spotifyProcess) {
        Stop-Process -Id $spotifyProcess.Id -Force
    }
}

