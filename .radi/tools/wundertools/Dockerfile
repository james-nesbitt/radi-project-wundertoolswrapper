# Wundertools Wrapper Docker build file
#
# This build expects:
#   1. this docker build should be run after a composer install has been used to retrieve vendor/build www
#   2. docker build using this file should be executed from the project source root (copy this file there first)
#
FROM quay.io/wunder/fuzzy-alpine-base:v3.4
MAINTAINER james.nesbitt@wunder.io

# Add core source
ADD drupal/current/web /app/web
ADD drupal/current/vendor /app/vendor

# Now it appears that drupal console wants to see composer files.
ADD drupal/conf/composer.json /app/composer.json
ADD drupal/conf/composer.lock /app/composer.lock

# Add project code and conf
ADD drupal/code/modules/custom /app/web/modules/custom
ADD drupal/code/themes/custom /app/web/themes/custom
#ADD drupal/code/profiles/custom /app/web/profiles/custom
#ADD drupal/code/libraries/custom /app/web/libraries/custom

# Add in Drupal config
ADD drupal/config/sync /app/config

# Add Drupal site settings
ADD drupal/conf/services.yml /app/web/sites/default/services.yml
ADD drupal/conf/settings.php /app/web/sites/default/settings.php
ADD drupal/conf/settings.local.php /app/web/sites/default/settings.local.php
