Write-Host "Checking for NavContainerHelper"

$module = Get-InstalledModule -Name navcontainerhelper -ErrorAction Ignore
if ($module) {
	$versionStr = $module.Version.ToString()
	Write-Host "NavContainerHelper $VersionStr is installed"
	Write-Host "Determine latest NavContainerHelper version"
	$latestVersion = (Find-Module -Name navcontainerhelper).Version
	$latestVersionStr = $latestVersion.ToString()
	Write-Host "NavContainerHelper $latestVersionStr is the latest version"
	if ($latestVersion -gt $module.Version) {
		Write-Host "Updating NavContainerHelper to $latestVersionStr"
		Update-Module -Name navcontainerhelper -Force -RequiredVersion $latestVersionStr
		Write-Host "NavContainerHelper updated"
	}
} else {
	if (!(Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction Ignore)) {
		Write-Host "Installing NuGet Package Provider"
		Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.208 -Force -WarningAction Ignore | Out-Null
	}
	Write-Host "Installing NavContainerHelper"
	Install-Module -Name navcontainerhelper -Force
	$module = Get-InstalledModule -Name navcontainerhelper -ErrorAction Ignore
	$versionStr = $module.Version.ToString()
	Write-Host "NavContainerHelper $VersionStr installed"
}
