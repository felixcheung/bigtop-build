# Building the image
`docker build . -t=cluster` 
# Starting a cluster using the image
- Create a user defined network:
   `docker network create --driver bridge cluster`
- To start the headnode:
  `docker run --network=cluster cluster`
  Mark the hostname of the headnode. You need it to start the workernode.
- To start the workernode:
  `docker run --network=cluster cluster <hostname of the headnode>`
  You must use the hostname. IP will not work.
