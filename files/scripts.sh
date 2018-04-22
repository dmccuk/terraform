#!/usr/bin/bash

# Update and install required packages
update_packages()
{
sudo yum update -y
sudo yum install httpd mlocate mailx wget curl git openscap-scanner scap-security-guide -y
}

webpage()
{
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
}

start_httpd()
{
sudo service httpd start
}

openscap_report()
{
# Run openscap report
oscap xccdf eval \
 --profile xccdf_org.ssgproject.content_profile_common \
 --results-arf arf.xml \
 --report common-report.html \
 /usr/share/xml/scap/ssg/content/ssg-rhel7-ds.xml
mkdir -p /var/www/html/reports
}

pre_report()
{
cp common-report.html /var/www/html/reports/pre-common-report.html
}

post_report()
{
cp common-report.html /var/www/html/reports/post-common-report.html
}

openscap_email()
{
# email out the openscap report
echo "Openscap - Common report" | mailx -s "Openscap - common report" -a "common-report.html" your.email@domain.com
}

grab_ip()
{
IP=`sudo curl -s http://169.254.169.254/latest/meta-data/public-ipv4 > /tmp/ip.dm`
}

email_ip()
{
MAIL=`sudo cat /tmp/ip.dm | mailx -s "Hello from "$HOSTNAME dyour.email@domain.com`
$MAIL
}

install_puppet()
{
rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm
yum -y install puppet-agent
export PATH=$PATH:/opt/puppetlabs/bin:
}

audit_rules()
{
yes | cp /usr/share/doc/audit-2.8.1/rules/30-stig.rules /etc/audit/rules.d/audit.rules
service auditd restart
}

#run the functions:
update_packages
#install_puppet
webpage
start_httpd
openscap_report
pre_report
audit_rules
openscap_report
post_report
#openscap_email
grab_ip
#email_ip
