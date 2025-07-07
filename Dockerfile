# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BOINC_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

#Add needed nvidia environment variables for https://github.com/NVIDIA/nvidia-docker
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

# global environment settings
ENV DEBIAN_FRONTEND="noninteractive" \
    CUSTOM_PORT="8080" \
    CUSTOM_HTTPS_PORT="8181" \
    TITLE=BOINC

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/boinc-icon.png && \
  echo "**** install packages ****" && \
  curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xB991272AA858DEF3B0FF0C839FB27DC84490895D" | gpg --dearmor | tee /usr/share/keyrings/boinc.gpg >/dev/null && \
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/boinc.gpg] http://ppa.launchpad.net/costamagnagianfranco/boinc/ubuntu noble main" > /etc/apt/sources.list.d/boinc.list && \
  echo "deb-src [arch=amd64 signed-by=/usr/share/keyrings/boinc.gpg] http://ppa.launchpad.net/costamagnagianfranco/boinc/ubuntu noble main" >> /etc/apt/sources.list.d/boinc.list && \
  if [ -z ${BOINC_VERSION+x} ]; then \
    BOINC="boinc-client"; \
  else \
    BOINC="boinc-client=${BOINC_VERSION}"; \
  fi && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    ${BOINC} \
    at-spi2-core \
    boinc-client-opencl \
    boinc-manager \
    bzip2 \
    xz-utils && \
  ln -s libOpenCL.so.1 /usr/lib/x86_64-linux-gnu/libOpenCL.so && \
  mkdir -p /etc/OpenCL/vendors && \
  echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY root/ /
