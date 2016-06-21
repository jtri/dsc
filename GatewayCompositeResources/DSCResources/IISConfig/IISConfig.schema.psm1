Configuration IISConfig
{

    param
    (
        $IISFeatures
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    ForEach ($feature in $IISFeatures.Enabled) {
        WindowsFeature "$($feature)"
        {
            Ensure = 'Present'
            Name   = $feature
        }
    }
}
