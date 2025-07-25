#!/bin/sh

params=""

if [ -n "$BLUETOOTH_SPEAKER" ]; then
    echo "Starting PulseAudio..."
    rm -rf /run/user/$(id -u pulseaudio)/pulse /var/run/pulse/* /tmp/pulse-*
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

