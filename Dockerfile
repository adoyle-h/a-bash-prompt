FROM bash:$VERSION

LABEL maintainer="ADoyle <adoyle.h@gmail.com>"
WORKDIR /bash

RUN \
    cp /etc/apk/repositories /etc/apk/repositories.bak && \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

COPY a.prompt.bash colors.bash ./
RUN echo 'source /bash/a.prompt.bash' >> ~/.bashrc
