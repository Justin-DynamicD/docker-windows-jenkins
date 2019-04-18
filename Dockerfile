FROM mcr.microsoft.com/windows/servercore:ltsc2019

#set envirnoment vars
ENV JENKINS_HOME c:\jenkins_home
ENV JAVA_HOME c:\java

#Download required files
ADD http://mirrors.jenkins.io/war-stable/latest/jenkins.war C:/jenkins/jenkins.war
ADD http://javadl.oracle.com/webapps/download/AutoDL?BundleId=210185 C:/install/jre.exe

#Install Java
RUN powershell start-process -filepath C:\install\jre.exe -passthru -wait -argumentlist "/s,INSTALLDIR=c:\java,/L,install64.log"

#cleanup
RUN rmdir /s /q C:\install

#bootstrap jenkins
CMD c:\java\bin\java -jar c:\jenkins\jenkins.war

# LABEL and EXPOSE to document runtime settings
VOLUME c:/jenkins_home
EXPOSE 8080/tcp
LABEL maintainer="justin.dynamicd@gmail.com"
LABEL description="Jenkinsci for Windows"