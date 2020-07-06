
$settings = (Get-Content (Join-Path $PSScriptRoot "\settings.json") | ConvertFrom-Json)
$ContainerName = $settings.ContainerName 

Write-Host "Remove $ContainerName"
   
Remove-NavContainer -containerName $ContainerName 