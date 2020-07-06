Param(
    [Parameter(Mandatory = $true)]
    [pscredential] $credential
)
$settings = (Get-Content (Join-Path $PSScriptRoot "\settings.json") | ConvertFrom-Json)

$ContainerName = $settings.ContainerName 
$ContainerLicFile = $settings.ContainerLicFile 
$Artifact = $settings.ArtifactSettings
$ArtifactType = $Artifact.Type
$ArtifactSelect = $Artifact.Select
$ArtifactVersion = $Artifact.Version
$ArtifactCountry = $Artifact.Country
$ArtifactToken = $Artifact.Token
$ArtifactStorageAccount = '';

Write-Host -ForegroundColor Green "Artifact parameters: -type $ArtifactType -select $ArtifactSelect -version $ArtifactVersion -country $ArtifactCountry -storageAccount $ArtifactStorageAccount -sasToken $ArtifactToken"

if ([string]::IsNullOrEmpty($ArtifactToken)) {
    Write-Host -ForegroundColor Green "Get Latest build"
    $ArtifactURL = Get-BCArtifactUrl -type $ArtifactType -select $ArtifactSelect -version $ArtifactVersion -country $ArtifactCountry
}
else {
    $ArtifactStorageAccount = 'bcinsider'
    Write-Host -ForegroundColor Green "Get inside build"
    $ArtifactURL = Get-BCArtifactUrl -type $ArtifactType  -country $ArtifactCountry -storageAccount $ArtifactStorageAccount -sasToken $ArtifactToken
} 

Write-Host -ForegroundColor Green "Create container name $ContainerName from Artifact Url $ArtifactURL"


$segments = "$PSScriptRoot".Split('\')
$rootFolder = "$($segments[0])\$($segments[1])"
$additionalParameters = @("--volume ""$($rootFolder):C:\Agent""")
$myscripts = @(@{'MainLoop.ps1' = 'while ($true) { start-sleep -seconds 10 }' })
    

New-NavContainer @parameters `
    -accept_eula:$true `
    -containerName $containerName `
    -artifactUrl $ArtifactURL `
    -auth NAVUserPassword `
    -Credential $credential `
    -updateHosts `
    -doNotExportObjectsToText `
    -includeTestToolkit `
    -includeTestLibrariesOnly `
    -shortcuts None `
    -enableTaskScheduler:$false `
    -accept_outdated:$true `
    -licenseFile "$ContainerLicFile" `
    -additionalParameters $additionalParameters `
    -myScripts $myscripts