# docker-windows-jenkins

[![Build Status](https://dev.azure.com/Justin-DynamicD/GitHubPipelines/_apis/build/status/Justin-DynamicD.docker-windows-jenkins?branchName=master)](https://dev.azure.com/Justin-DynamicD/GitHubPipelines/_build/latest?definitionId=1&branchName=master)

Dockerfile for creating Jenkins in Windows container.

## Building Container

Jenkins is running from a java war on nanoserver.

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
* running the war package with "CMD" is in-line with docker expected behavior (container failure is now tied to the process ending, and `container logs` returns expected output), whereas the installer sets up a service which doesn't leverage docker structure.

## Core Builder to Nano

The desire is to use a nano server becuase of the reduced footprint (~550mb vs 4.8GB).  However, most EXE and MSI installers do not function correctly in Nano.  Therefore, a servercore container is first spun up to perform the java installation and certificate store configuration, then then the final java directory is copied to the target nanoserver.

The Java version in use is JDK 8, as this worked reliably.  OpenJDK was not forked until JDK 9 which is unsupported, and OpenJDK 11.0.2 had stability issues when testing.
