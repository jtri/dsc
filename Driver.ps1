
$oldVerbose = $VerbosePreference
$VerbosePreference = "continue"

. .\Helpers.ps1

Is-NugetProviderInstalled

Install-DSCModules

. .\GatewayConfig.ps1

#GatewayConfig

$VerbosePreference = $oldVerbose