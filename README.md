# rserver-binfotron

## Introduction
This Dockerfile is used to run binfotron functions.


## DockerHub link:  
https://hub.docker.com/repository/docker/benjaminvincentlab/rserver-binfotron   


## Building locally
```bash
docker build -t benjaminvincentlab/rserver-binfotron:3.6.1.4.13 .
```


## Running locally
```bash
docker run -e PASSWORD=12qwaszx --rm -p 8787:8787 -v ~/Desktop:/home/rstudio benjaminvincentlab/rserver-binfotron:3.6.1.4.13 8787
```
Then direct browser to localhost:8787.  


## Tagging
v.w.x.y.z  
vwx is the version of R.  
y is the version of the rserver it uses.  
z is the version of this Dockerfile.  
```bash  
cd /home/dbortone/docker/rserver_binfotron
my_comment="Updated added packages to run mtb elastic net."
git add .
git commit -am "$my_comment"; git push origin master
git tag -a 3.6.1.4.14 -m "$my_comment"; git push -u origin --tags
```
