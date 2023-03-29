# SolarWinds---Sample-Java-App-Instrumentation-

Approches used for Instrumentation:   
[A] Manual Setup(Not recommended in Prod)  
[B] Using Dockerfile to include SolarWinds Instrumentation steps(Recommended method)



## [A] Manual Setup(Not recommended in Prod)

Pull and run the Konakart Community Edition with below docker command: 

```bash
docker run -d --name kk9600 -p 8780:8780 -p 8783:8783 konakart/konakart_9600_ce
```

This docker image contains the KonaKart demo store (Community Edition) with a pre-populated PostgreSQL database. After running the docker run command open a browser and see the storefront at: [http://localhost:8780/konakart/](http://localhost:8780/konakart/)

The Admin Application is at: [http://localhost:8780/konakartadmin/](http://localhost:8780/konakartadmin/)

(login using “admin@konakart.com” as the username and “princess” as the password)

### Steps for APM Instrumentation(Backend)

1) Find the container ID or name using the **`docker ps`**command:

```bash
docker ps
```

2) Use the **`docker exec`**command to start a shell inside the container:

```bash
docker exec -it CONTAINER_ID /bin/bash
docker exec -it 6828ced931b2 /bin/bash
```

3) Once inside the container, Download the SolarWinds agent jar file

```bash
curl -sSO [https://agent-binaries.cloud.solarwinds.com/apm/java/latest/solarwinds-apm-agent.jar](https://agent-binaries.cloud.solarwinds.com/apm/java/latest/solarwinds-apm-agent.jar)
```

4) Load SolarWinds agent into application startup

```bash
cd /usr/local/konakart/bin/
vim catalina.sh
```

```bash
##Add below line in catalina.sh
JAVA_OPTS="$JAVA_OPTS -javaagent:/opt/solarwinds-apm-agent.jar -Dsw.apm.service.key=Ig24VMqJ2IvEgpVjONtg-xjccmPoBuxey7PSBNlY4kbCag28hDJwab1S7MkJgVBRHMAY7-g:test_docker -Dsw.apm.collector=[apm.collector.cloud.solarwinds.com](http://apm.collector.cloud.solarwinds.com/)"
```

5) exit the container 

```bash
exit
```

6) Restart the container to apply the changes:

```bash
docker restart CONTAINER_ID
docker restart 6828ced931b2 
```

Generate load on application and verify APM data in SolarWinds. 

## [B] Using Dockerfile to include SolarWinds Instrumentation steps(Recommended method)
```
mkdir konakart_mod
cd konakart_mod
```
1) Create a DockerFile
```
vim Dockerfile
```
In below Dockerfile, we added a RUN command to download the SolarWinds APM agent and included the agent and other options during startup
```
# Use the existing Konakart image as the base
FROM konakart/konakart_9600_ce

# Set the working directory
WORKDIR /app

# Install curl
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Download the SolarWinds APM agent using curl
RUN curl -sSO https://agent-binaries.cloud.solarwinds.com/apm/java/latest/solarwinds-apm-agent.jar

# Copy the agent to the desired location
RUN mv solarwinds-apm-agent.jar /opt/solarwinds-apm-agent.jar

# Add the JAVA_OPTS line to the catalina.sh file
RUN sed -i 's|^JAVA_OPTS=.*|JAVA_OPTS="-javaagent:/opt/solarwinds-apm-agent.jar -Dsw.apm.service.key=Ig24VMqJ2IvEgpVjONtg-xjccmPoBuxey7PSBNlY4kbCag28hDJwab1S7MkJgVBRHMAY7-g:konakart_test -Dsw.apm.collector=apm.collector.cloud.solarwinds.com"|' /usr/local/konakart/bin/catalina.sh

# Start Konakart
#CMD ["/usr/local/konakart/bin/startkonakart.sh", "run"]

```
2) Build your custom Docker image:
```
docker build -t custom_konakart .
```
3) Run a new container using your custom Docker image:
```
docker run -d --name custom_kk9600 -p 8780:8780 -p 8783:8783 custom_konakart
```
### You can then access Konakart here: http://localhost:8780/. Generate load on application and verify APM data in SolarWinds.

## Below is the docker image created from the above build.
## Pull and Run this Docker Image with SolarWinds APM already instrumented. Modify the servicekey as needed. 
docker run -d --name kk8300 -p 8780:8780 -p 8783:8783 soultechie/solarwinds-apm

### Steps for Enabling RUM(FrontEnd monitoring) via manual injection

1) On SolarWinds —> Add Data —> Website —> Select Real User Monitoring and provide the Name and URL —> Copy the script. 

```bash
<script src="[https://rum-agent.na-01.cloud.solarwinds.com/ra-e-1570705138407104512.js](https://rum-agent.na-01.cloud.solarwinds.com/ra-e-1570705138407104512.js)" async></script>
```

2) Use the **`docker exec`**command to start a shell inside the container:

```bash
docker exec -it 6828ced931b2 /bin/bash
```

3) To receive RUM data from your website, add the script immediately before the </body> element on below Konakart web pages.

```bash
Konakart path --> /usr/local/konakart/webapps/konakart/WEB-INF/jsp/MainLayout.jsp
Konakart admin path --> /usr/local/konakart/webapps/konakartadmin/KonakartAdmin.html
```

4) exit the container 

```bash
exit
```

5) Restart the container to apply the changes:

```bash
docker restart CONTAINER_ID
docker restart 6828ced931b2 
```

Generate load on application and verify RUM data in SolarWinds.
