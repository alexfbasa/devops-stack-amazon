# Launching Nexus

## Steps
1 - Name your instance
Pattern name
ProjectID - ProductName - ServerFunction - ProductEnv - SettingDefinition
CP001     - DevOpsTools - Nexus        - Prod       - Instance/SecurityGroup/KeyPair
CP001-DevOpsTools-Nexus-Prod-Instance

2 - Choose the AMI - this case Cento7 with Updates;
- AMI ami-002070d43b0a4f171

3 - Instance type;
- t2.medium

4 - Key Pair;
ProjectID - ProductName - ProductEnv - SettingDefinition
CP001-DevOpsTools-Prod-KeyPair

4 - Security Group;
Use pattern name.
ProjectID - ProductName - ProductEnv - SettingDefinition
CP001-DevOpsTools-Nexus-Prod-SecurityGroup
Inbound
Access for SSH 22 my IP
Access for Nexus web access Custom 8081 Anywhere - If you create only access from My-IP, you need to create
the rule bellow, otherwise you do not need it.
Access 8081 from Jenkins Security Group 

## Install the application and packages.
You can find nexus-setup.sh in userdata folder.
You can run it pasting it on the advanced script field or running it as a script inside the host.

Check services running.

Obs - if you are through a VPN or Corporate network might block some Nexus page.

## Change admin pass

Go to log in page by http://public-ip:8081 and find into the Host the password file. Copy and past.
user - admin
pass - token - change it after first log in.
