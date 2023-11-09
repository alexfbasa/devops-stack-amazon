# Full DevOps stack on Amazon
First we are going to create the whole environment - Jenkins, Nexus, Sonarqube, Tomcat-Nginx, by manually provisioning
them by running setup scrip located in the userdata folder.
Second we are going to create the same environment using Terraform and doing it automatically. 

´´´
## Host and service definition
* Jenkins - Docker image - Centos 7
* Nexus - VM Host - Centos 
* SonarQube - NGINX - VM Host - Ubuntu 20
* Nexus - VM Host
### Prerequisites
- JDK 1.8 or later
- Maven 3 or later
- MySQL 5.6 or later

### Technologies 
- Spring MVC
- Spring Security
- Spring Data JPA
- Maven
- JSP
- MySQL
### Database
Here,we used Mysql DB 
MSQL DB Installation Steps for Linux ubuntu 14.04:
- $ sudo apt-get update
- $ sudo apt-get install mysql-server

Then look for the file :
- /src/main/resources/accountsdb
- accountsdb.sql file is a mysql dump file.we have to import this dump to mysql db server
- > mysql -u <user_name> -p accounts < accountsdb.sql

## Hints
* Amazon security groups
* Plugin in Jenkins
* Integrate Nexus - Jenkins
* Integrate Sonar - Jenkins
* Write the pipeline script
* Write notification
