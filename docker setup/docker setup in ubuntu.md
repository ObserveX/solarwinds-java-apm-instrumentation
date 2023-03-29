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
