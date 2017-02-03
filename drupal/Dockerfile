# Wundertools Wrapper Docker build file
#
# This build expects:
#   1. this docker build should be run after a composer install has been used to retrieve vendor/build www
#   2. docker build using this file should be executed from the project source drupal root
#
FROM quay.io/wunder/fuzzy-alpine-base:v3.4
MAINTAINER james.nesbitt@wunder.io

# Add core source
ADD current/web /app/web
ADD current/vendor /app/vendor

# Now it appears that drupal console wants to see composer files.
ADD conf/composer.json /app/composer.json
ADD conf/composer.lock /app/composer.lock

# Add project code and conf
ADD code/modules/custom /app/web/modules/custom
ADD code/themes/custom /app/web/themes/custom
#ADD code/profiles/custom /app/web/profiles/custom
#ADD code/libraries/custom /app/web/libraries/custom

# Add in Drupal config
ADD sync /app/config

# Add Drupal site settings
ADD conf/services.yml /app/web/sites/default/services.yml
ADD conf/settings.php /app/web/sites/default/settings.php
ADD conf/radi.settings.php /app/web/sites/default/settings.local.php
ADD conf/radi.services.yml /app/web/sites/default/services.local.yml
