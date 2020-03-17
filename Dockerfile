FROM lsiobase/guacgui

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BOINC_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

#Add needed nvidia environment variables for https://github.com/NVIDIA/nvidia-docker
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

# global environment settings
ENV DEBIAN_FRONTEND="noninteractive"
ENV APP_NAME="Boinc"

RUN \
 echo "**** install packages ****" && \
 if [ -z ${BOINC_VERSION+x} ]; then \
	BOINC="boinc-client"; \
 else \
	BOINC="boinc-client=${BOINC_VERSION}"; \
 fi && \
 apt-get update && \
 apt-get install -y \
	${BOINC} \
	beignet-opencl-icd \
	boinc-client-opencl \
	boinc-manager \
	i965-va-driver \
	mesa-va-drivers \
	python-xdg && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /
