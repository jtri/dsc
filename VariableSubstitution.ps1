<#
    Provide this script with a list of files and a subpattern of variables to match.
    It will then use a powershell script to replace and save the file with
    variables substituted from *matching" environment variable values (ie those
    set in Appveyor/TC/Octopus).
#>

[CmdletBinding()]
param
(
    [parameter(Mandatory=$true)]
    [System.String[]] $Files,
    [parameter(Mandatory=$true)]
    [System.String] $SubPattern
)

$EnvironmentVariables = (Get-ChildItem Env:).Where{ $_.Name -Match "$SubPattern" }

# Pretty naive implementation of variable substitution below -- terrible runtime

ForEach ($File in $Files) {
    ForEach ($EnvironmentVariable in $EnvironmentVariables) {
        .\Replace-FileString -Pattern "#{$($EnvironmentVariable.Name)}" `
                             -Replacement "$($EnvironmentVariable.Value)" `
                             -Path (Resolve-Path $File) `
                             -Overwrite
    }
}