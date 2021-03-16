FROM yocto_build:latest

ARG USERNAME=yocto_build
ARG PUID=1000
ARG PGID=1000

ARG GIT_USEREMAIL="you@example.com"
ARG GIT_USERNAME="Your Name"

RUN userdel -r yocto_build
RUN groupadd -g ${PGID} ${USERNAME} \
    && adduser --uid ${PUID} --gid ${PGID} --disabled-password --gecos "" ${USERNAME}
RUN echo "#!/bin/bash" > /bin/start_build.sh
RUN echo su - ${USERNAME} >> /bin/start_build.sh
RUN chmod a+x /bin/start_build.sh
RUN usermod -aG sudo ${USERNAME}
RUN passwd -d ${USERNAME}

ENV GIT_USEREMAIL ${GIT_USEREMAIL}
ENV GIT_USERNAME ${GIT_USERNAME}
COPY ./build_ai_ml/build_ai_ml.sh /home/${USERNAME}/
COPY ./build_thor96/build_thor96.sh /home/${USERNAME}/
