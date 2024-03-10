FROM registry.access.redhat.com/ubi8/ubi:8.0
ENV DOCROOT=/var/www/html
MAINTAINER Red Hat Training <training@redhat.com>

RUN   yum install -y --nodocs --disableplugin=subscription-manager httpd && \
yum clean all --disableplugin=subscription-manager -y 
ONBUILD COPY src/ ${DOCROOT}/
# Allows child images to inject their own content into DocumentRoot
EXPOSE 8080
# This stuff is needed to ensure a clean start
RUN rm -rf /run/httpd && mkdir /run/httpd && \
chgrp -R 0 /var/run/httpd /var/log/httpd && chmod -R g=u /var/run/httpd /var/log/httpd && \
sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf
# Run as the root user
USER root
# Launch httpd
CMD /usr/sbin/httpd -DFOREGROUND

