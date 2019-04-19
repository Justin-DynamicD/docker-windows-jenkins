#start builder container to prep java
FROM mcr.microsoft.com/windows/servercore:1809

#Download required files
ADD http://javadl.oracle.com/webapps/download/AutoDL?BundleId=210185 C:/install/jre.exe
ADD http://mirrors.jenkins.io/war-stable/latest/jenkins.war C:/jenkins/jenkins.war

#Install Java into builder so bin can be copied
RUN powershell start-process -filepath C:\install\jre.exe -passthru -wait -argumentlist "/s,INSTALLDIR=c:\java,/L,install64.log"

#set envirnoment vars
ENV JENKINS_HOME c:\jenkins_home
ENV JAVA_HOME c:\java

#bootstrap jenkins
CMD c:\java\bin\java -jar c:\jenkins\jenkins.war

# LABEL and EXPOSE to document runtime settings
VOLUME c:/jenkins_home
EXPOSE 8080/tcp
LABEL maintainer="justin.dynamicd@gmail.com"
LABEL description="Jenkinsci for Windows"