$script:ModuleRoot = $PSScriptRoot
$script:ModuleInfo = Import-PowerShellDataFile -Path "$($script:ModuleRoot)\SpicetifyModule.psd1"

. "$PSScriptRoot\functions\utils.ps1"

# foreach ($function in (Get-ChildItem "$ModuleRoot\functions" -Filter "*.ps1" -Recurse -ErrorAction Ignore)) {
#     . "$function.FullName"
# }

function Get-SpicetifyModuleInfo {
    [CmdletBinding()]
    param ()

    $updateInfo = Get-SpotifyInstalls

    $result = New-Object PSObject -Property @{
        Version          = $script:ModuleInfo.ModuleVersion
        SpotifyVersions  = ($updateInfo | Select-Object -ExpandProperty Version -Unique | ForEach-Object { $_.ToString() }) -join ', '
        SpicetifyPatched = Get-SpicetifyPatchedVersion
    }
    return $result
}



function Update-Spicetify {
    [CmdletBinding()]
    param ()
    $spotifyVersions = Get-SpotifyInstalls

    # if $spotifyVersions is empty, exit
    if ($spotifyVersions.Count -eq 0) {
        Write-Host "Spotify Not Installed - exiting" -ForegroundColor Red
        return
    }

    # if specetify is not installed, exit
    if (-not (Test-Path "$env:USERPROFILE\AppData\Roaming\spicetify")) {
        Write-Host "Spicetify Not Installed - exiting" -ForegroundColor Red
        return
    }

    # loop over versions
    foreach ($spotifyVersion in $spotifyVersions) {
        if ($spotifyVersion.IsStore) {
            Write-Host "Spotify Store Version: $($spotifyVersion.Version) - Should not be used" -ForegroundColor Yellow
            #remove store version from array if it exists and there are other versions
            if ($spotifyVersions.Count -gt 1) {
                Write-Host "Removing Store Version as there are other versions available" -ForegroundColor Yellow
                $spotifyVersions = $spotifyVersions | Where-Object { $_.IsStore -eq $false }
            }
        }
    }

    
    if ($spotifyVersions.Count -gt 1) {
        # output all versions
        Write-Host "Multiple Spotify Versions Installed - exiting" -ForegroundColor Red
        $spotifyVersions | Format-Table -AutoSize
    }
    else {
        $spotifyVersion = $spotifyVersions[0].Version
        $spicetifyPatchedVersion = Get-SpicetifyPatchedVersion
        Write-Host "Spotify Version: $spotifyVersion" -ForegroundColor Green
        Write-Host "Spicetify Patched Version: $spicetifyPatchedVersion" -ForegroundColor Green

        if ($spotifyVersion -ne $spicetifyPatchedVersion) {
            Write-Host "Update Required" -ForegroundColor Yellow
            # Perform update actions
            Stop-Spotify
            spicetify backup apply
            spicetify update
        }
        else {
            Write-Host "Update Not Required" -ForegroundColor Green
        }

    }

}


