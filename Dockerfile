FROM ghcr.io/linuxserver/baseimage-rdesktop-web:jammy

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BOINC_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

#Add needed nvidia environment variables for https://github.com/NVIDIA/nvidia-docker
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

# global environment settings
ENV DEBIAN_FRONTEND="noninteractive" CUSTOM_PORT="8080"

RUN \
  echo "**** install packages ****" && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:11371 --recv-keys E36CE452F7C2AE96FB1354901BCB19E03C2A1859 && \
  echo "deb http://ppa.launchpad.net/costamagnagianfranco/boinc/ubuntu jammy main" >> /etc/apt/sources.list.d/boinc.list && \
  echo "deb-src http://ppa.launchpad.net/costamagnagianfranco/boinc/ubuntu jammy main" >> /etc/apt/sources.list.d/boinc.list && \
  if [ -z ${BOINC_VERSION+x} ]; then \
    BOINC="boinc-client"; \
  else \
    BOINC="boinc-client=${BOINC_VERSION}"; \
  fi && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    ${BOINC} \
    boinc-client-opencl \
    boinc-manager && \
  ln -s libOpenCL.so.1 /usr/lib/x86_64-linux-gnu/libOpenCL.so && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY root/ /
