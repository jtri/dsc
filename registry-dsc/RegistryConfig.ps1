$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = "localhost"
            Role = "Setup, Development"
            RegistryValues = @{
                'key1'  = 'val1';
                'key2'  = 'val2';
                'key3'  = 'val3';
                'key4'  = 'val4';
                'key5'  = 'val5';
                ''      = '';
                'key6'  = 'val6';
                'key7'  = 'val7';
                'key8'  = 'val8';
                'key9'  = 'val9';
                'key10' = 'val10';
            }
            RegistryKeys = @{
                Key32 = ''
                Key64 = ''
            }
            DWordValues = @()
        }
    )
}

Configuration RegistryConfig
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.where{ $_.Role.Contains("Setup") }.NodeName
    {
        ForEach ($pair in $Node.RegistryValues.GetEnumerator()) {
        	if ($Node.DWordValues -contains $($pair.Name)) {
                Registry "$($pair.Name)_32"
                {
                    Ensure    = 'Present'
                    Key       = $Node.RegistryKeys.Key32
                    ValueName = $($pair.Name)
                    ValueData = $($pair.Value)
                    Force     = $true
                    Hex       = $true
                    ValueType = 'Dword'
                }
                Registry "$($pair.Name)_64"
                {
                    Ensure    = 'Present'
                    Key       = $Node.RegistryKeys.Key64
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
                    Key       = $Node.RegistryKeys.Key32
                    ValueName = $($pair.Name)
                    ValueData = $($pair.Value)
                    Force     = $true
                    ValueType = 'String'
        		}
                Registry "$($pair.Name)_64"
                {
                    Ensure    = 'Present'
                    Key       = $Node.RegistryKeys.Key64
                    ValueName = $($pair.Name)
                    ValueData = $($pair.Value)
                    Force     = $true
                    ValueType = 'String'
                }
        	}
        }
    }
}
RegistryConfig -ConfigurationData $ConfigurationData
