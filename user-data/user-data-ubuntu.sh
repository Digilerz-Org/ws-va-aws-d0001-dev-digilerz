#! /bin/bash

sudo apt update
sudo apt install nginx -y
sudo ufw allow 'Nginx HTTP'
sudo systemctl start nginx
sudo mkdir -p /var/www/your_domain/html
sudo chown -R $USER:$USER /var/www/your_domain/html
sudo chmod -R 755 /var/www/your_domain
sudo echo " Hello welcome to Server 2 (Ubuntu)" >  /var/www/your_domain/html/index.html
sudo systemctl restart nginx
sudo systemctl reload nginx
sudo systemctl enable nginx

# #apache
# sudo apt-get update
# sudo apt-get install -y apache2
# sudo systemctl start apache2
# sudo systemctl enable apache2
# echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html


