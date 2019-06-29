param (
  [string]$minorVer = "1",
  [string]$url = "http://mirrors.jenkins.io/war-stable",
  [string]$file = "jenkins.war",
  [string]$githubAPI = "https://api.github.com",
  [string]$githubOwner = "Justin-DynamicD",
  [string]$githubRepo = "docker-windows-jenkins"
)

# Global Settings
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = "Stop"

# Check Online for latest version
$results = (Invoke-WebRequest $url -UseBasicParsing).links
$onlineVersions = ($results.href | Where-Object { $_ -ne "latest/" }).trimend("/")
[System.Collections.ArrayList]$formattedVersions = @()
$onlineVersions | ForEach-Object {
  try {
    $formattedVersions.add([version]$_) | Out-Null
  }
  catch{}
}
$onlineLatest = [string]($formattedVersions | Sort-Object -Descending)[0]
Write-Output "Latest Jenkins Online: $onlineLatest"

# Two vars are set: the first works within the job scope so the correct version gets installed.
# We also update the build number of the pipeline to contain this info during tagging
Write-Output "##vso[task.setvariable variable=versionJenkins;]$onlineLatest"
Write-Output "##vso[task.setvariable variable=versionJenkins;isOutput=true]$onlineLatest"
Write-Output "##vso[build.updatebuildnumber]$($onlineLatest).$($minorVer)"

# Check GitHub Tags for releases
$buildVersions = ((invoke-webrequest "$($githubAPI)/repos/$($githubOwner)/$($githubRepo)/tags" -UseBasicParsing).Content | ConvertFrom-Json).name
[System.Collections.ArrayList]$formattedVersions = @()
$buildVersions | ForEach-Object {
  try {
    [version]$updatedVer = ($_).trim("v")
    $formattedVersions.add($updatedVer) | Out-Null
  }
  catch{}
}
$buildLatest = [string]($formattedVersions | Sort-Object -Descending)[0]
Write-Output "Latest Jenkins built: $buildLatest"

# Set variable baed on if latest has already been built
If ($buildVersions -match $onlineLatest) {
  Write-Output "build $onlineLatest already exists"
  Write-Output "##vso[task.setvariable variable=newBuild;isOutput=true]$false"
}
else {
  Write-Output "New build required"
  Write-Output "##vso[task.setvariable variable=newBuild;isOutput=true]$true"
}
