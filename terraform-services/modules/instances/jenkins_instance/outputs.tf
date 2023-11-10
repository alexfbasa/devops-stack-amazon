output "jenkins_instance_ip" {
  description = "The public IP address of the Jenkins instance."
  value       = aws_instance.jenkins_instance.public_ip
}
