output "sonarqube_instance_ip" {
  description = "The public IP address of the SonarQube instance."
  value       = aws_instance.sonarqube_instance.public_ip
}
