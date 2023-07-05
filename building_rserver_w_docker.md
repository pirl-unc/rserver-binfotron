# Building and running docker images on the cluster
These instruction will take you through building a docker image to run a custom RServer session and making it available on the cluster. Using this image we can both interactivley write our R scripts in RStudio and run them in pipelines using NextFlow/RAFT.  Since all of the packages and their dependencies are built into the image this makes for highly reproducible analyses.

#### Notes:   
*  A container is a running instance of an image  
*  It's not a bad idea to have your images stored on an SSD if you are using them often  
*  There are ways to build images on the cluster using Docker but they are constantly shifting and will likely soon be removed. So better to learn to build them without relying on using Docker on the cluster.
*  We will build the image using Docker but evenually run it on the cluster using Singularity. Why? The admins are rightly concerned it will give people root access to the cluster. Singularity won't give root access, but Docker is still far superior in terms of:  the number of images available (easy to find a starting point and examples), the clarity of instructions and materials. It's also a pain in that Singularity itself has to run through vagrant (a linux emulator) on a mac.  

#### Some helpful docker commands:
```bash
# lists all local images
docker images

# pull a new image from docker hub
docker pull <your_image_name>:<your_version>   

# lists all containers 
docker ps -a

# remove all shut down containers
docker rm -f $(docker ps -a -q)

# build image from a 'Dockerfile' located in your current directory '.'
docker build -t <your_image_name> .

# bash terminal access to a running container
docker exec -it <container id> /bin/bash

# start container with terminal access (--rm helpful to clean up conatiners when they are done       
docker run --rm -it <your_image> bash
```
  
  
#### Quick start

On your local machine (ie not on the cluster)

```bash
# pull a docker image from DockerHub
docker pull rocker/verse:4.2.1

# run a container with the image you pulled
docker run -it --rm -p 8787:8787 -v /Users/dantebortone/Documents:/home/rstudio -e PASSWORD=12qwaszx rocker/verse:4.2.1
```
  
Direct your browser to:  ` http://127.0.0.1:8787 `  
password: `12qwaszx`   
username: `rstudio`  

This sets up an RStudio session that works but it doesn't have anything specific installed in it. the point of doing all of this work with images is to make sure all the packages are the same so we can easily run each other's code.


#### Customizing the image
Let's make a Dockerfile that starts with the rocker/verse image we had before.  Still on your local machine...  

```bash
echo "FROM rocker/verse:4.2.1" > Dockerfile
echo "RUN apt-get update && apt-get install -y pdftk" >> Dockerfile
echo "RUN apt-get clean" >> Dockerfile
docker build -t test/image:0.0.0 .
docker run -it --rm -p 8787:8787 -v /Users/dantebortone/Documents:/home/rstudio -e PASSWORD=12qwaszx test/image:0.0.0
```

Now you can use pdftk to manipulate and write meta data on pdfs using R.  

```R
system('pdftk -h')
```

Ultimately everything you install will need to be on the Dockerfile using these `RUN` statements.  You are free to use nano, vim, or a text editor to modify it, just remember to rebuild for your changes to become part of the image.  I usally run the container via the terminal and try making my installations from the command line.  

```bash
docker run -it --rm test/image:0.0.0 /bin/bash
root@759ab88b1d2d:/# R -e "install.packages('pzfx')"
root@759ab88b1d2d:/# R -e "packageVersion('pzfx')"
# > [1] ‘0.3.0’
```

If the changes work (ie install without errors or explosions) I add this line to the docker file, making sure to specify the version. Whereeer possible in a Dockerfile you want to install specific versions of packages and tools:  

```Dockerfile  
RUN R -e "install.packages('pzfx', ref = '0.3.0')"
```

After you've installed few packages, rebuild the image and start building from there.

##### Some nuances about the RUN statement
Each `RUN` statement makes a layer of change to the image.  You can do more than one step per `RUN` command:  

```Dockerfile
RUN \  
  apt-get update && \  
  apt-get install -yq \  
    less \  
    nano && \  
  apt-get clean  
```
But if you change or reorder a `RUN` command the image will need to rebuild from that point on. For this reason it's really helpful to add all of our custom packages last.  I make updates to binfotron all the time.  By making it one of the last commands, docker can start with a mostly finished image.  

