FROM mcr.microsoft.com/windows/servercore:ltsc2019

#Download required files
ADD http://mirrors.jenkins.io/windows/latest /install/jenkins.zip
ADD http://javadl.oracle.com/webapps/download/AutoDL?BundleId=210185 /install/jre.exe

#Extract zips
RUN powershell expand-archive -literalpath C:\install\jenkins.zip -destinationpath C:\install -Force

#Install Java
RUN powershell start-process -filepath C:\install\jre.exe -passthru -wait -argumentlist "/s,INSTALLDIR=c:\Java\jre1.8.0_91,/L,install64.log"

#Install Jenkins
RUN msiexec /i C:\install\jenkins.msi /quiet /qn /norestart

#cleanup
RUN powershell -command rm -Recurse C:\install -Force

# LABEL must be last for proper base image discoverability
LABEL maintainer="justin.dynamicd@gmail.com"
LABEL description="Jenkinsci for Windows"