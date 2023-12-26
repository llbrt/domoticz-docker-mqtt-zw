# Docker Domoticz Z-Wave + Zigbee with MQTT

This project can generate a docker compose environment to have [Domoticz](https://github.com/domoticz/domoticz) running
with [Z-Wave JS UI](https://github.com/zwave-js/zwave-js-ui), [Zigbee2MQTT](https://www.zigbee2mqtt.io/)
and [Mosquitto](https://github.com/eclipse/mosquitto).

[MQTT Explorer](https://github.com/thomasnordquist/MQTT-Explorer) have been added for debug/supervision purposes.

If you are using (or plan to use) Domoticz with MQTT for other purposes, it should be easy to replace
the `Z-Wave JS UI` and/or `Zigbee2MQTT` docker configuration with some other Docker service (or remove it if you just need MQTT).

This project have been tested on Linux. It should work on a Mac and may work under Windows if `MinGW` or `WSL2` is installed.

Some knowledge of Domoticz, Docker, Z-Wave and Zigbee is expected, this README doesn't explain how to install, setup or use theses software and hardware.

## Generation

Copy the file `configuration-sample.cfg` as `configuration.cfg`:

```
cp configuration-sample.cfg configuration.cfg
```

With your favorite editor, modify the values in `configuration.cfg` (the strings after the character `=`).

Run the script `generate.sh`:

```
./generate.sh
```

A folder `_domoticz` is created: it contains the docker compose configuration for the 4 services.
You may move it into a better location on your host.

### Adding devices to Domoticz

You may add access to some devices to `Domoticz`. Edit the file `_domoticz/docker-compose.yml`
and, for the service `domoticz`, add a section `devices` and one device per line.

For example:
```
    devices:
      - '/dev/ttyUSB1:/dev/teleinfo'
      - '/dev/serial/by-id/usb-xyz:/dev/other'
```

Warning:
- respect the indentation; you may copy the `devices` lines of the service `zwave-js-ui` or `zigbee2mqtt`
as an example
- the device by id `/dev/serial/by-id/usb-` should be preferred
- using udev rules to create device aliases may also be helpful

### Note on Docker

The first launch may take some time: docker will have to download the images of the
various services.

When new versions of the docker images are released, you'll have to update
them manually. See the documentation of [docker pull](https://docs.docker.com/engine/reference/commandline/pull/).

## Setup an existing Domoticz installation

Make sure that your local servers are stopped: `Domoticz`, `Mosquitto`,
`Z-Wave JS UI` and/or `Zigbee2MQTT`.

Copy your existing database (file `domoticz.db`), yours scripts and all the files you need
in the folder `_domoticz/domoticz`.
This folder corresponds to the folder `/opt/domoticz/userdata` in the `Domoticz` container.
Look in [the documentation](https://www.domoticz.com/wiki/Docker) for more details.

If you have an existing `Z-Wave JS UI` setup, copy the files (`settings.json`, `user.json`, etc) in
the folder `_domoticz/zwave`.

If you have an existing `Zigbee2MQTT` setup, copy the files (`configuration.yaml`, `database.db`, etc) in
the folder `_domoticz/zigbee2mqtt`.

If you have an existing `Mosquitto` configuration, copy the files `mosquitto.conf` and `password.txt`
in the folder `_domoticz/mosquitto/config`.

Go into the folder `_domoticz` and launch the docker composition in foreground
for a simpler access to the logs; it will block your terminal.

```
docker compose up
```

or, for older Docker compose versions:

```
docker-compose up
```

In `Domoticz`, if you have an existing MQTT configuration, you will have to
replace the name and/or the port of the `Mosquitto` server.
In the MQTT related hardware configurations, set:
- `Remote Address`: mosquitto
- `Port`: 1883

Once all is tested (Z-Wave, Zigbee, scripts, etc):
- stop the docker composition: in another terminal, go in the folder
`_domoticz` and run `docker compose down` (or `docker-compose down`)
- disable your previous servers so they won't start after a reboot
- Launch the docker composition in background: `docker compose up -d`
 (or `docker-compose up -d`)
- test again devices, scripts, etc
- reboot your host and verify if the docker composition is up and running after the restart

## Setup a new Domoticz installation

Go into the folder `_domoticz` and launch the docker composition in foreground
for a simpler access to the logs; it will block your terminal.

```
docker compose up
```

or, for older Docker compose versions:

```
docker-compose up
```
 
Wait a little, the first setup of `Z-Wave JS UI` takes some time.

As a reference, the `Domoticz` [documentation is here](https://www.domoticz.com/wiki/Zwave-JS-UI).

Open `Domoticz`. In the tab `Custom`, open `ZwaveJSU` (the `Z-Wave JS UI` panel).

Verify the settings: if the device is correct, the Z-Wave controller and nodes
should be listed in the `Control Panel`.

You may modify some settings: enable the backups, change the `HomeAssistant/Entity name template`, etc.
The settings regarding MQTT and network should work as is with `Domoticz`.
Don't forget to save any change.

In `Domoticz`, add new hardware as described in the documentation. The values to set are:
- `Remote Address`: mosquitto
- `Port`: 1883
- `Auto Discovery Prefix`: the one you set in the file `configuration.cfg` (`homeassistant` by default)

The Z-Wave nodes should be added in `Domoticz`: one or more devices are added per node, depending on your Z-Wave hardware.
With the default configuration, the device names are like `nodeID_2`.
Use the `ZwaveJSU` panel to include/exclude devices.

If you keep both protocols, create a new hardware for `Zigbee2MQTT` with the same values, except the `Auto Discovery Prefix`.

The Zigbee devices should be added in `Domoticz`: one or more `Domoticz` devices are added per Zigbee device, depending on your hardware.
Use the `Zigbee2MQTT` panel to configure you Zigbee network.

Once all is tested (Z-Wave, Zigbee, scripts, etc), you should reboot your server and
verify that the docker composition is up and running after the restart.

## Troubleshooting

### Use the MQTT Explorer

In the tab `Custom`, open `MQTT`: the `MQTT Explorer` login window is opened.
Connect to the local Mosquitto service and explore the message queues.

### Useful links

[`Domoticz` Wiki](https://www.domoticz.com/wiki)

[`Z-Wave JS UI`](https://zwave-js.github.io/zwave-js-ui/#/)

[`Zigbee2MQTT`](https://www.zigbee2mqtt.io/)

[`MQTT Explorer`](https://mqtt-explorer.com)

[docker compose command line](https://docs.docker.com/engine/reference/commandline/compose/)

[docker compose file specifications](https://docs.docker.com/compose/compose-file/)
