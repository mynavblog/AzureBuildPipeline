Param(
    [Parameter(Mandatory=$true)]
    [pscredential] $credential
)

$settings = (Get-Content (Join-Path $PSScriptRoot "\settings.json") | ConvertFrom-Json)
$ContainerImage  = $settings.ContainerImage 
$ContainerName = $settings.ContainerName 
$ContainerLicFile = $settings.ContainerLicFile 

Write-Host "Create $ContainerName from $ContainerImage"

$segments = "$PSScriptRoot".Split('\')
$rootFolder = "$($segments[0])\$($segments[1])"
$additionalParameters = @("--volume ""$($rootFolder):C:\Agent""")
$myscripts = @(@{'MainLoop.ps1' = 'while ($true) { start-sleep -seconds 10 }'})
    

New-NavContainer @parameters `
                -accept_eula:$true `
                -containerName $containerName `
                -imageName $ContainerImage `
                -auth NAVUserPassword `
                -Credential $credential `
                -alwaysPull `
                -updateHosts `
                -includeCSide `
                -doNotExportObjectsToText `
                -assignPremiumPlan `
                -enableSymbolLoading `
                -includeTestToolkit `
                -accept_outdated `
                -shortcuts None `
                -licenseFile "$ContainerLicFile" `
                -additionalParameters $additionalParameters `
                -myScripts $myscripts