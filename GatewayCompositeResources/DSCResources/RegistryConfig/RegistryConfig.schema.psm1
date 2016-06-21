Configuration RegistryConfig
{
    param
    (
        $RegistryValues,
        $RegistryKeys,
        $DWordValues
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    ForEach ($pair in $RegistryValues.GetEnumerator()) {
    	if ($DWordValues -contains $($pair.Name)) {
            Registry "$($pair.Name)_32"
            {
                Ensure    = 'Present'
                Key       = $RegistryKeys.Key32
                ValueName = $($pair.Name)
                ValueData = $($pair.Value)
                Force     = $true
                Hex       = $true
                ValueType = 'Dword'
            }
            Registry "$($pair.Name)_64"
            {
                Ensure    = 'Present'
                Key       = $RegistryKeys.Key64
                ValueName = $($pair.Name)
                ValueData = $($pair.Value)
                Force     = $true
                Hex       = $true
                ValueType = 'Dword'
            }
    	}
    	else {
    		Registry "$($pair.Name)_32"
    		{
                Ensure    = 'Present'
                Key       = $RegistryKeys.Key32
                ValueName = $($pair.Name)
                ValueData = $($pair.Value)
                Force     = $true
                ValueType = 'String'
    		}
            Registry "$($pair.Name)_64"
            {
                Ensure    = 'Present'
                Key       = $RegistryKeys.Key64
                ValueName = $($pair.Name)
                ValueData = $($pair.Value)
                Force     = $true
                ValueType = 'String'
            }
    	}
    }
}
