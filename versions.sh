#!/bin/bash

version="$(docker run --rm --entrypoint shairport-sync rocka84/shairport-sync-blue:latest -V)"
echo "shairport-sync: $version"
sed 's#\(shairport-sync: \).*$#\1'"${version/-*/}#" -i README.md

version="$(docker run --rm --entrypoint /usr/bin/dbus-daemon rocka84/shairport-sync-blue:latest --version | sed '1!d;s/D-Bus Message Bus Daemon //')"
echo "dbus-daemon: $version"
sed 's#\(dbus-daemon: \).*$#\1'"$version#" -i README.md

version="$(docker run --rm --entrypoint avahi-daemon rocka84/shairport-sync-blue:latest -V | sed 's/avahi-daemon //')"
echo "avahi-daemon: $version"
sed 's#\(avahi-daemon: \).*$#\1'"$version#" -i README.md

version="$(docker run --rm --entrypoint pulseaudio rocka84/shairport-sync-blue:latest --version | sed 's/pulseaudio //')"
echo "pulseaudio: $version"
sed 's#\(pulseaudio: \).*$#\1'"$version#" -i README.md

version="$(docker run --rm --entrypoint /usr/lib/bluetooth/bluetoothd rocka84/shairport-sync-blue:latest -v)"
echo "bluetoothd: $version"
sed 's#\(bluetoothd: \).*$#\1'"$version#" -i README.md

