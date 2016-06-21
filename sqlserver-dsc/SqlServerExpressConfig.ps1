$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = "localhost"
            Roles = "Setup, Development"
            <#  We should encrypt passwords normally
            CertificateFile = 'c:\PublicKeys\server1.cer'
                http://go.microsoft.com/fwlink/?LinkId=393729
            #>
            PSDscAllowPlainTextPassword = $True
            DatabaseConfig = @{
                SQLInstance = 'SQLEXPRESS'
                SQLServer = "$env:computername"
                LoginName = 'TestUser1'
                LoginType = 'SqlLogin'
                LoginCredential = ''
                ProtocolName = 'Tcp'
                IsEnabled = $True
                TCPDynamicPorts = ''
                TCPPort = '1433'
                RestartService = $True
                DatabaseName = 'TestDB'
                Permissions = @(
                    'ALTER','CREATETABLE','INSERT','DELETE','UPDATE','SELECT'
                    'CONNECT','REFERENCES','CREATEPROCEDURE','CREATEVIEW','EXECUTE'
                )
                Password = 'Pass5w0rd!'
            }
        }
    )
}

$SecurePassword = ConvertTo-SecureString -String $ConfigurationData.Password `
    -AsPlainText -Force
$UserName = "$env:computername\$env:username"
$InstallerServiceAccount = New-Object System.Management.Automation.PSCredential(
    $UserName, $SecurePassword)

$LocalSystemAccount = New-Object System.Management.Automation.PSCredential(
    $UserName, $SecurePassword)

$ConfigurationData.Credential = $InstallerServiceAccount

Configuration SqlServerExpressConfig
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName cChoco
	Import-DscResource -ModuleName xSQLServer

    Node $AllNodes.Where({ $_.Roles.Contains("Setup") }).NodeName
    {
        cChocoInstaller InstallChoco
        {
            InstallDir = "c:\choco"
        }

        cChocoPackageInstaller InstallSqlServerExpress
        {
            Ensure    = "Present"
            Name      = "mssqlserver2014express"
            Params    = "/CONFIGURATIONFILE=.\Configuration.ini"
            DependsOn = "[cChocoInstaller]InstallChoco"
        }

        xSQLServerLogin CreateLogin
        {
            Name            = $Node.DatabaseConfig.LoginName
            Ensure          = "Present"
            LoginCredential = $Node.DatabaseConfig.Credential
            LoginType       = $Node.DatabaseConfig.LoginType
            DependsOn       = "[cChocoPackageInstaller]InstallSqlServerExpress"
        }

        xSQLServerNetwork EnableTCP
        {
            InstanceName   = $Node.DatabaseConfig.SQLInstance
            ProtocolName   = $Node.DatabaseConfig.ProtocolName
            IsEnabled      = $Node.DatabaseConfig.IsEnabled
            TCPPort        = $Node.DatabaseConfig.TCPPort
            RestartService = $Node.DatabaseConfig.RestartService
            DependsOn      = "[cChocoPackageInstaller]InstallSqlServerExpress"
        }

        xSqlServerDatabase "CreateDatabase$($Node.DatabaseConfig.DatabaseName)"
        {
            Database        = $Node.DatabaseConfig.DatabaseName
            Ensure          = "Present"
            SQLServer       = $env:computername
            SQLInstanceName = $Node.DatabaseConfig.SQLInstance
            DependsOn       = "[cChocoPackageInstaller]InstallSqlServerExpress"
        }

        xSQLServerDatabasePermissions AddPermissions
        {
            Database        = $Node.DatabaseConfig.DatabaseName
            Name            = $Node.DatabaseConfig.LoginName
            Permissions     = $Node.DatabaseConfig.Permissions
            SQLServer       = $env:computername
            SQLInstanceName = $Node.DatabaseConfig.SQLInstance
            DependsOn       = @(
                "[xSqlServerDatabase]CreateDatabase$($Node.DatabaseConfig.DatabaseName)",
                "[xSQLServerLogin]CreateLogin"
            )
        }
    }
}
SqlServerExpressConfig -ConfigurationData $ConfigurationData
