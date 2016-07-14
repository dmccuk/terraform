#!/usr/bin/env bash

sudo yum update -y
sudo yum install mlocate mailx wget curl httpd -y

sudo cat > /var/www/html/index.html <<EOF
<!doctype html>
<title>Site Maintenance</title>
<style>
  body { text-align: center; padding: 150px; }
  h1 { font-size: 50px; }
  body { font: 20px Helvetica, sans-serif; color: #333; }
  article { display: block; text-align: left; width: 650px; margin: 0 auto; }
  a { color: #dc8100; text-decoration: none; }
  a:hover { color: #333; text-decoration: none; }
</style>

<article>
    <h1>We&rsquo;ll be back soon!</h1>
    <div>
        <p>Sorry for the inconvenience but we&rsquo;re performing some maintenance at the moment. If you need to you can always <a href="mailto:#">contact us</a>, otherwise we&rsquo;ll be back online shortly!</p>
        <p>&mdash; The Team</p>
    </div>
</article>
EOF

sudo service httpd start
IP=`sudo curl -s http://169.254.169.254/latest/meta-data/public-ipv4 > /tmp/ip.dm`
MAIL=`sudo cat /tmp/ip.dm | mailx -s "Hello from "$HOSTNAME VALUE_your@email.com`
$MAIL
