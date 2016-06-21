$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = "localhost"
            Roles = "Setup, Development"
            IISFeatures = @{
                Enabled = @(
                    'Web-Server','Web-WebServer','Web-Default-Doc',
                    'Web-Http-Errors','Web-Static-Content','Web-Health',
                    'Web-Http-Logging','Web-Performance','Web-Stat-Compression',
                    'Web-Security','Web-Filtering','Web-App-Dev','Web-Net-Ext',
                    'Web-Net-Ext45','Web-Asp-Net','Web-Asp-Net45','Web-ISAPI-Ext',
                    'Web-ISAPI-Filter','Web-Mgmt-Tools','Web-Scripting-Tools',
                    'Net-Framework-Features','Net-Framework-Core',
                    'Net-Framework-45-Features','Net-Framework-45-Core',
                    'Net-Framework-45-ASPNET','Net-WCF-Services45',
                    'NET-WCF-TCP-PortSharing4','FS-SMB1','PowerShellRoot',
                    'PowerShell','PowerShell-V2','DSC-Service','WoW64-Support'
                )
            }
        }
    )
}

Configuration IISConfig
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node $AllNodes.Where({ $_.Roles.Contains("Setup") }).NodeName
    {
        ForEach ($feature in $Node.IISFeatures.Enabled) {
            WindowsFeature "$($feature)"
            {
                Ensure = 'Present'
                Name   = $feature
            }
        }
    }
}
IISConfig -ConfigurationData $ConfigurationData
