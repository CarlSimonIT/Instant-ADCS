#region | Location - Culture - Geography |
if (${Computer Info Lite}.WindowsInstallationType -ne 'Server Core') {
  ${SetupUILanguage-UILanguage} = Get-SystemPreferredUILanguage
}
${InputLocale} = ('{0:x4}' -f (Get-Culture).LCID) + ':' + ('{0:x8}' -f (Get-Culture).KeyboardLayoutId)
${SystemLocale} = ('{0:x4}' -f (Get-Culture).LCID) + ':' + ('{0:x8}' -f (Get-Culture).KeyboardLayoutId)
if (${Computer Info Lite}.WindowsInstallationType -ne 'Server Core') {
  ${UILanguage} = Get-SystemPreferredUILanguage
}
${UserLocale} = (Get-Culture).IetfLanguageTag
#endregion

