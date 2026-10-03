#region | User-Scope Non-%PATH% Environment Variables |
# %NoSync%
#${%NoSync% Resolved Value} = "$env:UserProfile\NoSync"
#[System.Environment]::SetEnvironmentVariable('N0Sync',"$env:UserProfile\NoSync",'User')
#[System.Environment]::SetEnvironmentVariable('N0Sync',${%NoSync% Resolved Value},'User')
#[System.Environment]::SetEnvironmentVariable('dread','C:\Users\lowpr\NoSync','User')
[System.Environment]::SetEnvironmentVariable('NoSync',"$env:UserProfile\NoSync")
$NoSync = [System.IO.DirectoryInfo]"$env:SystemDrive\Users\${explorer.exe Owner}\NoSync"
#endregion

