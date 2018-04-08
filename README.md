image-mosquitto
================

Setup Mosquitto MQTT server using Docker

## How to use this image

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

By default, the container will be started with used `/etc/mosquitto/mosquitto.conf` as configuration file, in which:
- anonymous access has deactivated
- requires the use of a valid username and password before a connection from MQTT broker.

Password file called `passwd` is included in the image.
The file has one default  user - `mosquitto` with password of `Mosquitto!`

### To test MQTT service

When run the container from builded image (as above) enter into `mqtt`:

```
$ docker exec -it mqtt bash
```

Use first the command `mosquitto_pub` that publishes a message (test) on a topic (testTopic):

```
mqtt:~# mosquitto_pub -h localhost -p 1883 -t testTopic -u  mosquitto -P  Mosquitto! -m "test" -q 1 -r
```

Use second the command `mosquitto_pub ` that subscribes to a topic (testTopic) and prints all the receives messages:

```
mqtt:~# mosquitto_sub -h localhost -p 1883 -t testTopic -u mosquitto -P Mosquitto!
test
^C
```

### To add user and password

You can use command:

```mosquitto_passwd -b /etc/mosquitto/passwd new_user new_pass```

### To delete user

You can use command like this:

```mosquitto_passwd -D /etc/mosquitto/passwd new_user```

### Ports

- `1883/tcp` - default port of the MQTT listener
