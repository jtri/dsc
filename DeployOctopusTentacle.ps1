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

# Hardcode config file for now
$ConfigFile = Join-Path -Path $ScriptDir -ChildPath TentacleConfig.ps1
$ConfigData = Join-Path -Path $ScriptDir -ChildPath TentacleData.psd1

# Replace sensitive data
.\VariableSubstitution.ps1 -Files $ConfigData -SubPattern $SubPattern

# Compile DSC Configuration

# Start DSC Configuration