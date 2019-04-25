# start nano container
FROM mcr.microsoft.com/windows/nanoserver:1809

#Download required files
ADD https://download.java.net/java/ga/jdk11/openjdk-11_windows-x64_bin.zip C:/install/java.zip
ADD http://mirrors.jenkins.io/war-stable/latest/jenkins.war C:/jenkins/jenkins.war

#Unzip and configure Java
RUN tar -C C:\ -xvf C:\install\java.zip
RUN ren jdk-11 java
ENV JAVA_HOME c:\\java
ENV JAVA_TOOL_OPTIONS -Djava.awt.headless=true
ENV PATH C:\\java\\bin;C:\\Windows\\system32;C:\\Windows;

#set environment variables for Jenkins
ENV JENKINS_HOME c:\\jenkins_home

#bootstrap jenkins
CMD c:\java\bin\java.exe -jar c:\jenkins\jenkins.war

# LABEL and EXPOSE to document runtime settings
VOLUME c:/jenkins_home
EXPOSE 8080/tcp
LABEL maintainer="justin.dynamicd@gmail.com"
LABEL description="Jenkinsci for Windows"