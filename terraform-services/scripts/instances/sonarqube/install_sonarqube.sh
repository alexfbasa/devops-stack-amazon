#!/bin/bash
set -e

# Backup functions
backup_file() {
  local file=$1
  local backup_suffix
  backup_suffix=".backup_$(date +%Y%m%d%H%M%S)"
  sudo cp "$file" "$file$backup_suffix"
}

# System Configuration
echo "Configuring system parameters..."
backup_file "/etc/sysctl.conf"
cat <<EOT | sudo tee /etc/sysctl.conf
vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096
EOT

backup_file "/etc/security/limits.conf"
cat <<EOT | sudo tee /etc/security/limits.conf
sonarqube   -   nofile   65536
sonarqube   -   nproc    409
EOT

# Install Java
echo "Installing OpenJDK 17..."
sudo apt-get update -y
sudo apt-get install openjdk-17-jdk -y
sudo update-alternatives --config java
java -version

# Database Configuration
echo "Configuring PostgreSQL..."
sudo apt-get install postgresql postgresql-contrib -y
sudo systemctl enable postgresql.service
sudo systemctl start postgresql.service

# Set PostgreSQL user password
echo "Setting PostgreSQL user password..."
sudo -u postgres psql -c "ALTER USER postgres WITH ENCRYPTED PASSWORD 'admin123';"

# Create SonarQube Database
echo "Creating SonarQube database..."
sudo -u postgres psql -c "CREATE USER sonar WITH ENCRYPTED PASSWORD 'admin123';"
sudo -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;"

# SonarQube Installation
echo "Installing SonarQube..."
sudo mkdir -p /sonarqube/
cd /sonarqube/
sudo curl -O https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.3.0.34182.zip
sudo apt-get install zip -y
sudo unzip -o sonarqube-8.3.0.34182.zip -d /opt/
sudo mv /opt/sonarqube-8.3.0.34182/ /opt/sonarqube
sudo groupadd sonar
sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar
sudo chown sonar:sonar /opt/sonarqube/ -R

# Configure SonarQube
echo "Configuring SonarQube..."
cat <<EOT | sudo tee /opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=sonar
sonar.jdbc.password=admin123
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
sonar.web.host=0.0.0.0
sonar.web.port=9000
sonar.web.javaAdditionalOpts=-server
sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError
sonar.log.level=INFO
sonar.path.logs=logs
EOT

# Create SonarQube systemd service
echo "Configuring SonarQube systemd service..."
cat <<EOT | sudo tee /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOT

# Start SonarQube service
sudo systemctl daemon-reload
sudo systemctl enable sonarqube.service
sudo systemctl start sonarqube.service

# Nginx Configuration
echo "Configuring Nginx..."
sudo apt-get install nginx -y
sudo rm -rf /etc/nginx/sites-enabled/default
sudo rm -rf /etc/nginx/sites-available/default

cat <<EOT | sudo tee /etc/nginx/sites-available/sonarqube
server {
    listen 80;
    server_name sonarqube.groophy.in;

    access_log  /var/log/nginx/sonar.access.log;
    error_log   /var/log/nginx/sonar.error.log;

    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    location / {
        proxy_pass  http://127.0.0.1:9000;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;

        proxy_set_header    Host            \$host;
        proxy_set_header    X-Real-IP       \$remote_addr;
        proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto http;
    }
}
EOT

# Enable Nginx site
sudo ln -s /etc/nginx/sites-available/sonarqube /etc/nginx/sites-enabled/sonarqube
sudo systemctl enable nginx.service

# Configure Firewall
echo "Configuring UFW..."
sudo ufw allow 80,9000,9001/tcp

echo "System reboot in 30 sec"
sudo shutdown -r now
