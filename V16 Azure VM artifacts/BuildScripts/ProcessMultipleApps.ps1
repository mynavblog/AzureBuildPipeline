Param(
    [Parameter(Mandatory=$true)]
    [pscredential] $Credential,
    [Parameter(Mandatory=$true)]
    [string] $BuildFolder,
    [Parameter(Mandatory=$true)]
    [string] $BuildArtifactFolder,
    [Parameter(Mandatory=$true)]
    [string] $AppToProcess
)

$settings = (Get-Content (Join-Path $PSScriptRoot "\settings.json") | ConvertFrom-Json)
$ContainerName = $settings.ContainerName 
$App = $settings.ApplicationsToProcess | where {$_.ApplicationId -eq $AppToProcess }

Write-Host -ForegroundColor Green "Getting App" $App.AppFolder 

Compile-AppInNavContainer -containerName $ContainerName -credential $Credential -appProjectFolder (Join-Path $BuildFolder $App.AppFolder) -appOutputFolder (Join-Path $BuildArtifactFolder $App.AppFolder) -UpdateSymbols -AzureDevOps | Out-Null

Get-ChildItem -Path (Join-Path $BuildArtifactFolder $App.AppFolder) -Recurse -Include *.app | ForEach-Object {
    Write-Host "App: " $_.FullName
    Publish-NavContainerApp -containerName $ContainerName -appFile $_.FullName -skipVerification -sync -install
}


