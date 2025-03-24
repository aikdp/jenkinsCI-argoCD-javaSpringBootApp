#!/bin/bash

USER_ID=$(id -u)
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2 is FAILED"
        exit 1
    else
        echo "$2 is SUCCESS"
     fi
}

CHECK(){
    if [ $USER_ID -ne 0 ]
    then 
        echo "Please Run this scirpt with ROOT previleges"
        exit 1
    fi
}
CHECK

# install java
sudo apt update -y
sudo apt install openjdk-17-jre -y
java -version

#Jenkins
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y

# Install Docker
sudo apt update
sudo apt install docker.io

sudo su - 
usermod -aG docker jenkins
usermod -aG docker ubuntu
systemctl restart docker

#install docker
dnf -y install dnf-plugins-core
VALIDATE $? "Installing Docker plugins"
 
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
VALIDATE $? "Installing Docker Repo"

dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
VALIDATE $? "Installing Docker Compose Plugins"

systemctl start docker
VALIDATE $? "Start Docker"

usermod -aG docker ec2-user
VALIDATE $? "User added in Docker group"

docker run hello-world
VALIDATE $? "Response from Docker"

docker --version
VALIDATE $? "Displaying Docker Version"

#install kubectl

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl

chmod +x ./kubectl

mv kubectl /usr/local/bin/kubectl

VALIDATE $? "Installion of Kubectl"

#install eksctl
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`


curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"


tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

mv /tmp/eksctl /usr/local/bin

VALIDATE $? "Installation of Eksctl"

df -hT
VALIDATE $? "Volume Resize"


#K9s: Webi for Linux and macOS (https://github.com/derailed/k9s)
# curl -sS https://webinstall.dev/k9s | bash        Manullay working, but userdata not working
curl -sL https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz -o k9s.tar.gz
tar -xzf k9s.tar.gz
sudo mv k9s /usr/local/bin/
VALIDATE $? "Installation K9s UI"
# k9s version

#kubens 
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
VALIDATE $? "Installation kubens for NAMESPACE"

#EBS CSI Driver
#EFS CSI Drivers

#HELM
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
VALIDATE $? "Installation of HELM"

echo "Exit and Login Agian will work Docker commands. Thanks"

echo "Note: Do aws configure to authenticate with AWS"


# # List block devices
# lsblk

# # Grow the partition (Ensure the partition number is correct)
# sudo growpart /dev/nvme0n1 4
# if [ $? -ne 0 ]; then echo "Disk Partition failed"; exit 1; fi

# # Extend Logical Volumes by 50% of free space
# sudo lvextend -l +50%FREE /dev/RootVG/rootVol
# sudo lvextend -l +50%FREE /dev/RootVG/varVol

# # Resize the XFS filesystem
# sudo xfs_growfs /
# if [ $? -ne 0 ]; then echo "Resize of RootVol failed"; exit 1; fi

# sudo xfs_growfs /var
# if [ $? -ne 0 ]; then echo "Resize of VarVol of Jenkins-ArgoCD failed"; exit 1; fi
