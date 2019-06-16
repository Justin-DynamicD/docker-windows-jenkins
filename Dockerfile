###
# start builder
###

# set default args
ARG VERSIONNANO=1809
ARG VERSIONJENKINS=latest

# builder is running core, as nano does not support msi nor gui-dependant exe installers
FROM mcr.microsoft.com/windows/servercore:${VERSIONNANO} as builder
ARG VERSIONJENKINS
ENV VERSIONJENKINS $VERSIONJENKINS

# Download jenkins.war
ADD http://mirrors.jenkins.io/war-stable/$VERSIONJENKINS/jenkins.war C:/install/jenkins.war

# Download and install Java 8.  This is pre-OpenJDK.
ADD http://javadl.oracle.com/webapps/download/AutoDL?BundleId=210185 C:/install/jre.exe
RUN powershell start-process -filepath C:\install\jre.exe -passthru -wait -argumentlist "/s,INSTALLDIR=c:\java,/L,install64.log"

# Add LetsEncrypt root/inter certificates into Java cert trust so Jenkins can download extensions reliably
ADD https://letsencrypt.org/certs/isrgrootx1.pem.txt C:/install/letsencryptroot.crt
ADD https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem.txt C:/install/letsencryptauthorityx3a.crt
ADD https://letsencrypt.org/certs/letsencryptauthorityx3.pem.txt C:/install/letsencryptauthorityx3b.crt
ADD https://letsencrypt.org/certs/lets-encrypt-x4-cross-signed.pem.txt C:/install/letsencryptauthorityx4a.crt
ADD https://letsencrypt.org/certs/letsencryptauthorityx4.pem.txt C:/install/letsencryptauthorityx4b.crt
RUN C:\java\bin\keytool -import -alias letsencryptroot -keystore C:\java\lib\security\cacerts -storepass changeit -file C:/install/letsencryptroot.crt -noprompt
RUN C:\java\bin\keytool -import -alias letsencryptauthorityx3a -keystore C:\java\lib\security\cacerts -storepass changeit -file C:/install/letsencryptauthorityx3a.crt -noprompt
RUN C:\java\bin\keytool -import -alias letsencryptauthorityx3b -keystore C:\java\lib\security\cacerts -storepass changeit -file C:/install/letsencryptauthorityx3b.crt -noprompt
RUN C:\java\bin\keytool -import -alias letsencryptauthorityx4a -keystore C:\java\lib\security\cacerts -storepass changeit -file C:/install/letsencryptauthorityx4a.crt -noprompt
RUN C:\java\bin\keytool -import -alias letsencryptauthorityx4b -keystore C:\java\lib\security\cacerts -storepass changeit -file C:/install/letsencryptauthorityx4b.crt -noprompt

###
# start nano container
###

FROM mcr.microsoft.com/windows/nanoserver:${VERSIONNANO}

# Copy Java from builder and configure
COPY --from=builder C:/java C:/java/1.8.0_91
ENV JAVA_HOME c:\\java\\1.8.0_91
ENV JAVA_VERSION 1.8.0_91
ENV CLASSPATH c:\\java\\1.8.0_91\\lib
ENV JAVA_TOOL_OPTIONS -Djava.awt.headless=true
ENV PATH C:\\java\\1.8.0_91\\bin;C:\\Windows\\system32;C:\\Windows;

# Copy and configure Jenkins
COPY --from=builder C:/install/jenkins.war C:/jenkins/jenkins.war
ENV JENKINS_HOME c:\\jenkins_home

# bootstrap jenkins at startup
CMD c:\java\1.8.0_91\bin\java.exe -jar c:\jenkins\jenkins.war

# LABEL and EXPOSE to document runtime settings
VOLUME c:/jenkins_home
EXPOSE 8080/tcp
LABEL maintainer="justin.dynamicd@gmail.com"
LABEL description="Jenkins for Windows"