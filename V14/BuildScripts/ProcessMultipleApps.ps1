Param(
    [Parameter(Mandatory=$true)]
    [pscredential] $Credential,
    [Parameter(Mandatory=$true)]
    [string] $BuildFolder,
    [Parameter(Mandatory=$true)]
    [string] $BuildArtifactFolder,
    [Parameter(Mandatory=$true)]
    [string] $AppToProcess,
    [Parameter(Mandatory=$true)]
    [string] $RepositoryExternalUser,
    [Parameter(Mandatory=$true)]
    [string] $RepositoryExternalPAT
)
Write-Host "Processing multiple apps"
$settings = (Get-Content (Join-Path $PSScriptRoot "\settings.json") | ConvertFrom-Json)
$ContainerName = $settings.ContainerName 
$App = $settings.ApplicationsToProcess | where {$_.ApplicationId -eq $AppToProcess }
Write-Host "Getting repository" $App.AppRepository " branch: " $App.AppRepositoryBranch

$GitCredential = "{0}:{1}" -f $RepositoryExternalUser, $RepositoryExternalPAT
$RepositoryUrl = $App.AppRepository -replace "://", ("://{0}@" -f $GitCredential)
$RepositoryName = $RepositoryUrl.split("/")[-1]
Write-Host "Repository Name " $RepositoryName
git clone $RepositoryUrl -b $App.AppRepositoryBranch --quiet 

Compile-AppInNavContainer -containerName $ContainerName -credential $Credential -appProjectFolder (Join-Path $BuildFolder $RepositoryName) -appOutputFolder (Join-Path $BuildArtifactFolder $RepositoryName) -UpdateSymbols -AzureDevOps | Out-Null

Get-ChildItem -Path (Join-Path $BuildArtifactFolder $RepositoryName) -Recurse -Include *.app | ForEach-Object {
    Write-Host "App: " $_.FullName
    Publish-NavContainerApp -containerName $ContainerName -appFile $_.FullName -skipVerification -sync -install
}


