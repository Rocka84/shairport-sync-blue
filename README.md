# shairport-sync-blue

Docker container combining bluetooth capabilities with shaireport-sync.

## Features

* shairport-sync: 4.3.7
* pulseaudio: 17.0

## Usage

See [docker-compose.yaml.sample](docker-compose.yaml.sample)

## Environment

* BLUETOOTH_SPEAKER: set to bluetooth MAC address to start pulseaudio and connect a bluetooth speaker
* ALSA_DEVICE: set to a device name to use in alsa mode

If BLUETOOTH_SPEAKER is set, ALSA_DEVICE is ignored.
If neither is set shairport-sync will fallback to its configuration file.

