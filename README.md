# SolarWinds---Sample-Java-App-Instrumentation-

# Easy Setup 
## Pull and Run this Docker Image with SolarWinds APM already instrumented. Modify the servicekey as needed. 
docker run -d --name kk8300 -p 8780:8780 -p 8783:8783 soultechie/solarwinds-apm


# **Java App in Docker Instrumentation**

### Install Docker on Ubuntu

1. Update the package database and upgrade any existing packages:
    
    ```
    sudo apt-get update
    sudo apt-get upgrade
    ```
    
2. Install the necessary packages to allow the use of Docker’s repository:
    
    ```
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
    ```
    
3. Add Docker’s GPG key:
    
    ```
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    ```
    
4. Add the Docker repository to your system:
    
    ```
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    ```
    
5. Update the package database once again, so it includes the Docker repository:
    
    ```
    sudo apt-get update
    ```
    
6. Finally, install Docker:
    
    ```
    sudo apt-get install docker-ce
    ```
    
7. Verify that Docker is installed and running:
    
    ```
    sudo systemctl status docker
    ```
    

### Pull and run the Konakart Community Edition with below docker command:

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

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/421cf54c-a999-4857-bcce-6a98b7bef4ef/Untitled.png)

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

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/ebad0b43-5207-4e84-b8e6-0136aff25f3f/Untitled.png)

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
