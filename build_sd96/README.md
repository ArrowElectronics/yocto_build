
## Building Yocto BSP for the Arrow Shield96 board
Please follow the instruction in [ .\./README.md](https://github.com/ArrowElectronics/yocto_build/blob/master/README.md) for building ***build_image:1.0***. *build_image:1.0* will contain */home/yocto_build/build_av96.sh* which will automate the Yocto build process for us. The only prerequisite is to set ***git*** credentials as described in [.\./README.md](https://github.com/ArrowElectronics/yocto_build/blob/master/README.md).
The following command will start the container and the Yocto build process in it. It can be executed from anywhere, the actual working directory will be mounted as */home/yocto_build/work* and it will contain all the files created during build.
```
$ docker run -v $PWD:/home/yocto_build/work -it --rm -u yocto_build \
-w /home/yocto_build build_image:1.0 /home/yocto_build/build_av96.sh
```
build_av96.sh first downloads a few necessary files before starting the real Yocto build. The actual Yocto build command is \
`bitbake hostapt-image`. After Yocto build has been started it can be interrupted any time by pressing Ctrl-C. When the build script exits the Docker container will be deleted but the Yocto build can be resumed by executing the same `$ docker run ...` command from the same folder of the host machine.

<br/>

### Building select packages of the whole BSP
If the whole BSP was successfully built recipes for individual packages can be modified and the packages rebuilt. First one needs to start a terminal into the container:

```
$ docker run -v $PWD:/home/yocto_build/work -it --rm -u yocto_build \
-w /home/yocto_build build_image:1.0 bash
```
Inside the container one needs to execute this for rebuilding *linux-at91* package:
```
$ cd work/build-sd96/poky/
$ export TEMPLATECONF=${TEMPLATECONF:-../meta-atmel/conf}
$ export MACHINE=sama5d27-sd96
$ source oe-init-build-env build-sd96
$ bitbake linux-at91
```
