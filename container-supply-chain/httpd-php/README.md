Middleware Core Build
======================================

Preparation
-----------
Make sure dockerfiles are installed locally on the build system
```
yum install rhscl-dockerfiles.noarch
cp /usr/share/rhscl-dockerfiles/rhel7/rh-php56/enablerh-php56.sh ./
cp /usr/share/rhscl-dockerfiles/rhel7/httpd24/enablehttpd24.sh ./
```

Build
-----

Building this Dockerfile requires a Red Hat Enterprise Linux 7 host
system with Software Collections entitlements available.
```
docker build -t http-php .
```

Run
---
```
docker run -d -p 80:8080 -p 443:8443 httpd-php
```

Test
----
```
curl localhost/info.php
```
