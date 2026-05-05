# Instant-ADCS
Quickly and securely build a Active Directory-integrated 3-tier PKI with DSC version 1.1, Windows PowerShell, and as little manual input as possible. 

<details>
  <summary>START HERE</summary>

# Hardware

<details>
  <summary>Computers</summary>

  Your personal computer to deploy bootable media and generate precursor files. Windows 11 Home is sufficient. 
  
  A desktop computer with 1 blank hard drive and no other persistent storage. This Hyper-V host machine will run Windows Server 2025 Datacenter. 
  Minimum 16GB RAM
  virtualization-capable CPU
  several USB ports. 
  several internal PCIe slots
</details>

<details>
  <summary>External Computer Peripherals</summary>

  * 3+ USB flash drives, preferrably from different manufacturers. Smallest can be 1GB while the largest should hold 64GB. 
  * Device capable of sending keystrokes to the computer via hardware macros/built-in software. Examples include the Retikal Pro Gaming Mouse from IOGear and the Rubber Ducky from Hak5. The device must not rely on an app installed within the OS. 
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

# Software
<details>
  <summary>OS Images</summary>

  * Windows Server 2025 ISO file
  * Windows 11 Enterprise ISO file
</details>

<details>
  <summary>Windows Updates</summary>

  * Visit catalog.update.microsoft.com and download latest updates for Windows Server 2025 and Windows 11.
</details>

<details>
  <summary>Apps</summary>

  * Bitwardern CLI
  * PowerShell 7-x64
  * Visual Studio Code
  * OneDrive
  * 7-Zip
  * MikroTik WinBox
</details>

<details>
  <summary>Drivers</summary>

  * Ethernet drivers provided by the manufacturer of the USB-to-Ethernet dongles. Ethernet driver provide by Server 2025 is insufficient. I learned that the hard way. 
</details>
 
<details>
  <summary>PowerShell Modules</summary>

  * The following modules available from the PowerShell Gallery.
  * These modules available from these repositories on my GitHub. 
</details>

# Accounts
<details>
  <summary>Microsoft Account</summary>

  * Sign up for a free Microsoft Account and ensure OneDrive is functional. 
</details>
 
<details>
  <summary>Bitwarden</summary>

  * Sign up for a free Bitwarden account. Generate an Access Token & a Machine Token. 
</details>

 
 </details>



