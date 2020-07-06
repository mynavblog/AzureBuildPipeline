Param(
    [Parameter(Mandatory=$true)]
    [pscredential] $Credential,
    [Parameter(Mandatory=$true)]
    [string] $BuildFolder,
    [Parameter(Mandatory=$true)]
    [string] $BuildArtifactFolder
)
Write-Host "Compiling single App"
$settings = (Get-Content (Join-Path $PSScriptRoot "\settings.json") | ConvertFrom-Json)
$ContainerName = $settings.ContainerName

Compile-AppInNavContainer -containerName $ContainerName -credential $Credential -appProjectFolder (Join-Path $BuildFolder $_) -appOutputFolder (Join-Path $BuildArtifactFolder $_) -UpdateSymbols -AzureDevOps | Out-Null