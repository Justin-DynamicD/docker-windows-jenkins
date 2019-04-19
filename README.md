# docker-windows-jenkins

Dockerfile for creating Jenkins in Windows container.

## Building Container

Jenkins is running from a java war on servercore.  will experiement later with nano by installing java.

```powershell
docker build . -t dynamicd/jenksinci:v1
```

## Running Jenkins

Jenkins administration occurs on port 8080.  In addition, all persistant files are stored on `c:\jenkins_home` on the container.  Therefore, the simplest way to launch the container is to port map and volume map as below:

```powershell
docker run -d -p 8080:8080 -v C:/jenkins_home:C:/jenkins_home --name jenkins dynamicd/jenksinci:v1
```

## Getting the inital password

can be pulled by typing out the inital password file `c:\jenkins_home\secrets\initialAdminPassword`.

## Why a war file instead of an msi installer

Why is a war used instead of using the jenkins.msi available for download?  A few reasons:

* war packages are ready to run, meaning no installation/unzipping is required and thus it can easily work in server nano or core without modification.
* running the war package with "CMD" is in-line with docker expected behavior (container failure is now tied to the process ending).  The installer configures a service, which is harder for orchestration to monitor, log, etc.

## Core vs Nano

Long term the desire is to use a nano server becuase of the reduced footprint (~550mb vs 4.8GB).  However, installing java onto nano has proven tricky.  Current attempts result in only partial functionality.  Will dig deeper as time permits.