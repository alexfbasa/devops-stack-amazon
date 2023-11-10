sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker `id -un`

sudo systemctl start docker

sudo docker run hello-world


if [[ $? -ne 0 ]]
then
  echo "Docker install failed"
fi