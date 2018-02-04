# docker-zookeeper

Builds a Zookeeper image


## Quickstart:

### Standalone
The easiest way to run zookeeper is by launching a standalone instance:

```
docker run -d -p 2181:2181 --name zookeeper brunofitas/zookeeper:3.4.11
```

You can also run zookeeper with docker-compose:

```yaml
version: '3.2'
services:

  # Other services
  # ...
  
  zookeeper:
    image: brunofitas/zookeeper:3.4.11
    container_name: zookeeper
    ports:
      - 2181:2181
```


### Cluster 
I order to start a zookeeper cluster (or assembly), each instance has to be set with an unique ```ID``` and
a reference to every zookeeper server in the cluster - ```SERVER_[N]```. 

Here's an docker stack example that starts a single service of zookeeper on each 
node (worker01, worker02, worker03).


```
version: '3.2'
networks:
  zookeeper_network:
    external: true
services:
  zookeeper_1:
    image: brunofitas/zookeeper:3.4.11
    hostname: zookeeper_1
    deploy:
      placement:
        constraints:
          - node.hostname == worker01
    networks:
      - zookeeper_network
    environment:
      - ID=1
      - SERVER_1=zookeeper_1:2888:3888
      - SERVER_2=zookeeper_2:2888:3888
      - SERVER_3=zookeeper_3:2888:3888
  zookeeper_2:
    image: brunofitas/zookeeper:3.4.11
    hostname: zookeeper_2
    deploy:
      placement:
        constraints:
          - node.hostname == worker02
    networks:
      - zookeeper_network
    environment:
      - ID=2
      - SERVER_1=zookeeper_1:2888:3888
      - SERVER_2=zookeeper_2:2888:3888
      - SERVER_3=zookeeper_3:2888:3888
  zookeeper_3:
    image: brunofitas/zookeeper:3.4.11
    hostname: zookeeper_3
    deploy:
      placement:
        constraints:
          - node.hostname == worker03
    networks:
      - zookeeper_network
    environment:
      - ID=3
      - SERVER_1=zookeeper_1:2888:3888
      - SERVER_2=zookeeper_2:2888:3888
      - SERVER_3=zookeeper_3:2888:3888
```


## Environment Variables:  


Override the following variables to suit your needs:


- <b>ID</b> - Id for this server.<br>
default: 1 

- <b>TICK_TIME</b> - The number of milliseconds of each tick. <br>
default: 2000

- <b>INIT_LIMIT</b> - The number of ticks that the initial synchronization phase can take. <br>
default: 10 

- <b>SYNC_LIMIT</b> - The number of ticks that can pass between sending a request and getting an acknowledgement. <br>
default: 5 

- <b>DATA_DIR</b> - The directory where the snapshot is stored. <br>
default: /var/zookeeper

- <b>CLIENT_PORT</b> - The port at which the clients will connect.
<br>
default: 2181


- <b>MAX_CLIENT_CONXNS</b> - The maximum number of client connections. Increase this if you need to handle more clients.<br>
default: 60

- <b>AUTO_PURGE__SNAP_RETAIN_COUNT</b> - The number of snapshots to retain in dataDir. <br>
default: 3

- <b>AUTO_PURGE__PURGE_INTERVAL</b> - Purge task interval in hours. Set to "0" to disable auto purge feature.
<br>
default: 1


- <b>SERVER_[n] </b> - Zookeeper server. The fist port is used by followers to connect to the leader. The second one is used for leader election. <br>
example: zookeeper_1:2888:3888

## Build

```yaml
docker build -t <namespace/name:tag> .
```