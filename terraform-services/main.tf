provider "aws" {
  region = "us-east-1"
}

module "common" {
  source = "./modules/common"
}

module "network" {
  source = "./network"
}

module "jenkins_instance" {
  source = "./modules/instances/jenkins_instance"
}

module "sonarqube_instance" {
  source = "./modules/instances/sonarqube_instance"
}

resource "null_resource" "common_setup" {
  # This resource is used for executing the common setup script.
  # It doesn't create any actual infrastructure, just triggers the provisioners.

  provisioner "remote-exec" {
    inline = [
      "chmod +x ${path.module}/scripts/common/setup.sh",
      "${path.module}/scripts/common/setup.sh",
    ]
  }

  depends_on = [
    module.jenkins_instance,
    module.sonarqube_instance,
  ]
}
