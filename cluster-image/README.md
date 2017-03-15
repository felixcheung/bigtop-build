# Using Docker Compose
## Building the image
```
docker-compose build
```
## Starting a cluster using the image
```
./start-cluster.sh 2
```
This script requires `java` and `docker-compose`.

The first parameter is the number of worker nodes. Default is 2.
# Using Docker manually
## Building the image
`docker build . -t=cluster-node`
## Starting a cluster using the image
- Create a user defined network:
   `docker network create --driver bridge cluster`
- To start the headnode:

  ```
  docker run --network=cluster --rm -p 8080:8080 -p 8088:8088 -p 18080:18080 -p 4040:4040 -p 4041:4041 cluster-node
  ```
  Mark the hostname of the headnode. You need it to start the workernode.
- To start the workernode:

  ```
  docker run --network=cluster cluster-node <hostname of the headnode>
  ```
  You must use the hostname. IP will not work.
