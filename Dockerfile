#start builder container to prep java
FROM mcr.microsoft.com/windows/servercore:1809 as builder

#set envirnoment vars
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#Download and install java
ADD http://javadl.oracle.com/webapps/download/AutoDL?BundleId=210185 C:/install/jre.exe
RUN start-process -filepath C:\install\jre.exe -passthru -wait -argumentlist "/s,INSTALLDIR=c:\Java,/L,install64.log"

# start nano container
FROM mcr.microsoft.com/windows/nanoserver:1809

#copy unzipped files and download remaining
COPY --from=builder c:/java c:/java
ADD http://mirrors.jenkins.io/war-stable/latest/jenkins.war C:/jenkins/jenkins.war

#set environment variables for Jenkins
ENV JENKINS_HOME c:\\jenkins_home
ENV JAVA_HOME c:\\java
ENV PATH C:\\java\\bin;C:\\Windows\\system32;C:\\Windows;

#bootstrap jenkins
CMD c:\java\bin\java -jar c:\jenkins\jenkins.war

# LABEL and EXPOSE to document runtime settings
VOLUME c:/jenkins_home
EXPOSE 8080/tcp
LABEL maintainer="justin.dynamicd@gmail.com"
LABEL description="Jenkinsci for Windows"