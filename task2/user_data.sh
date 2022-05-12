#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "User-data started!"
sudo apt update -y && sudo apt install nginx -y
cat <<EOF > /var/www/html/index.html
<html>
<body>
<h2><font color="magenta">Build by Terraform</font><font color="red"> v1.1.9</font></h2>
</body>
</html>
EOF
