FROM yocto_build:latest
ARG USERNAME=yocto_build
ARG PUID=1000
ARG PGID=1000
RUN userdel -r yocto_build
RUN groupadd -g ${PGID} ${USERNAME} \
    && adduser --uid ${PUID} --gid ${PGID} --disabled-password --gecos "" ${USERNAME}
RUN echo "#!/bin/bash" > /bin/start_build.sh
RUN echo su - ${USERNAME} >> /bin/start_build.sh
RUN chmod a+x /bin/start_build.sh
RUN usermod -aG sudo ${USERNAME}
RUN passwd -d ${USERNAME}
