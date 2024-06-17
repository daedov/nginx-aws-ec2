 #!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sudo chown nginx:nginx /usr/share/nginx/html/index.html
sudo systemctl restart nginx

