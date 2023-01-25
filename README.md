# rserver-binfotron

## Introduction
This Dockerfile is used to run binfotron functions.


## DockerHub link:  
https://hub.docker.com/repository/docker/benjaminvincentlab/rserver-binfotron   


## Building locally
```bash
docker build -t benjaminvincentlab/rserver-binfotron:4.2.1.17 .
```


## Running locally
```bash
docker run -e PASSWORD=12qwaszx --rm -p 8787:8787 -v ~/Desktop:/home/rstudio benjaminvincentlab/rserver-binfotron:4.2.1.17
```
Then direct browser to localhost:8787.  


## Running on the bioinf cluster with singularity

Either make sure you do all of the following:
* Use the --pid flag. This makes sure the job kills all of the rserver's processes when the job ends. If you don't use this flag, your processess will be left running on the cluster and the next person who uses that node won't be able to change from your bindings.
* Use an open port
* Use a unique '--server-data-dir'
```
data_dir=$(mktemp -d -t rserver-XXXXXXXX)}
```
* Make a '--database-config-file' 
```
  database_config_path=${data_dir}/database.conf
  echo "provider=sqlite" > $database_config_path
  echo "directory=${data_dir}" >> $database_config_path
  echo "provider=postgresql" >> $database_config_path
  echo "host=localhost" >> $database_config_path
  echo "database=rstudio" >> $database_config_path
  echo "port=5432" >> $database_config_path
  echo "username=postgres" >> $database_config_path
  echo "password=postgres" >> $database_config_path
  echo "connection-timeout-seconds=10" >> $database_config_path
  echo "connection-uri=postgresql://postgres@localhost:5432/rstudio?sslmode=allow&options=-csearch_path=public" >> $database_config_path
```
* Then run
```
singularity exec --pid --nohttps --home $rstudio_home_dir --bind $bindings $image_path \
      rserver --www-port $source_command --server-data-dir $data_dir --database-config-file $database_config_path"
```

*- or -*

Use [run_rserver](https://sc.unc.edu/benjamin-vincent-lab/scripts/run_rserver) to run it.  It will do all of the above steps for you.


## Decoding the tag structure
v.w.x.y 
vwx is the version of R.  
y is the version of this Dockerfile.  


## Making commits, tags:
```bash  
cd /home/dbortone/docker/rserver_binfotron
my_comment="Changed permission of library files and folders to allow modification on Singularity-run containers."
git add .
git commit -am "$my_comment"; git push
git tag -a 4.2.1.17 -m "$my_comment"; git push -u origin --tags
```
You should merge with that R version's branch and, if it's the most recent version of R, merge with master.


## Manual push
```bash
my_version=4.2.1.17
docker build . -t benjaminvincentlab/rserver-binfotron:$my_version
docker push benjaminvincentlab/rserver-binfotron:$my_version
```

## See more detailed instructions on building_rserver_w_docker.md