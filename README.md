image-mosquitto
================

Setup Mosquitto MQTT server using Docker

## Quickstart

### Build the image

```
git clone https://github.com/kadasz/image-mosquitto
cd image-mosquitto
docker build -t image-mosquitto .
```

### Run a container 

```
 docker run -d --name mqtt -p 1883:1883 image-mosquitto
```

### Ports

- `1883/tcp` - default port of the MQTT listener
