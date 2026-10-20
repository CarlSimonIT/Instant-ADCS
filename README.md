# Instant-ADCS
Quickly and securely build an Active Directory-integrated 3-tier PKI with Windows PowerShell, DSC version 1.1, and as little manual input as possible. 

### New Local Standard Account
Exporting the contents of the Windows Credential Manager is a critical step in this workflow. Using a new non-administrative local account is advised to ensure that only secure strings directly relevant to Instant-ADCS are exported. 

Launch Windows PowerShell in a elevated security context and execute the lines below:  

<details>
  <summary>New Temporary Non-Privileged Local Account</summary>

  ```powershell
  $Name = 'Delete This Account'
  $BadPassword = ConvertTo-SecureString -AsPlainText 'BadPassword!' -Force
  $HT = @{
    Name                     = $Name
    Password                 = $BadPassword
    FullName                 = $Name
    AccountExpires           = (Get-Date).AddDays(1)
    Description              = 'Temp user for new Instant-ADCS external media'
    Disabled                 = $false
    PasswordNeverExpires     = $false
    UserMayNotChangePassword = $false
  }
  New-LocalUser @HT
  Add-LocalGroupMember -Group 'Users' -Member $Name
  ```
</details>

Log off this current session, authenticate back into Windows with the newly created local account, and return to these instructions. 

### Build External Media
Launch Windows PowerShell in a non-elevated security context. 

> [!NOTE]
> Stated differently, do *NOT* right-click the Windows PowerShell icon and select Run As Administrator. 

Install Git with WinGet in the user scope:  

<details>
  <summary>Install Git</summary>

  ```powershell
  ${powershell.exe owner Identity} = [Security.Principal.WindowsIdentity]::GetCurrent()
  ${powershell.exe owner Access} = [Security.Principal.WindowsPrincipal]${powershell.exe owner Identity}
  ${Current powershell.exe process is running at Integrity Level-High} = (${powershell.exe owner Access}).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  
  if (${Current powershell.exe process is running at Integrity Level-High}) {
    throw "Re-launch Windows PowerShell WITHOUT selecting Run As Administrator!"
    exit
  } 
  else {winget.exe install --id 'Git.Git' --scope 'user' --source 'winget'}
  ```
</details>

Configure a new directory for cloning multiple GitHub repositories. <span style="font-family:Consolas;font-size:1.05em;">Instant-ADCS</span> requires `CarlSimonIT` as the BaseName of this directory. Ensure the folder exists and then set as current working directory:   

<details>
  <summary>Relocate to Empty Working Directory</summary>

  ```powershell
  ${Intermediary Directory} = Read-Host -Prompt 'Optional: Partial path of intermediary directory'
  $CloningRepoPath = "$env:UserProfile\GitHub\${Intermediary Directory}\CarlSimonIT"
  $CloningRepoFolder = try {
    Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'
  } catch {
    New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force
  }
  Set-Location -Path "$CloningRepoFolder"
  ```
</details>

