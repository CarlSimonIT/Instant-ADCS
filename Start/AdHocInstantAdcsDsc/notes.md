

```powershell
code "C:\Program Files\WindowsPowerShell\Modules\AdHocUtilsDsc\0.33.3.3\AdHocUtilsDsc.psd1"

(Get-ItemPropertyValue -LiteralPath 'HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full' -Name Release) -ge 394802

start msedge.exe 'https://learn.microsoft.com/en-us/dotnet/framework/install/how-to-determine-which-versions-are-installed'
start msedge.exe 'https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes?view=powershell-7.6#manually-import-classes-from-a-powershell-module'
```


Manually import classes from a PowerShell module
Import-Module and the #Requires statement only import the module functions, aliases, and variables, as defined by the module. Classes aren't imported.

If a module defines classes and enumerations but doesn't add type accelerators for those types, use a using module statement to import them.

The using module statement imports classes and enumerations from the root module (ModuleToProcess) of a script module or binary module. It doesn't consistently import classes defined in nested modules or classes defined in scripts that are dot-sourced into the root module. Define classes that you want to be available to users outside of the module directly in the root module.

For more information about the using statement, see about_Using.


