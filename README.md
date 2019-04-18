# docker-windows-jenkins

Dockerfile for creating Jenkins in Windows container.

## Building Container

Jenkins is delivered as an MSI, which won't install on nano, so this uses servercore.  will experiement later with manual jenkins installation processes to srink this further.

```powershell
docker build . -t dynamicd/jenksinci:v1
```

## Running Jenkins

Must export port 8080 to loginto jenkins.

```powershell
docker run -dit -p 8080:8080 --name jenkins dynamicd/jenksinci:v1
```

## Getting the inital password

can be pulled by typing out the inital password file.

```powershell
docker exec -it jenkins powershell
type "C:\Program Files (x86)\Jenkins\secrets\initialAdminPassword"
exit
```