FROM arm64v8/alpine:latest

ENV PULSE_SERVER=127.0.0.1
ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket

RUN apk update && apk upgrade && \
    apk add --no-cache \
    pulseaudio \
    pulseaudio-utils \
    pulseaudio-alsa \
    bluez \
    bluez-alsa \
    bluez-deprecated \
    dbus \
    alsa-utils \
    udev \
    eudev \
    shairport-sync \
    libdaemon \
    shadow \
    avahi \
    avahi-tools \
    expect && \
    \
    addgroup -S bluetooth && \
    \
    addgroup -S shairport-sync && \
    adduser -D -S shairport-sync -G shairport-sync && \
    addgroup shairport-sync audio && \
    addgroup shairport-sync bluetooth && \
    \
    adduser -S pulseaudio && \
    adduser pulseaudio audio && \
    adduser pulseaudio bluetooth && \
    \
    mkdir -p /var/run/dbus && \
    chown messagebus:messagebus /var/run/dbus && \
    \
    echo "load-module module-bluetooth-policy" >> /etc/pulse/default.pa && \
    echo "load-module module-bluetooth-discover" >> /etc/pulse/default.pa && \
    echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1" >> /etc/pulse/default.pa && \
    \
    rm -rf /var/cache/apk/* && \
    rm -rfv /etc/avahi/services/*.service

COPY run.sh bluetooth-pair.exp /usr/local/bin/
RUN chmod +x /usr/local/bin/run.sh /usr/local/bin/bluetooth-pair.exp

ENTRYPOINT ["/usr/local/bin/run.sh"]
