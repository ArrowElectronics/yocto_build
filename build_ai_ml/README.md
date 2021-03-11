
## Building Yocto BSP for the Arrow AI-ML i.MX8X board
Please follow the instruction in [ .\./README.md](https://github.com/ArrowElectronics/yocto_build/blob/master/README.md) for building ***build_image:1.0***.
***build_image:1.0*** will contain /home/yocto_build/build_ai_ml.sh which will automate the Yocto build process for us. The only prerequisite is to set ***git*** credentials as described in [.\./README.md](https://github.com/ArrowElectronics/yocto_build/blob/master/README.md).
The following command will start the container and the Yocto build process in it. It can be executed from anywhere, the actual working directory will be mounted as /home/yocto_build/work and it will contain all the files created during build.
```
$ docker run -v $PWD:/home/yocto_build/work -it --rm -u yocto_build \
-w /home/yocto_build build_image:1.0 /home/yocto_build/build_ai_ml.sh
```
build_ai_ml.sh first downloads a few necessary files before starting the real Yocto build. The actual Yocto build command is `bitbake imx-image-full`. After Yocto build has been started it can be interrupted any time by pressing Ctrl-C. When the build script exits the Docker container will be deleted but the Yocto build can be resumed by executing the same `$ docker run ...` command from the same folder of the host machine.

<br/>
### Building select packages of the whole BSP
If the whole BSP was successfully built recipes for individual packages can be modified and the packages rebuilt. First one needs to start a terminal into the container:

```
$ sudo docker run -v $PWD:/home/yocto_build/work -it --rm -u yocto_build \
-w /home/yocto_build build_image:1.0 bash
```
Inside the container one needs to execute this for rebuilding *linux-imx* package:
```
$ cd work/I.IMX8X_AI_ML/Kernel_5_4_47/imx-yocto-bsp/
$ EULA=1 DISTRO=fsl-imx-xwayland MACHINE=imx8qxpaiml source imx-setup-release.sh -b build-xwayland-aiml
$ bitbake linux-imx
```