Clone the <span style="font-family:Consolas;font-size:1.05em;">Instant-ADCS</span> and [Secure Automations Toolset](https://github.com/CarlSimonIT/Secure-Automations-Toolset) repositories into their own dedicated directories:  

<details>
  <summary>Clone from GitHub to Local Host</summary>

  ```powershell
  $GitHubRepositoryName = 'Secure-Automations-Toolset'
  git.exe clone "https://github.com/CarlSimonIT/$GitHubRepositoryName.git" $GitHubRepositoryName
  $GitHubRepositoryName = 'Instant-ADCS'
  git.exe clone "https://github.com/CarlSimonIT/$GitHubRepositoryName.git" $GitHubRepositoryName
  ```
</details>

Define new hidden directory for information exchange between PowerShell versions and PowerShell process instances: 

<details>
  <summary>Temporary Folder</summary>

  ```powershell
  $path = ".\.CommonItems"
  $folder = try {
    Get-Item -Path $path -ErrorAction 'Stop'
  } catch {
    New-Item -Path $path -ItemType 'Directory' -Force
  }
  ($folder).Attributes += 'Hidden'
  ```
</details>


Set the Execution Policy for the Windows PowerShell process to <span style="font-family:Consolas;font-size:1.05em;">RemoteSigned</span>. 

```powershell
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process'
```

Declare input variables, run <u>Start.ps1</u> and follow the subsequent on-screen instructions.  

```powershell
$EmailAddressOfBitwardenAccount = Read-Host -Prompt 'Email Address of Bitwarden Account'
${NetBIOS Name of Root Domain in AD Forest} = Read-Host -Prompt 'NetBIOS Name of Root Domain in AD Forest'
${DNS Name of Root Domain in AD Forest} = Read-Host -Prompt 'DNS Name of Root Domain in AD Forest'

$InputHT = @{
  EmailAddressOfBitwardenAccount             = $EmailAddressOfBitwardenAccount
  'NetBIOS Name of Root Domain in AD Forest' = ${NetBIOS Name of Root Domain in AD Forest}
  'DNS Name of Root Domain in AD Forest'     = ${DNS Name of Root Domain in AD Forest}
}
& '.\Instant-ADCS\Start.ps1' @InputHT
```

### (Refine)


  
<details>
<summary>THINGS YOU NEED BEFORE STARTING</summary>

Get these devices. Sign up for these accounts. 

## Hardware

<details>
<summary>Computers</summary>

1. Technician PC running a client edition of Windows 11.  
2. A desktop computer with at least 1 blank hard drive. This Hyper-V host machine will run Windows Server 2025 Datacenter. 
    * Minimum 16GB RAM
    * Virtualization-capable CPU
    * 3+ USB ports. 
    * Empty internal PCIe x1 slots (recommended)

</details>

<details>
<summary>External Computer Peripherals</summary>

1. 3 NTFS-formatted USB flash drives: Two for data storage and 1 for bootable media. Source USB flash drives from different manufacturers to distinguish in UEFI/BIOS boot menu. 
    * **usb0** will contain multiple .iso image files, VHDX files, and application installation files. 
    * **usb1** delivers 2-3 MB of scripts in as part of bare-metal OS deployment.
    * Bootable media USB will deploy an instance of Windows Server 2025 to bare-metal of desktop computer.
    * Perhaps a table is better suited to communicate this and other  requirements
2. Device capable of sending keystrokes to the computer via hardware macros/built-in software. Examples include the Retikal Pro Gaming Mouse from IOGear and the Rubber Ducky from Hak5. The device must not rely on an app installed within the OS. 
</details>

<details>
<summary>Internal Computer Peripherals</summary>

PCIe add-on cards for Ethernet. 
</details>

<details>
<summary>Network Devices</summary>

* Two MikroTik hEX S RB760iGS routers
* Cisco small business switch
* 3+ unmanaged switches
</details>

<details>
<summary>Network Components</summary>

* USB-to-Ethernet dongles
* 2 SFP-to-Ethernet adapters
* Ethernet cables of varying length. Possibly those connector dealies. 
</details>

<details>
<summary>Optional</summary>

Small multi-colored lanyards for the USBs.
</details>

## Accounts
<details>
<summary>Microsoft Account</summary>

* Sign up for a free Microsoft Account and visit the [OneDrive online portal](https://onedrive.live.com) to confirm functionality.   
</details>

<details>
<summary>Bitwarden</summary>

* Sign up for a free Bitwarden account. Generate an Access Token & a Machine Token. 
</details>
  
</details>

<details>

<summary>START HERE</summary>
  Tasks below are directed towards preparing **usb0**, **usb1**, and your bootable media. The "All Users All Hosts" Windows PowerShell profile (`%SystemRoot%\System32\WindowsPowerShell\v1.0\profile.ps1`) defines variables and functions necessary for the configuration of our external storage and the construction of our 3-tier AD-integrated PKI. 

  Rename your current profile.ps1: 
  ```powershell
  . "$env:SystemRoot\System32\WindowsPowerShell\v1.0\profile.ps1"
  Rename-Item -Path "$env:SystemRoot\System32\WindowsPowerShell\v1.0\profile.ps1" -NewName "profile Backup.ps1" -Force -PassThru
  ```

  <details>
  <summary>SLOW DOWN, I WANT TO UNDERSTAND THE DETAILS</summary>

  ## Software
  <details>
  <summary>OS Images</summary>

  * Windows Server 2025 ISO file
  * Windows 11 Enterprise ISO file
  </details>

  <details>
  <summary>Windows Updates</summary>

  Visit catalog.update.microsoft.com and download latest updates for Windows Server 2025 and Windows 11.
  </details>

  <details>
  <summary>Apps</summary>

  ### Bitwarden CLI
  Download from winget. 
  ### PowerShell 7-x64
  Download from winget. 
  ### Visual Studio Code
  Download 64-bit system installer. 
  ### OneDrive
  Download from Onedrive. 
  ### 7-Zip
  Download from internet. 
  ### MikroTik WinBox
  Download WinBox 4 from MikroTik website. 
  ### Rufus
  Download from internet. 
  </details>

  <details>
  <summary>Drivers</summary>

  * Ethernet drivers provided by the manufacturer of the USB-to-Ethernet dongles. Ethernet driver provided by Windows Server 2025 is insufficient. I learned that the hard way. 
  </details>
  
  <details>
  <summary>Modules</summary>

  Streamlined the complexity away from you. 

  <details>
  <summary>DSC Resource modules from the PowerShell Gallery/GitHub</summary>

  Download and install these DSC Resouce modules from GitHub or the PowerShell Gallery: 
  * xPSDesiredStateConfiguration
  * ComputerManagementDsc
  * WSManDsc
  * CertificateDsc
  * StorageDsc (prerelease version with that one screwball resource to create VHDX files)
  * ActiveDirectoryDsc
  * ActiveDirectoryCSDsc
  * NetworkingDsc
  * HyperVDsc
  * cHyper-V
  </details>
  
  <details>
  <summary>DSC Resource modules from this GitHub account</summary>

  Instant-ADCS requires custom authored DSC Resource modules available from this GitHub account: 
  * AdHocDsc
  * AdHocComposites? Or is that created in-code? 
  </details>
  
  <details>
  <summary>PowerShell 7 modules from this GitHub account</summary>

  Mainly for the generation & storage of extremely long passwords that persist across environment tear-downs & rebuilds. 
  * Secure-Automations-Toolset
  </details>
  

  </details>


  </details>

  <details>
  <summary>HURRY UP, I JUST WANT TO GET THROUGH THIS</summary>

  Launch Windows PowerShell as a standard user and execute this script. Note 'Execution Policy'. 

  ```powershell
  & "FileName0.ps1"
  ```
  </details>
</details>


<details>
<summary>Burn through these instructions</summary>

Blah BLah BLaH

<details>
  <summary>Do this, this, and this</summary>

  ```powershell
  ```


  ```powershell
  ```


  ```powershell
  ```


  ```powershell
  ```


  ```powershell
  ```


  ```powershell
  ```
</details>



```powershell
```

</details>

