[CmdletBinding()]
param
(
    [Parameter()] $OutputPath = [IO.Path]::Combine(
        $PSScriptRoot, 'TentacleConfig'
    ),
    [Parameter()] $ConfigData
)

Configuration Tentacle
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -Name OctopusDSC

    Node $AllNodes.Where( {$_.Roles.Contains('Test')} ).NodeName
    {
        cTentacleAgent OctopusTentacle
        {
            Ensure                      = $Node.TentacleData.Ensure
            State                       = $Node.TentacleData.State
            Name                        = $Node.TentacleData.Name
            APIKey                      = $Node.TentacleData.APIKey
            OctopusServerUrl            = $Node.TentacleData.OctopusServerUrl
            Environments                = $Node.TentacleData.Environments
            Roles                       = $Node.TentacleData.Roles
            ListenPort                  = $Node.TentacleData.ListenPort
            DefaultApplicationDirectory = $Node.TentacleData.DefaultApplicationDirectory
        }
    }
}

Tentacle -OutputPath $OutputPath -ConfigData $ConfigData