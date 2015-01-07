raspberry pi docker-lizmap 
=============

(lizmap-web-client-2.10.0 inside)

for install docker in the raspberry pi : 
http://www.le-libriste.fr/2015/01/installer-docker-sur-un-raspberry-pi-tournant-sous-raspbian/



![docker_lizmap](https://cloud.githubusercontent.com/assets/6421175/4627293/b7a0a594-5389-11e4-909b-916039a16981.png)


This image contains a WebGIS server: 
Apache, qgis-mapsever, lizmap-web-client, and all dependencies required for operation


To build the image do:

 you can build an image from Dockerfile:

```
docker build -t jancelin/rpi-docker-lizmap git://github.com/jancelin/rpi-docker-lizmap

```

1.run for test
```
docker run --restart="always" --name "websig-lizmap" -p 8081:80 -d -t  jancelin/rpi-docker-lizmap
```
Lizmap working for testing at 

http://"your_ip_serveur":8081/lizmap-web-client-2.10.0/lizmap/www/

-----------------------------------------------------------------------------------

2.before running if is not a test: 

This version keeps on host files (jauth.db, lizmapConfig.ini.php, logs.db) so you can use it for other Container. 

If the host is ubuntu server:
Copy the files to a directory on the host, do a chown :www-data about each file ( or add -R for the folder) and install php5-sqlite: apt-get install php5-sqlite

If the host is centos: Copy the files to a directory on the host, do a chown :33 on each file (apache does not know :www-data, but :apache so we make it a joke). And install php5-sqlite: http://www.nginxtips.com/install-php-5-5-centos-6-5/


To run a container do:
```
docker run --restart="always" --name "websig-lizmap" -p 8081:80 -d -t -v /your_qgis_folder:/home:ro -v /your_config_folder:/home2 jancelin/docker-lizmap
```

-p 8081:80 ---> link between the port 80 of the Container and port 8081 of the host

-v /your_folder:/home:ro ---> provides a link between your host file (read-only)containing the .qgs, and / home Container.

-v /your_config_folder:/home2 ---> rovides a link between your host file containing the lizmap config, and / home2 Container.

ex: docker run --name "websig-lizmap-entomo" -p 8081:80 -d -t -v /home/jancelin/ENTOMO:/home:ro -v /home/jancelin/sauvlizmap/entomo:/home2 jancelin/docker-websig




or for edit 

docker run  -i -t jancelin/docker-lizmap /bin/bash 

if you want to save your edition : docker commit "id_of_container" "new_image_name"

____________________________________________________________________________________

Lizmap working for testing at 

http://"your_ip_serveur":8081/lizmap-web-client-2.10.0/lizmap/www/

lizmap admin at 

http://"your_ip_serveur":8081/lizmap-web-client-2.10.0/lizmap/www/admin.php

Lizmap working with your data and config at : 

http://"your_ip_serveur":8081/websig/lizmap/www/

lizmap admin at 

http://"your_ip_serveur":8081/websig/lizmap/www/admin.php

____________________________________________________________________________________

Lizmap Web Application generates dynamically a web map application (php/html/css/js) with the help of Qgis Server ( QGIS Server Tutorial ). You can configure one web map per Qgis project with the QGIS LizMap Plugin.

http://docs.3liz.com/

http://www.3liz.com/

____________________________________________________________________________________

Julien ANCELIN ( julien.ancelin@stlaurent.lusignan.inra.fr) 09/2014 INRA
