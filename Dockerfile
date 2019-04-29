# #start builder container to prep java
FROM mcr.microsoft.com/windows/servercore:1809 as builder

#Download and install Java into builder so java can be copied
ADD http://javadl.oracle.com/webapps/download/AutoDL?BundleId=210185 C:/install/jre.exe
RUN powershell start-process -filepath C:\install\jre.exe -passthru -wait -argumentlist "/s,INSTALLDIR=c:\java,/L,install64.log"
RUN openssl s_client -connect google.com:443 –servername google.com:443 < NUL | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > public.crt


# start nano container
FROM mcr.microsoft.com/windows/nanoserver:1809

#Copy and configure Java
COPY --from=builder C:/java C:/java/1.8.0_91
ENV JAVA_HOME c:\\java\\1.8.0_91
ENV JAVA_VERSION 1.8.0_91
ENV CLASSPATH c:\\java\\1.8.0_91\\lib
ENV JAVA_TOOL_OPTIONS -Djava.awt.headless=true
ENV PATH C:\\java\\1.8.0_91\\bin;C:\\Windows\\system32;C:\\Windows;

#Copy and configure Jenkins
ADD http://mirrors.jenkins.io/war-stable/latest/jenkins.war C:/jenkins/jenkins.war
ENV JENKINS_HOME c:\\jenkins_home

#bootstrap jenkins
CMD c:\java\1.8.0_91\bin\java.exe -jar c:\jenkins\jenkins.war

# LABEL and EXPOSE to document runtime settings
VOLUME c:/jenkins_home
EXPOSE 8080/tcp
LABEL maintainer="justin.dynamicd@gmail.com"
LABEL description="Jenkinsci for Windows"