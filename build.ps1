param (
  [Parameter(Mandatory = $false)]
  [string]$workingdir = ".\artifacts",

  [Parameter(Mandatory = $false)]
  [string]$jenkinsurl = "http://mirrors.jenkins.io/windows/latest",

  [Parameter(Mandatory = $false)]
  [string]$jdkurl = "http://javadl.oracle.com/webapps/download/AutoDL?BundleId=210185"
)

if (!(Test-Path $workingdir)) {
    New-Item -ItemType Directory $workingdir
}

$destinationJenkins = "${workingdir}\jenkins.zip"
$destinationJDK = "${workingdir}\jdk.exe"

if (!(Test-Path $destinationJenkins)) {
    Invoke-WebRequest -Uri $jenkinsurl -OutFile $destinationJenkins
    expand-archive -literalpath $destinationJenkins -destinationpath $workingdir -Force
}

if (!(Test-Path $destinationJDK)) {
    Invoke-WebRequest -Uri $jdkurl -OutFile $destinationJDK
}


docker build . -t dynamicd/jenksinci:v1
docker run -i -t --name jenkins dynamicd/jenksinci:v1 powershell.exe