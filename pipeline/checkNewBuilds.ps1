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
Write-Output "##vso[build.updatebuildnumber]$($onlineLatest).$($minorVer)"

# Check GitHub Tags for releases
$buildVersions = ((invoke-webrequest "$($githubAPI)/repos/$($githubOwner)/$($githubRepo)/releases" -UseBasicParsing).Content | ConvertFrom-Json).tag_name
$buildLatest = (($buildVersions | Sort-Object -Descending)[0])
Write-Output "Latest Jenkins built: $buildLatest"

# Set variable baed on if latest has already been built
If ($buildVersions -contains $onlineLatest) {
  Write-Output "build $onlineLatest already exists"
  Write-Output "##vso[task.setvariable variable=newBuild;]$false"
}
else {
  Write-Output "New build required"
  Write-Output "##vso[task.setvariable variable=newBuild;]$true"
}







# Write-Output "ServerNano: $versionnano"
# Write-Host "##vso[task.setvariable variable=versionNano;]$versionnano"



# http://mirrors.jenkins.io/war-stable/latest/jenkins.war