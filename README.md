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
 docker run -d --name mqtt --hostname mqtt -p 1883:1883 image-mosquitto
```

By default, the container will be started with used `/etc/mosquitto/mosquitto.conf` as configuration file, in which:
- anonymous access has deactivated
- requires the use of a valid username and password before a connection from MQTT broker.

Password file called `passwd` is included in the image.
The file has one default  user - `mosquitto` with password of `Mosquitto!`

#### To use a custom configuration file you need mount local directory where `mosquitto.conf` file saved - see below on volume mappings!

### To test MQTT service

When run the container from builded image (as above) which is named  `mqtt` enter:

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

### Run a container with persistence storage

#### Create three directories on host:

```
mkdir -p /opt/mqtt/conf
mkdir /opt/mqtt/logs
mkdir /opt/mqtt/data
```

You can change `/opt/mqtt/` as needed for your particular needs!

#### Copy files from repo folder:

```
cp image-mosquitto/imosquitto.conf /opt/mqtt/conf
cp image-mosquitto/passwd /opt/mqtt/conf
```

Create a logs file yet:

```
touch /opt/mqtt/logs/mosquitto.log
```

#### Change the permissions of the directories

User `mosquitto` must have permissions to read/write to data and logs directory and read to config directory:

```
chmod -R o+r /opt/mqtt/conf
chmod -R o+rwx /opt/mqtt/logs
chmod -R o+rwx /opt/mqtt/data
```

NOTE: Use the above for testing, better way create to `mosquitto` user on docker host and set permissions only for him.

#### To Create a container hosting the volume mappings

```
docker run -d --name mqtt --hostname mqtt -p 1883:1883 \
-v /opt/mqtt/conf:/etc/mosquitto \
-v /opt/mqtt/logs:/var/log/mosquitto \
-v /opt/mqtt/data/:/var/lib/mosquitto image-mosquitto
```

See above for checks and testing `mosquitto` service!

### Volumes

- `/etc/mosquitto` - where `mosquitto` configuration files saved 
- `/var/log/mosquitto` - path where `mosquitto` write log files
- `/var/lib/mosquitto` - path where `mosquitto` database is stored

### Ports

- `1883/tcp` - default port of the MQTT listener
