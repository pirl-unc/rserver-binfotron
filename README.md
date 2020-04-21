# rserver-binfotron

## Introduction
This Dockerfile is used to run binfotron functions.


## DockerHub link:  
https://hub.docker.com/repository/docker/benjaminvincentlab/rserver-binfotron   


## What's with the rserver_handler.sh
In our cluster environment, the rstudio server often doesn't terminate cleanly.  The leftover processes affect the binding of volumes for subsequent RServer containers. Additionally processes created by mclapply do not end with the RServer termination.  rserver_handler starts a monitor that periodically checks to see if the RServer is done running.  If so, it finds all of the processes in the RServer session id (sid) and sends them a sigterm. Then it terminates itself.


## Building locally
```bash
docker build -t benjaminvincentlab/rserver-binfotron :3.6.1.4.1 .
```


## Running locally
```bash
docker run -e PASSWORD=12qwaszx --rm -p 8787:8787 -v ~/Desktop:/home/rstudio   benjaminvincentlab/rserver-binfotron :3.6.1.4.1 8787
```
Then direct browser to localhost:8787.  

## Tagging
v.w.x.y.z  
vwx is the version of R.  
w is the version of the rserver it uses.  
z is the version of this Dockerfile.  
```bash  
git tag -a 3.6.1.4.2 -m "Upadted readme"; git push -u origin --tags  
```
