
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
### Starting *yocto_build* container image
Please download yocto_build.tar.bz2 from the latest release: https://github.com/ArrowElectronics/yocto_build/releases/tag/v1.0

Load it into Docker with:
```
$ bzcat -k yocto_build.tar.bz2 | sudo docker load
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
$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
yocto_build         latest              adc1fc576e37        3 minutes ago      2.04GB
```
Now we can create a container from the yocto_build image with:
```
$ sudo docker run -it yocto_build start_build.sh
```
Docker will start the created container and open a terminal into it. The prompt will look something like:
```
yocto_build@4488f1a7c958:~$ 
```
Inside the container there exist only 2 users: root and yocto_build. The later will be used to build Yocto projects.
The ID of the running container can be checked by executing the following command in another terminal window:
```
$ sudo docker ps -a
```
The response will look like:
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
4488f1a7c958        yocto_build         "start_build.sh"    4 minutes ago       Up 4 minutes                            wonderful_borg
```
One can open another terminal into the same running container by:
```
$ sudo docker exec -it 4488f1a7c958 start_build.sh
```
Note that 4488f1a7c958 is the container ID queried by the previous command.
When the last container terminal window exits the container will stop. One can see the container status change:
```
$ sudo docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
4488f1a7c958        yocto_build         "start_build.sh"    12 minutes ago      Exited (0) 12 seconds ago                       wonderful_borg
```
At this point no new commands can be executed inside the container until it is restarted again by:
```
$ sudo docker start -i 4488f1a7c958
yocto_build@4488f1a7c958:~$
```
<br/>

### Working with containers
Before starting a Yocto project one usually needs to configure **git** by:
```
$ git config --global user.email "you@example.com"
$ git config --global user.name "Your Name"
```
<br/>
When a Yocto project has been built inside the container files can be copied out from the container by:

```
$ sudo docker cp 4488f1a7c958:<src path> <dst path>
```
This command works also with stopped containers.

