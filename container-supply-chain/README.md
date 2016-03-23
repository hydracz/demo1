Supply Chain Demo
======================================

Usage
-----
This repository is meant to demonstrate a software supply chain that provides best practices for operations teams looking to  adopt containers in a production environment. 

Deeper explaination will be followed up in a blog entry, but a technical person should be able to look at these docs and understand how to implement a sane container software supply chain. This particular implementation uses a Red Hat stack but these concepts apply equally to Ubuntu, Debian, CentOS or Fedora. 

To build all images:
```
make
```

To tag the latest built images as production:
```
make tag_production
```

TBD: To push the lastest production images into a registry server:
```
make push
```

Directories
-----------

* corebuild: Corebuild which does initial yum installs and updates from upstream Red Hat Engineering. This core build would typically be execute by the operations team and saved in an enterprise registry locally within a company.

* httpd-php: Middleware layer, built upon rhel7-crunchtools core build, which installs and configures Apache 2.4 and PHP 5.6 from the Red Hat Software Collections. This set of software is built to work together using the modern FPM/FastCGI technology and Apache's MPM event driven main loop.

* wordpress: Middleware layer, built upong crunchtools-httpd24-php56, which installs wordpress using a similar methodology as the Official image on DockerHub. The advantage of this build is it constructed on a completely trusted software supply chain.
