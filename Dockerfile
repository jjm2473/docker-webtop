FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine318

# set version label
ARG BUILD_DATE
ARG VERSION
ARG XFCE_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"


RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    faenza-icon-theme \
    faenza-icon-theme-xfce4-appfinder \
    faenza-icon-theme-xfce4-panel \
    mousepad \
    ristretto \
    thunar \
    util-linux-misc \
    xfce4 \
    xfce4-terminal && \
  echo "**** cleanup ****" && \
  rm -f \
    /etc/xdg/autostart/xfce4-power-manager.desktop \
    /etc/xdg/autostart/xscreensaver.desktop \
    /usr/share/xfce4/panel/plugins/power-manager-plugin.desktop && \
  rm -rf \
    /config/.cache \
    /tmp/*

RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    firefox && \
  echo "**** default firefox settings ****" && \
  FIREFOX_SETTING="/usr/lib/firefox/browser/defaults/preferences/firefox.js" && \
  echo 'pref("datareporting.policy.firstRunURL", "");' > ${FIREFOX_SETTING} && \
  echo 'pref("datareporting.policy.dataSubmissionEnabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("datareporting.healthreport.service.enabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("datareporting.healthreport.uploadEnabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("trailhead.firstrun.branches", "nofirstrun-empty");' >> ${FIREFOX_SETTING} && \
  echo 'pref("browser.aboutwelcome.enabled", false);' >> ${FIREFOX_SETTING} && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

RUN \
  apk add --no-cache \
    font-mononoki font-terminus font-inconsolata font-dejavu font-noto font-noto-cjk font-awesome font-noto-extra font-noto-emoji \
    musl-locales lang firefox-intl && \
  rm -rf \
    /config/.cache \
    /tmp/*

RUN \
  mkdir -p /usr/lib/firefox/distribution/extensions && \
  curl -o /usr/lib/firefox/distribution/extensions/'langpack-zh-CN@firefox.mozilla.org.xpi' \
    -L https://releases.mozilla.org/pub/firefox/releases/$(HOME=/dev/null firefox --version | grep -Eo '[0-9.]+$')/win64/xpi/zh-CN.xpi

# add local files
COPY /root /

RUN \
  echo '/etc/s6-overlay/s6-rc.d/init-adduser/volume' >> /etc/s6-overlay/s6-rc.d/init-adduser/run

# ports and volumes
EXPOSE 3000

VOLUME /config
