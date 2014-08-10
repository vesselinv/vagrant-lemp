#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

sudo aptitude update -q

# Force a blank root password for mysql
echo "mysql-server mysql-server/root_password password " | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password " | debconf-set-selections

# Install mysql, nginx, php5-fpm
sudo aptitude install -q -y -f mysql-server mysql-client nginx php5-fpm

# Install commonly used php packages
sudo aptitude install -q -y -f php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcached php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-xcache

sudo rm /etc/nginx/sites-available/default
sudo touch /etc/nginx/sites-available/default

sudo cat >> /etc/nginx/sites-available/default <<'EOF'
server {
  listen   80;

  root /usr/share/nginx/html;
  index index.php index.html index.htm;

  # Make site accessible from http://localhost/
  server_name _;

  location / {
    # First attempt to serve request as file, then
    # as directory, then fall back to index.html
    try_files $uri $uri/ /index.html;
  }

  location /doc/ {
    alias /usr/share/doc/;
    autoindex on;
    allow 127.0.0.1;
    deny all;
  }

  # redirect server error pages to the static page /50x.html
  #
  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }

  # pass the PHP scripts to FastCGI server listening on /tmp/php5-fpm.sock
  #
  location ~ \.php$ {
    try_files $uri =404;
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_index index.php;
    include fastcgi_params;
  }

  # deny access to .htaccess files, if Apache's document root
  # concurs with nginx's one
  #
  location ~ /\.ht {
    deny all;
  }

  ### phpMyAdmin ###
  location /phpmyadmin {
    root /usr/share/;
    index index.php index.html index.htm;
    location ~ ^/phpmyadmin/(.+\.php)$ {
      client_max_body_size 4M;
      client_body_buffer_size 128k;
      try_files $uri =404;
      root /usr/share/;

      # Point it to the fpm socket;
      fastcgi_pass unix:/var/run/php5-fpm.sock;
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      include /etc/nginx/fastcgi_params;
    }

    location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt)) {
      root /usr/share/;
    }
  }
  location /phpMyAdmin {
    rewrite ^/* /phpmyadmin last;
  }
  ### phpMyAdmin ###
}
EOF

sudo touch /usr/share/nginx/html/info.php
sudo cat >> /usr/share/nginx/html/info.php <<'EOF'
<?php phpinfo(); ?>
EOF

sudo aptitude install -q -y -f phpmyadmin

sudo service nginx restart

sudo service php5-fpm restart
