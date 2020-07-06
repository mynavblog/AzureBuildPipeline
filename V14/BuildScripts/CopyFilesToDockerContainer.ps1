Write-Host "Copy files to Docker Container"
$settings = (Get-Content (Join-Path $PSScriptRoot "\settings.json") | ConvertFrom-Json)
$ContainerName = $settings.ContainerName 

$FilesToCopyToContainer = $settings.ContainerAddtionalFiles
foreach ($FileToCopyToContainer in $FilesToCopyToContainer)
{
    Write-Host "Copy file" $FileToCopyToContainer.FileName
    Copy-FileToNavContainer -containerName $ContainerName -localPath $FileToCopyToContainer.FilePathInLocal -containerPath $FileToCopyToContainer.FilePathInContainer
}

Restart-NavContainer -containerName $ContainerName