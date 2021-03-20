
## Docker image for building Yocto projects
***yocto_build*** is a pre-installed Docker container image which contains all the necessary libraries and tools for building a Yocto project. It's based on Ubuntu Minimal 20.04 LTS

### Setting up Docker on Ubuntu
Steps for installing Docker on Ubuntu 18.04 or later:
```
$ sudo apt-get update
$ sudo apt-get install docker.io
```

Verify installation by: \
`$ sudo systemctl status docker`

This command should display something like:

> ● docker.service - Docker Application Container Engine
> 
> &nbsp;&nbsp;Loaded: loaded (/lib/systemd/system/docker.service; disabled; vendor preset: enabled)
> 
> &nbsp;&nbsp;Active: **active (running)** since since Mon 2021-03-08 15:36:51 CET; 1s ago
> 
> &nbsp;&nbsp;&nbsp;&nbsp;Docs: https://docs.docker.com
> 
> &nbsp;&nbsp;&nbsp;&nbsp;Main PID: 30127 (dockerd)
> 
> &nbsp;&nbsp;Tasks: 14
> 
> &nbsp;&nbsp;CGroup: /system.slice/docker.service
> 
> &nbsp;&nbsp;&nbsp;&nbsp;└─30127 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

In case Docker service is not running please start it by:

`$ sudo systemctl start docker`

<br/>

### Accessing Docker as a normal user
Docker daemon is usually not accessible by non-root users. Because of this "docker" commands must always be executed as root, eg. with "sudo ...". For easing typing one can add a normal user to the "docker" group to be able to access the docker daemon without "sudo":
```
$ sudo usermod -aG docker $(id -un)
```
<br/>

### Prerequisites for working with Git and Yocto
Yocto projects usually require that the user sets his/her name and e-mail address in git like this:
```
$ git config --global user.name "Your Name"
$ git config --global user.email "you@example.com"
```
Before going on with this how-to please set your credentials in git like above. In the container we're about to create we will use these credentials.
<br/>

### Starting *yocto_build* container image
Please download yocto_build.tar.bz2 from the latest release: https://github.com/ArrowElectronics/yocto_build/releases/tag/v1.1

Load it into Docker with:
```
$ bzcat yocto_build.tar.bz2 | docker load
```
During the load process Docker will display something like this:
```
aeb3f02e9374: Loading layer  75.27MB/75.27MB
db978cae6a05: Loading layer  15.36kB/15.36kB
c20d459170d8: Loading layer  3.072kB/3.072kB
1a9ac7abb26e: Loading layer  2.031GB/2.031GB
010db525e7a9: Loading layer  12.11MB/12.11MB
Loaded image: yocto_build:latest
```
The loaded image can be seen by executing:
```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
yocto_build         latest              e33a051b537e        3 minutes ago      2.04GB
```
<br/>
We will share a local folder with the container and the user inside the container will need to have the same UID and GID to have the same permissions on the shared folder. So let's customize the base image and create a new user with the same UID and GID as the active user. The following command needs to be executed in the folder where 'Dockerfile' resides:

```
$ docker build -t build_image:1.0 --build-arg USERNAME=yocto_build \
--build-arg PUID=$(id -u) --build-arg PGID=$(id -g) \
--build-arg GIT_USEREMAIL=$(git config --get user.email) \
--build-arg GIT_USERNAME="$(git config --get user.name)" .
```
USERNAME is the name of the user we're about to create inside the container. Right now it's set to "yocto_build" but it can be changed.
Name and tag of the customized image will be "build_image:1.0"
We can see that a new image has been successfully created by:
```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
build_image         1.0                 66a3922d72f4        About a minute ago   2.07GB
yocto_build         latest              e33a051b537e        39 hours ago         2.07GB
```

<br/>
Now let's start the container from the freshly created image:

```
$ docker run -v $PWD:/home/yocto_build/work -it --rm -u yocto_build \
-w /home/yocto_build build_image:1.0 bash
```
This command shares the current folder with the container and mounts it at "/home/yocto_build/work". Care must be taken that if we change USERNAME at the creation of the customized image the mountpoint will need to be adjusted.
Argument "--rm" instructs Docker to delete the container when the last command in the container exited. The container itself will be deleted but the shared folder not. This means that a user should build Yocto projects inside the shared folder in order to preserve the build artifacts when the container is deleted.
The last argument is "bash", this is the command to be executed inside the container.
<br/>
After having executed the previous command we will receive a prompt like this:
```
yocto_build@917c17a4d35e:~$
```
<br/>
The ID of the running container is shown in the prompt or can be checked by executing the following command in another terminal window on the host:

```
$ docker ps -a
```
The response will look like:
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
917c17a4d35e        build_image:1.0     "start_build.sh"    8 seconds ago       Up 6 seconds                            mystifying_thompson
```
One can open another terminal into the same running container by:
```
$ docker exec -it 917c17a4d35e start_build.sh
```
Note that 917c17a4d35e is the container ID queried by the previous command.
When the last container terminal window exits the container will stop and be automatically deleted.

<br/>

### [Building Yocto BSP for the Arrow AI-ML i.MX8X board](https://github.com/ArrowElectronics/yocto_build/tree/master/build_ai_ml)


### [Building Yocto BSP for the Arrow Thor96 i.MX8 board](https://github.com/ArrowElectronics/yocto_build/tree/master/build_thor96)


### [Building Yocto BSP for the Arrow Avenger96 board](https://github.com/ArrowElectronics/yocto_build/tree/master/build_av96)


### [Building Yocto BSP for the Arrow Shield96 board](https://github.com/ArrowElectronics/yocto_build/tree/master/build_sd96)

<br/>

### Working with containers
In [build_ai_ml folder](https://github.com/ArrowElectronics/yocto_build/tree/master/build_ai_ml) we give a standalone and stateless example for building a BSP for the Arrow AI-ML i.MX8X board. If one plans to work with other Yocto projects some more measures must be taken.
Before starting a Yocto project one usually needs to configure **git** by:
```
yocto_build@0d9edc9cfd7f:~$ git config --global user.email "you@example.com"
yocto_build@0d9edc9cfd7f:~$ git config --global user.name "Your Name"
```
When a container gets deleted only contents of shared folders will be preserved, all other modified files will be deleted. This means that git global settings and bash history will also be lost. So every time a new container is started git settings need to be given again.
As a workaround for this one can tell Docker not to automatically delete the container after it has exited by omitting the --rm flag during startup:
```
docker run -v $PWD:/home/yocto_build/work -it build_image:1.0 start_build.sh
```
Upon exit the container will remain in a stopped state:
```
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
0d9edc9cfd7f        build_image:1.0     "start_build.sh"    23 seconds ago      Exited (0) 11 seconds ago                       happy_pascal

```
This stopped container can be restarted later by:
```
$ docker start -i 0d9edc9cfd7f
```
The shared folder doesn't need to be specified, it will be automatically mounted at the old location. git global settings, bash history and other locally modified files will be preserved after any subsequent stop and restart until the container is explicitly deleted by:
```
docker rm 0d9edc9cfd7f
```

<br/>

### Moving Docker data folder to another volume
Docker data folder usually resides at /var/lib/docker. For moving it elsewhere one needs to first stop the running docker daemon:
```
$ sudo systemctl stop docker
```
Then the file **/etc/docker/daemon.json** must be created with the following content:
```
{ 
   "data-root": "/path/to/your/docker" 
}
```
Old Docker data folder must be copied (or moved) to the new location: /path/to/your/docker
After this Docker can be started again:
```
$ sudo systemctl start docker
```
