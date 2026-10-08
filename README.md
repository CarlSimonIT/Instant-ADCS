# Instant-ADCS
Quickly and securely build an Active Directory-integrated 3-tier PKI with Windows PowerShell, DSC version 1.1, and as little manual input as possible. 

### New Local Standard Account
Exporting the contents of the Windows Credential Manager is a critical step in this workflow. Using a new non-administrative local account is advised to ensure that only secure strings directly relevant to Instant-ADCS are exported. 

Launch Windows PowerShell in a elevated security context and execute the lines below.    

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

Log off this current session and authenticate into Windows with the newly created local account. 

### Build External Media
Launch Windows PowerShell and install Git with WinGet in the user scope.  

```powershell
winget.exe install --id 'Git.Git' --scope 'user' --source 'winget'
```

Supply the fully qualified path of a directory for cloning multiple GitHub repositories.  
Ensure the folder exists and set as working directory.  

```powershell
$CloningRepoPath = "$env:UserProfile\GitHub\CarlSimonIT"
$CloningRepoFolder = try {
  Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'
} catch {
  New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force
}
Set-Location -Path "$CloningRepoFolder"
```

Clone the Instant-ADCS and [Secure Automations Toolset](https://github.com/CarlSimonIT/Secure-Automations-Toolset) repositories into their own dedicated directories. Set new temporary and hidden directory for information exchange between PowerShell versions. 

```powershell
$GitHubRepositoryName = 'Secure-Automations-Toolset'
. "$env:LocalAppData\Programs\Git\cmd\git.exe"` clone "https://github.com/CarlSimonIT/$GitHubRepositoryName.git" $GitHubRepositoryName
$GitHubRepositoryName = 'Instant-ADCS'
. "$env:LocalAppData\Programs\Git\cmd\git.exe" clone "https://github.com/CarlSimonIT/$GitHubRepositoryName.git" $GitHubRepositoryName

$path = ".\.CommonItems"
$folder = try {
  Get-Item -Path $path -ErrorAction 'Stop'
} catch {
  New-Item -Path $path -ItemType 'Directory' -Force
}
($folder).Attributes += 'Hidden'
```

Set the Execution Policy for the Windows PowerShell process to RemoteSigned.  
Run <u>Start.ps1</u> and follow the subsequent on-screen instructions.  

```powershell
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process'
$EmailAddressOfBitwardenAccount = Read-Host -Prompt 'Email Address of Bitwarden Account'
${NetBIOS Name of Root Domain in AD Forest} = Read-Host -Prompt 'NetBIOS Name of Root Domain in AD Forest'
${DNS Name of Root Domain in AD Forest} = Read-Host -Prompt 'DNS Name of Root Domain in AD Forest'

$HT = @{
  EmailAddressOfBitwardenAccount              =   $EmailAddressOfBitwardenAccount
  'NetBIOS Name of Root Domain in AD Forest'  =   ${NetBIOS Name of Root Domain in AD Forest}
  'DNS Name of Root Domain in AD Forest'      =   ${DNS Name of Root Domain in AD Forest}
}
& '.\Instant-ADCS\Start.ps1' @HT
```

```powershell
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process'
$HT = @{EmailAddressOfBitwardenAccount = 'pwdsec3@gmail.com'; 'Folder Fully Qualified Name' = 'Instant-ADCS'; BadPassword = 'BadPassword!'; 'NetBIOS Name of Root Domain in AD Forest' = 'BlackCoffee'; 'DNS Name of Root Domain in AD Forest' = 'ad.black-coffee-black-coffee-black-coffee-black-coffee.INTERNAL'}
& '.\Instant-ADCS\Start.ps1' @HT
```

### (Refine)


  
<details>
<summary>THINGS YOU NEED BEFORE STARTING</summary>

Get these devices. Sign up for these accounts. 

## Hardware

<details>
<summary>Computers</summary>

1. Your personal computer to deploy bootable media and generate precursor files. Windows 11 Home is sufficient. 
2. A desktop computer with 1 blank hard drive and no other persistent storage. This Hyper-V host machine will run Windows Server 2025 Datacenter. 
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

