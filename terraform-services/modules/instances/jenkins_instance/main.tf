provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins_instance" {
  ami                    = "ami-002070d43b0a4f171"
  instance_type          = "t2.small"
  key_name               = "CP001-DevOpsTools-Prod-KeyPair"
  vpc_security_group_ids = ["sg-00f3490c81898b73b"]

  tags = {
    Name              = "Jenkins"
    ProjectID         = "CP001"
    ProductName       = "DevOpsTools"
    ServerFunction    = "Jenkins"
    ProductEnv        = "Prod"
    SettingDefinition = "Instance"
  }

  connection {
    type        = "ssh"
    user        = "centos"
    private_key = file("~/.ssh/CP001-DevOpsTools-Prod-KeyPair.pem")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "${path.module}/../../../scripts/instances/jenkins/install_jenkins.sh"
    destination = "/tmp/install_jenkins.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_jenkins.sh",
      "/tmp/install_jenkins.sh",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "docker run --name jenkins --rm -d -p 8080:8080 --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD='P@ssword2#J&N1ks' alexsimple/jenkins_jcasc:v1",
    ]
  }
}
