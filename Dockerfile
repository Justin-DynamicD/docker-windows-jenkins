FROM mcr.microsoft.com/windows/servercore:ltsc2019
#FROM mcr.microsoft.com/windows/nanoserver:1809

#Download required files
#--------------------
ADD ./artifacts/jenkins.msi C:/
ADD ./artifacts/jdk.exe C:/

#Install Java
#--------------------
RUN powershell start-process -filepath C:\jdk.exe -passthru -wait -argumentlist "/s,INSTALLDIR=c:\Java\jre1.8.0_91,/L,install64.log"
#RUN C:\\installers\jdk.exe /s INSTALLDIR=C:\\Java /L install64.log
RUN del C:\jdk.exe

#Install Jenkins
#--------------------
RUN msiexec /i C:\jenkins.msi /quiet /qn /norestart
RUN del C:\jenkins.msi

# LABEL must be last for proper base image discoverability
LABEL maintainer="justin.dynamicd@gmail.com"
LABEL description="Jenkinsci for Windows"