alpine linux base image with:
- nginx
- php 5.6
- composer
- new relic
 
Includes sample command script `start.sh` using pid tracking method to run nginx and php-fpm in the same container without running a separate task manager.

Image doesn't serve anything on its own. It must be used as a base for another image. 
 
Only contains default nginx/php configuration. You will need to add files to `/etc` to configure nginx and php to serve your project.