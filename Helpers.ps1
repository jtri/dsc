function Install-NugetProvider
{
	param
	(
	 	[String] $Version = '2.8.201'
	)
	Write-Verbose 'Installing NuGet package management.'
	Install-PackageProvider -Name NuGet -MinimumVersion $Version -Force
	Import-PackageProvider -Name NuGet -MinimumVersion $Version -Force
}

function Remove-OldNugetProvider
{
	<# First cut of function -- not tested #>
	param
	(
	 	[Parameter(Mandatory)]
	 	[String] $Version
	)
	$dir1 = ""
	$dir2 = ""
	Get-ChildItem -Path $dir1 -Recurse | ? {
		$_.Name -lt $Version
	} | Remove-Item
	Get-ChildItem -Path $dir2 -Recurse | ? {
		$_.Name -lt $Version
	} | Remove-Item
}

function Is-NugetProviderInstalled
{
	if ((-not (Test-Path "$env:ProgramFiles\PackageManagement\ProviderAssemblies\nuget")) `
	     -and `
	     (-not (Test-Path "$env:LOCALAPPDATA\PackageManagement\ProviderAssemblies\nuget")))
	{
		Write-Verbose 'NuGet package management not found.'
		Install-NugetProvider
	}
}

function Install-DSCModules
{
	param
	(
	 	[String[]] $desired = @('xSQLServer', 'cChoco')
	)
	$installed = @()
	Get-DscResource | ForEach-Object {
	  $installed += $_.Name
	}

	foreach ($item in $desired) {
		if (-not $installed.Contains($item)) {
			Find-Module -Name $item | Install-Module -Name $item -Force
		}
	}
}

function Install-Chocolatey
{
	Write-Verbose 'Installing chocolatey'
	iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

function Is-ChocolateyInstalled
{
	if (-not (Test-Path $env:ChocolateyInstall)) {
		Write-Verbose 'Chocolatey not found.'
		Install-Chocolatey
	}
}

function Install-Wmf
{
	Write-Verbose 'Installing PowerShell 5.0'
	$CMD = "$env:ChocolateyInstall\bin\cinst.exe"
	& $CMD 'powershell' '-y'
}

function Is-WmfInstalled
{
	if (-not (Test-Path "$env:ChocolateyInstall\lib\PowerShell")) {
		Write-Verbose 'PowerShell 5.0 required but not found.'
		Install-Wmf
		Restart-Computer
	}
}


function Get-OctopusDSC
{
	$psmodulepath = $env:PSModulePath.Split(';')
	$psmodulepath = $psmodulepath -like "*\Program Files\*"
	if (-not (Test-Path "$psmodulepath\OctopusDSC")) {
		#Remove-Item "$psmodulepath\OctopusDSC" -Recurse -Force
		& 'git' 'clone' 'https://github.com/OctopusDeploy/OctopusDSC.git' "$psmodulepath\OctopusDSC"

	}
}

$packageManagementUrl = '/en-us/download/confirmation.aspx?id=51451&6B49FDFB-8E5B-4B07-BC31-15695C5A2143=1'
