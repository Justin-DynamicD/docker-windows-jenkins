# docker-windows-jenkins

Dockerfile for creating Jenkins in Windows container.

## Building Container

Jenkins is running from a java war on servercore.  will experiement later with nano by installing java.

```powershell
docker build . -t dynamicd/jenksinci:v1
```

## Running Jenkins

Must expose port 8080 to be able to access jenkins.

```powershell
docker run -d -p 8080:8080 --name jenkins dynamicd/jenksinci:v1
```

## Getting the inital password

can be pulled by typing out the inital password file.

```powershell
docker exec -it jenkins powershell
type "c:\jenkins\secrets\initialAdminPassword"
exit
```