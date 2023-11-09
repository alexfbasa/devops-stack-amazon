resource "aws_instance" "jenkins_instance" {
  ami                    = "ami-002070d43b0a4f171"
  instance_type          = "t2.small"
  key_name               = "CP001-DevOpsTools-Prod-KeyPair"
  security_group_names   = ["CP001-DevOpsTools-Jenkins-Prod-SecurityGroup"]

  tags = {
    Name = "CP001-DevOpsTools-Jenkins-Prod-Instance"
  }

  provisioner "file" {
    source = "${path.module}/../userdata/docker-setup.sh"
    destination = "/tmp/docker-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/docker-setup.sh",
      "/tmp/docker-setup.sh"
    ]
  }
}
