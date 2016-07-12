param
(
    [System.String] $SubPattern = 'USER'
)

$ModulePath = $env:PSModulePath.Split(';') -like 'C:\Program Files\*'

$ScriptDir = Split-Path $MyInvocation.MyCommand.Path

$Modules = @('OctopusDSC')

ForEach ($Module in $Modules) {
    $Source = Join-Path -Path $ScriptDir -ChildPath $Module
    Copy-Item -Path $Source -Destination $($ModulePath) -ErrorAction SilentlyContinue
}
#$wmf5 = https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/W2K12-KB3134759-x64.msu
#iwr $wmf5 -outfile 'C:\wmf5.msu'

# Hardcode config file for now
$ConfigFile = Join-Path -Path $ScriptDir -ChildPath TentacleConfig.ps1
$ConfigData = Join-Path -Path $ScriptDir -ChildPath TentacleData.psd1

# Replace sensitive data
.\VariableSubstitution.ps1 -Files $ConfigData -SubPattern $SubPattern

# Compile DSC Configuration
.\TentacleConfig.ps1 -ConfigData $ConfigData

# Start DSC Configuration
Start-DscConfiguration .\TentacleConfig -Wait -Verbose -Force