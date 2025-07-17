# shairport-sync-blue

Docker container combining bluetooth capabilities with shaireport-sync.

## Features

* shairport-sync: 4.3.7
* dbus-daemon: 1.16.2
* avahi-daemon: 0.8
* pulseaudio: 17.0
* bluetoothd: 5.82

## Usage

See [docker-compose.yaml.sample](docker-compose.yaml.sample)

## Environment

* BLUETOOTH_SPEAKER: set to bluetooth MAC address to connect and use a bluetooth speaker
* ALSA_DEVICE: set to a alsa device name to use in alsa mode

If BLUETOOTH_SPEAKER is set, ALSA_DEVICE is ignored.
If neither is set shairport-sync will fallback to its configuration file.

