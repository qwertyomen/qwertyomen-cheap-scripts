#!/bin/bash
domain_name="server.domain.name"
echo "INFO: Running certbot.."
certbot -n certonly --webroot -w /opt/tomcat/webapps/ROOT/ -d $domain_name
echo "INFO: Copying keys.."
cd /etc/letsencrypt/live/$domain_name/
cp -f cert.pem /opt/tomcat/conf
cp -f chain.pem /opt/tomcat/conf
cp -f privkey.pem /opt/tomcat/conf
cd  /opt/tomcat/conf
chown tomcat_arcserver *.pem
echo "INFO: Restarting Tomcat.."
systemctl restart tomcat_arcserver
sleep 10
echo "INFO: Checking, this should say something like this:"
echo "tcp6       0      0 :::8443                 :::*                    LISTEN "
echo "RUNNING netstat.."
netstat -an | grep -i listen | grep 443
echo "INFO: if the two lines above look good then all is well"
curl --insecure -v https://localhost 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }'

#  ssl_certificate     /etc/ssl/certs/vctr.crt;
#  ssl_certificate_key /etc/ssl/certs/vctr.key;
