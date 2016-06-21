Configuration SqlServerExpressConfig
{
    param
    (
        $DatabaseConfig
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName cChoco
	Import-DscResource -ModuleName xSQLServer

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
        Name            = $DatabaseConfig.LoginName
        Ensure          = "Present"
        LoginCredential = $DatabaseConfig.Credential
        LoginType       = $DatabaseConfig.LoginType
        DependsOn       = "[cChocoPackageInstaller]InstallSqlServerExpress"
    }

    xSQLServerNetwork EnableTCP
    {
        InstanceName   = $DatabaseConfig.SQLInstance
        ProtocolName   = $DatabaseConfig.ProtocolName
        IsEnabled      = $DatabaseConfig.IsEnabled
        TCPPort        = $DatabaseConfig.TCPPort
        RestartService = $DatabaseConfig.RestartService
        DependsOn      = "[cChocoPackageInstaller]InstallSqlServerExpress"
    }

    xSqlServerDatabase "CreateDatabase$($DatabaseConfig.DatabaseName)"
    {
        Database        = $DatabaseConfig.DatabaseName
        Ensure          = "Present"
        SQLServer       = $env:computername
        SQLInstanceName = $DatabaseConfig.SQLInstance
        DependsOn       = "[cChocoPackageInstaller]InstallSqlServerExpress"
    }

    xSQLServerDatabasePermissions AddPermissions
    {
        Database        = $DatabaseConfig.DatabaseName
        Name            = $DatabaseConfig.LoginName
        Permissions     = $DatabaseConfig.Permissions
        SQLServer       = $env:computername
        SQLInstanceName = $DatabaseConfig.SQLInstance
        DependsOn       = @(
            "[xSqlServerDatabase]CreateDatabase$($DatabaseConfig.DatabaseName)",
            "[xSQLServerLogin]CreateLogin"
        )
    }
}
