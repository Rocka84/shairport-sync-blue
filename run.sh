#!/bin/sh

echo "Starting D-Bus..."
rm -f /run/dbus/system_bus_socket /run/dbus/dbus.pid
/usr/bin/dbus-daemon --system --nofork &

while [ ! -S /run/dbus/system_bus_socket ]; do
    sleep 0.5
done

echo "Starting Avahi-Daemon..."
rm -f /run/avahi-daemon/pid
avahi-daemon -D

while [ ! -f /var/run/avahi-daemon/pid ]; do
    sleep 0.5
done

params=""

if [ -n "$BLUETOOTH_SPEAKER" ]; then
    echo "Starting Bluetooth daemon..."
    /usr/lib/bluetooth/bluetoothd --debug &
    sleep 3

    echo "Starting PulseAudio..."
    rm -rf /run/user/$(id -u pulseaudio)/pulse /var/run/pulse/*
    su -s /bin/sh pulseaudio -c '/usr/bin/pulseaudio --exit-idle-time=-1 --daemonize=yes --disallow-exit=yes --log-target=stderr' &
    sleep 5

    echo "Connecting Bluetooth speaker..."
    if ! bluetoothctl devices Paired | grep -q "$BLUETOOTH_SPEAKER"; then
        echo "Speaker $BLUETOOTH_SPEAKER not paired. Attempting to pair."
        if /usr/local/bin/bluetooth-pair.exp "$BLUETOOTH_SPEAKER"; then
            echo "Pairing finished successfully."
        else
            echo "Pairing failed. Please try manually."
        fi
    fi

    if ! bluetoothctl connect "$BLUETOOTH_SPEAKER"; then
        echo "Failed to connect to $BLUETOOTH_SPEAKER."
        echo "Exiting..."
        exit 0
    fi

    echo "Successfully connected to $BLUETOOTH_SPEAKER."
    params="-o pa"
    sleep 3

elif [ -n "$ALSA_DEVICE" ]; then
    params="-o alsa -- -d $ALSA_DEVICE"
fi

echo "Starting Shairport-Sync..."
/usr/bin/shairport-sync $params "$@"

exit $?

