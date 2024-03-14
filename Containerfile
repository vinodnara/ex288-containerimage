FROM registry.access.redhat.com/ubi8/ubi:8.0

MAINTAINER Red Hat Training <training@redhat.com>

ENV DOCROOT=/var/www/html

# Labels consumed by OpenShift
LABEL io.k8s.description="A basic Apache HTTP Server child image, uses ONBUILD" \
      io.k8s.display-name="Apache HTTP Server" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="apache, httpd"

# Labels consumed by OpenShift
LABEL io.k8s.description="A basic Apache HTTP Server child image, uses ONBUILD" \
      io.k8s.display-name="Apache HTTP Server" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="apache, httpd"

RUN yum install -y --nodocs --disableplugin=subscription-manager httpd  &&  \
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
