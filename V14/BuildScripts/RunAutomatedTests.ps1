Param(
    [Parameter(Mandatory=$true)]
    [pscredential] $Credential,
    [Parameter(Mandatory=$true)]
    [string] $TestResultFile,
    [Parameter(Mandatory=$true)]
    [string] $TestSuite
)
Write-Host "Running Automated Tests"
$settings = (Get-Content (Join-Path $PSScriptRoot "\settings.json") | ConvertFrom-Json)
$ContainerName = $settings.ContainerName

$TempTestResultFile = "C:\ProgramData\NavContainerHelper\Extensions\$ContainerName\TestResults.xml"
Run-TestsInNavContainer -containerName $containerName -XUnitResultFileName $TempTestResultFile -testSuite $TestSuite -credential $credential -AzureDevOps warning
Copy-Item -Path $TempTestResultFile -Destination $TestResultFile -Force
