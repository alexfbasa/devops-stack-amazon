# Launching Jenkins

Jenkins will be running in a Docker Container containing some app already installed.
* Oracle OpenJDk13
* Maven3

## Steps
1 - Name your instance
Pattern name
ProjectID - ProductName - ServerFunction - ProductEnv - SettingDefinition
CP001     - DevOpsTools - Jenkins        - Prod       - Instance/SecurityGroup/KeyPair

CP001-DevOpsTools-Jenkins-Prod-Instance

2 - Choose the AMI - this case Cento7 with Updates;
- AMI ami-002070d43b0a4f171

3 - Instance type;
- t2.small

4 - Key Pair;
ProjectID - ProductName - ProductEnv - SettingDefinition
CP001-DevOpsTools-Prod-KeyPair

Obs - Permission key 400; user access to Centos can be *ec2-user* and also *centos*.
ssh -i "key-pair" ec2-user@host-public-ip
ssh -i "key-pair" centos@host-public-ip

4 - Security Group;
Use pattern name.
ProjectID - ProductName - ServerFunction - ProductEnv - SettingDefinition
CP001-DevOpsTools-Jenkins-Prod-SecurityGroup
Inbound
Access for SSH 22 my IP
Access for Jenkins web access Custom 8080 Anywhere 

## Installation 
Connect into the Amazon instance and install docker.
You can crete a script, give execution permission and run it, the docker_setup.sh can be found at userdata folder;

## Running Jenkins container.
docker run --name jenkins --rm -d -p 8080:8080 --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD={{password}} alexsimple/jenkins_jcasc:v1

Check services running.