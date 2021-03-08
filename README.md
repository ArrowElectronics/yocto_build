
## Docker image for building Yocto projects
***yocto_build*** is a pre-installed Docker container image which contains all the necessary libraries and tools for building a Yocto project. It's based on Ubuntu Minimal 20.04 LTS

### Setting up Docker on Ubuntu
Steps for installing Docker on Ubuntu 18.04 or later:
```
$ sudo apt-get update
$ sudo apt-get install docker.io
```

Verify installation by:
`$ sudo systemctl status docker`

This command should display something like:

> ● docker.service - Docker Application Container Engine
> &nbsp;&nbsp;Loaded: loaded (/lib/systemd/system/docker.service; disabled; vendor preset: enabled)
> &nbsp;&nbsp;Active: **active (running)** since since Mon 2021-03-08 15:36:51 CET; 1s ago
> &nbsp;&nbsp;&nbsp;&nbsp;Docs: https://docs.docker.com
> &nbsp;&nbsp;&nbsp;&nbsp;Main PID: 30127 (dockerd)
> &nbsp;&nbsp;Tasks: 14
> &nbsp;&nbsp;CGroup: /system.slice/docker.service
> &nbsp;&nbsp;&nbsp;&nbsp;└─30127 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

In case Docker service is not running please start it by:
`$ sudo systemctl start docker`

### Starting *yocto_build* container image
Please download yocto_build.tar.bz2 from the latest release:



