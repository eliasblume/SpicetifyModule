# SpicetifyModule
Powershell module to automate patching Spotify with Spicetify

```powershell
Install-Module -Name SpicetifyModule
```

## Usage 

it is recommended to include this into your profile to make it available in every powershell session. Edit `HOMEDIR:\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` and add the following lines:
```powershell
Import-Module SpicetifyModule
```
or just run it in your current session:


To execute the patching process, run the following command:
```powershell
Update-Spicetify
```
    


