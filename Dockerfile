FROM lsiobase/guacgui

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BOINC_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

ENV APPNAME="boinc"

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
	boinc-manager && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /
