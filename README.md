<h1 align="center">
    PS> SpicetifyModule
</h1>

<div align="center"> 
    <img src="doc\logo.png" height=312/>
</div>

<p align="center"> 
   Powershell module to automate patching Spotify with Spicetify
</p>

## Installation
Download from [PowerShell Gallery](https://www.powershellgallery.com/packages/SpicetifyModule) or install via PowerShellGet:

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


## Automation/Topgrade
This is meant to be used together with [Topgrade](https://topgrade-rs.github.io) to automate the process of updating your system.
Simply edit your profile like shown in *Usage*.
then edit your topgrade config with `topgrade --edit-config` and add this into the commands section:
```toml
# the `commands` key should already exist
[commands]
"Update Spicetify" = "Update-Spicetify"

```


    


