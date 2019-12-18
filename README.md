# EPAS - Enterprisedb docker image

Dockerfile from [tsteward](https://postgresrocks.enterprisedb.com/t5/user/viewprofilepage/user-id/36)'s [quickstart post](https://postgresrocks.enterprisedb.com/t5/EDB-Guides/Docker-EPAS-Quickstart/ba-p/124).

## Instructions to build and use the docker image

THE FOLLOWING INSTRUCTIONS ARE DIRECTLY COPIED FROM [THE ORIGINAL POST](https://postgresrocks.enterprisedb.com/t5/EDB-Guides/Docker-EPAS-Quickstart/ba-p/124) (just in case it's deleted at some point).

Build the Dockerfile into a Docker image. Don't forget the '.' specifying the directory of the Dockerfile as current directory.  This will do a bunch of stuff, basically running all the steps in the Dockerfile to create the image.

```bash
docker build --build-arg REPO_USER=$yourrepouser --build-arg REPO_PASSWORD=$yourrepopassword -t $dockerhubaccount/epas:9.4 .
```

Now let's start the EPAS container in interactive terminal so we can see the STDOUT

```bash
docker run -it  $dockerhubaccount/epas:9.4
```

Congrats!  You started the EPAS container.  Now let's kill it and start it in the background as a daemon with a name.

```bash
<ctrl>-C
docker run -d --name epas $dockerhubaccount/epas:9.4
docker ps
```

Nice, your EPAS container is running.  Now, let's exec a command inside the container to connect to the database with psql.

```bash
docker exec -it epas /usr/ppas-9.4/bin/psql -d edb
\conninfo
exit
```

Now your image is ready to be pushed to the registry.

```bash
docker push $dockerhubaccount/epas:9.4
```

That is pretty nice, but not so good if we can only connect to EPAS from inside the container.  How do we export the port so that someone outside the container can connect to EPAS?  Not hard at all, we just map the port inside the container to a port on the host.  So, let's kill our current container and restart with a port mapping.

```bash
docker rm -f epas
```

Start the container mapping port 5444 on the Docker host to port 5444 inside the container.

```bash
docker run -d --name epas -p 5444:5444 $dockerhubaccount/epas:9.4
```

Now we can connect to the EPAS database from the host via psql or your database client of choice.

```bash
psql -p 5444 -d edb -U enterprisedb
```
