# docker-windows-jenkins

Dockerfile for creating Jenkins in Windows container.

## Building Container

The build is "wrapped" in powershell to pre-download binaries.  This is being done as commands are limited in Nano, so pre-work is done outside the container.

```powershell
.\build.ps1
```

## Running Jenkins

```powershell
docker run -dit -p 8080:8080 --name jenkins dynamicd/jenksinci:v1
```

## Getting the inital password:

can be pulled by typing out the inital password file.

```powershell
docker exec -it jenkins powershell
type "C:\Program Files (x86)\Jenkins\secrets\initialAdminPassword"
exit
```