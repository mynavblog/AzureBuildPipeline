Param(
    [Parameter(Mandatory=$true)]
    [pscredential] $Credential,
    [Parameter(Mandatory=$true)]
    [string] $BuildArtifactFolder
)
Write-Host "Publishing single App" $BuildArtifactFolder
$settings = (Get-Content (Join-Path $PSScriptRoot "\settings.json") | ConvertFrom-Json)
$ContainerName = $settings.ContainerName

Get-ChildItem -Path $BuildArtifactFolder -Recurse -Include *.app | ForEach-Object {
    Write-Host "App: " $_.FullName
    Publish-NavContainerApp -containerName $ContainerName -appFile $_.FullName -skipVerification -sync -install
}