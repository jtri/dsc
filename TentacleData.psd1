@{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            Roles = 'Test'
            TentacleData = @{
                Ensure                      = "Present"
                State                       = "Started"
                Name                        = "Tentacle"
                APIKey                      = "#{OctopusAPIKey}"
                OctopusServerUrl            = "#{OctopusServerUrl}"
                Environments                = "Staging"
                Roles                       = "web-server"
                ListenPort                  = "10933"
                DefaultApplicationDirectory = "C:\Applications"
            }
        }
    )
}