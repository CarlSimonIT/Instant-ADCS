#region | Type Accelerator Instance |
$accelerators = [PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')
#        
$accelerators::Add('accelerator',$accelerators)
<#
  # View currently defined type accelerators
  $accelerators::Get

  # Delete all type accelerators. 
  $accelerators::Remove('accelerator')
#>
#endregion

