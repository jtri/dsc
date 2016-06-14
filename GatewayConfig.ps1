Configuration GatewayConfig
{
	Node $env:computername
	{
		WindowsFeature IISWeb_Server
		{
			Ensure = "Present"
			Name = "Web-Server"
		}

		WindowsFeature IISWeb_WebServer
		{
			Ensure = "Present"
			Name = "Web-WebServer"
		}

		WindowsFeature IISWeb_Default_Doc
		{
			Ensure = "Present"
			Name = "Web-Default-Doc"
		}

		WindowsFeature IISWeb_Http_Errors
		{
			Ensure = "Present"
			Name = "Web-Http-Errors"
		}

		WindowsFeature IISWeb_Static_Content
		{
			Ensure = "Present"
			Name = "Web-Static-Content"
		}

		WindowsFeature IISWeb_Health
		{
			Ensure = "Present"
			Name = "Web-Health"
		}

		WindowsFeature IISWeb_Http_Logging
		{
			Ensure = "Present"
			Name = "Web-Http-Logging"
		}

		WindowsFeature IISWeb_Performance
		{
			Ensure = "Present"
			Name = "Web-Performance"
		}

		WindowsFeature IISWeb_Stat_Compression
		{
			Ensure = "Present"
			Name = "Web-Stat-Compression"
		}

		WindowsFeature IISWeb_Security
		{
			Ensure = "Present"
			Name = "Web-Security"
		}

		WindowsFeature IISWeb_Filtering
		{
			Ensure = "Present"
			Name = "Web-Filtering"
		}

		WindowsFeature IISWeb_App_Dev
		{
			Ensure = "Present"
			Name = "Web-App-Dev"
		}

		WindowsFeature IISWeb_Net_Ext
		{
			Ensure = "Present"
			Name = "Web-Net-Ext"
		}

		WindowsFeature IISWeb_Net_Ext45
		{
			Ensure = "Present"
			Name = "Web-Net-Ext45"
		}

		WindowsFeature IISWeb_Asp_Net
		{
			Ensure = "Present"
			Name = "Web-Asp-Net"
		}

		WindowsFeature IISWeb_Asp_Net45
		{
			Ensure = "Present"
			Name = "Web-Asp-Net45"
		}

		WindowsFeature IISWeb_ISAPI_Ext
		{
			Ensure = "Present"
			Name = "Web-ISAPI-Ext"
		}

		WindowsFeature IISWeb_ISAPI_Filter
		{		
			Ensure = "Present"
			Name = "Web-ISAPI-Filter"
		}

		WindowsFeature IISWeb_Mgmt_Tools
		{
			Ensure = "Present"
			Name = "Web-Mgmt-Tools"
		}

		WindowsFeature IISWeb_Scripting_Tools
		{
			Ensure = "Present"
			Name = "Web-Scripting-Tools"
		}

		WindowsFeature NET35Framework_Features
		{
			Ensure = "Present"
			Name = "Net-Framework-Features"
		}

		WindowsFeature NET35Framework_Core
		{
			Ensure = "Present"
			Name = "Net-Framework-Core"
		}

		WindowsFeature NET45Framework_Features
		{
			Ensure = "Present"
			Name = "Net-Framework-45-Features"
		}

		WindowsFeature NET45Framework_Core
		{
			Ensure = "Present"
			Name = "Net-Framework-45-Core"
		}

		WindowsFeature NET45Framework_ASPNET
		{
			Ensure = "Present"
			Name = "Net-Framework-45-ASPNET"
		}

		WindowsFeature NET_WCF_Services45
		{
			Ensure = "Present"
			Name = "Net-WCF-Services45"
		}

		WindowsFeature NET_WCF_TCP_PortSharing
		{
			# This may be entire unnecessary	
			Ensure = "Present"
			Name = "NET-WCF-TCP-PortSharing45"
		}

		WindowsFeature SMB_FS_SMB1
		{
			Ensure = "Present"
			Name = "FS-SMB1"
		}

		WindowsFeature WindowsPowerShell_PowerShellRoot
		{
			Ensure = "Present"
			Name = "PowerShellRoot"
		}
		WindowsFeature WindowsPowerShell_PowerShell
		{
			Ensure = "Present"
			Name = "PowerShell"
		}

		WindowsFeature WindowsPowerShell_PowerShell_V2
		{
			Ensure = "Present"
			Name = "PowerShell-V2"
		}

		WindowsFeature WindowsPowerShell_DSC_Service
		{
			Ensure = "Present"
			Name = "DSC-Service"
		}

		WindowsFeature WoW64
		{
			Ensure = "Present"
			Name = "WoW64-Support"
		}
	}
}
GatewayConfig
