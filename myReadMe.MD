
1. Create EC2 and ssh to it
2. Install Jenkins 
```
sudo apt update
sudo apt install openjdk-17-jre -y
java -version
```

```
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update

sudo apt-get install jenkins -y
```

3. Login to Jenkins UI and Create pipeline eg: ultimate-demo
4. Use docker container as jenkins agent
5. Write an docker image within container u have maven installed.
```
abhishekf5/maven-abhishek-docker-agent:v1
```

6. Downlaod Docker pipeline plugin in jenkins UI.
7. Install SonarQube scanner plugin as well
8. Install SonarQube installation in EC2(Ultimate-demo)
```
sudo apt update && sudo apt install unzip -y
sudo adduser sonarqube
sudo su - sonarqube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.4.1.88267.zip
unzip *
```
Check Permision:
```
chown -R sonarqube:sonarqube /opt/sonarqube
chmod -R 775 /opt/sonarqube
```

Go to bin folder:
```
cd /opt/sonarqube/bin/linux-x86-64
./sonar.sh start
```

9. Browse Sonar--> http://54.196.110.222:9000. Sonar will Up and Running.

10. Create Sonar token in SonarUI with name: jenkins
11. Add Sonar Token into Jenkins credential Store with id: soanrqube

# Install Docker 
12. Install docker commands in ultimate Ec2
```
sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu
sudo systemctl restart docker
```
Restart jenkins

# MiniKube Installation
1. Install minikube on you local machine (windows or mac). You can check in minikube website or gpt as well.

2. 