#### Versioning
Okay now how do we version these and get them on DockerHub so we can use them from anywhere?  

Let's start with our `rsever_binfotron`. I started a 4.2.1 branch but didn't do much. Clone the repo on your local machine:   

``` bash
git clone https://github.com/Benjamin-Vincent-Lab/rserver-binfotron.git
cd rserver-binfotron
git checkout tags/4.2.1.6 -b dsb_dev_4.2.1.21 # checkout the most recent tag and make branch to start dev on the next tag
```

Now make your changes to the Dockerfile. When done build a new image with a new version and test out the image.  

```bash
docker build . -t benjaminvincentlab/rserver-binfotron:4.2.1.21
docker run -it --rm -p 8787:8787 -e PASSWORD=12qwaszx benjaminvincentlab/rserver-binfotron:4.2.1.21
```

**On versioning tags:**  
* the tag format used here: `v.w.x.y`  
* `v.w.x` is the version of R.  
* `y` is the version of this Dockerfile.  
* there's no need to increment the tag version for your local builds, but pushing out to github and dockerhub will need a different version  
* keep the GitHub and DockerHub tags in sync

When you think you are done push the repo to github and the image to dockerhub:  
Use a temp tag if you aren't sure about the changes: temp_4.2.1.21
```bash
my_comment="Updating housekeeping and trying to open up write permission on the entire library path to allow mods in singularity."
git commit -am "$my_comment"
git checkout 4.2.1
git merge dsb_dev_4.2.1.21
git push
git checkout master
git merge dsb_dev_4.2.1.21
git push
git tag -a 4.2.1.21 -m "$my_comment"; git push -u origin --tags
docker push benjaminvincentlab/rserver-binfotron:4.2.1.21
```

Now your changes are on [DockerHub](https://hub.docker.com/repository/docker/benjaminvincentlab/rserver-binfotron) and can be used by everyone everywhere.  Whoa!!!  


#### Running on the cluster

You'll need to get [run_rserver](https://sc.unc.edu/benjamin-vincent-lab/scripts/run_rserver) if you don't already. 

YOU'LL NEED TO DO A NEW PULL FOR THIS. R `4.2.1` required a change to get `run_rserver` to work.

You may need to add these lines to your `~/.bash_profile` if you don't have `~/startup_scripts/bashrc_extensions`:

```
export SINGULARITY_NOHTTPS='yes'
export SINGULARITY_PULLFOLDER=/datastore/nextgenout5/share/labs/Vincent_Lab/singularity
```

Alright let's run our new image on the cluster. Normally you'd use '-H' to specify a directory in which you are working.  Here I just set it to your scratch directory:  

```
run_rserver -i docker://benjaminvincentlab/rserver-binfotron:4.2.1.21 -c 4 -m 8g -H /home/${USER}/scratch
```

It can also be helpful to save the image to your singularity folder so you'll have it saved on the cluster:  

```
sbatch -c 4 --mem 8g -p allnodes --wrap="singularity pull --nohttps docker://benjaminvincentlab/rserver-binfotron:4.2.1.21"
```  
Expect this to take some time and to see a lot of "warn xattr..." This is ok.  You could also do this interactively...

```
srun --pty -c 1 --mem 4g -p allnodes bash
singularity pull --nohttps docker://benjaminvincentlab/rserver-binfotron:4.2.1.20
exit
```

Then you can refer to it directly:  

```bash
run_rserver -i ${SINGULARITY_PULLFOLDER}/rserver-binfotron_4.2.1.21.sif  -c 1 -m 1g -H /home/${USER}/scratch
```

TO ACTUALLY GET THIS WORKING WITH RAFT ...

* note that pulled images end up in
/datastore/nextgenout5/share/labs/VincentLab/tools/singularity folder

.sif file needs to be moved into 
/datastore/nextgenout5/share/labs/VincentLab/tools/raft/imgs folder

so:
Use singularity pull command as above then
Mv from singularity folder to raft/imgs