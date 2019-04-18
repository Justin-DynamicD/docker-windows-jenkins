# docker-windows-jenkins

Dockerfile for creating Jenkins in Windows container.

## Building Container

Jenkins is running from a java war on servercore.  will experiement later with nano by installing java.

```powershell
docker build . -t dynamicd/jenksinci:v1
```

## Running Jenkins

Jenkins administration occurs on port 8080.  In addition, all persistant files are stored on `c:\jenkins_home` on the container.  Therefore, the simplest way to launc hthe container is to port map and volume map as below:

```powershell
docker run -d -p 8080:8080 -v C:/jenkins_home:C:/jenkins_home --name jenkins dynamicd/jenksinci:v1
```

## Getting the inital password

can be pulled by typing out the inital password file.

```powershell
type "c:\jenkins_home\secrets\initialAdminPassword"
```