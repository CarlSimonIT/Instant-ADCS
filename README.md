# Instant-ADCS
Quickly and securely build a Active Directory-integrated 3-tier PKI with Windows PowerShell, DSC version 1.1, and as little manual input as possible. 

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
  Tasks below are directed towards preparing **usb0**, **usb1**, and your bootable media. 

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

  * Bitwarden CLI
  * PowerShell 7-x64
  * Visual Studio Code
  * OneDrive
  * 7-Zip
  * MikroTik WinBox
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


