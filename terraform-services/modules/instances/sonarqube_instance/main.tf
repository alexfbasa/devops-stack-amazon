provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "sonarqube_instance" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t2.medium"
  key_name               = "CP001-DevOpsTools-Prod-KeyPair"
  vpc_security_group_ids = ["sg-0da9da931cdcb559a"]

  tags = {
    Name              = "SonarQube-Nginx"
    ProjectID         = "CP001"
    ProductName       = "DevOpsTools"
    ServerFunction    = "SonarQube"
    ProductEnv        = "Prod"
    SettingDefinition = "Instance"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/CP001-DevOpsTools-Prod-KeyPair.pem")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "${path.module}/../../../scripts/instances/sonarqube/install_sonarqube.sh"
    destination = "/tmp/install_sonarqube.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_sonarqube.sh",
      "/tmp/install_sonarqube.sh",
    ]
  }
}
