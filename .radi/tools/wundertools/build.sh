#!/bin/sh
##########
#
# Build the project source code:
#   - build a docker image with web source
#
# Usage:
#   --no-composer : don't run the composer part of the build (just build the image)
#   --composer-update : run composer update instead of just composer install
#   --no-image-build : don't build the docker image (just run composer)
#   --push-image : docker push the image
#

echo "----------------------------------------------
Commencing WunderTools -> Radi build
"

##### Interpret arguments #####################################################


sflag="-s"
for arg in "$@"
do
	case "$arg" in

	--no-composer)   
		echo " -> DISABLING COMPOSER RUN" 
		RUN_COMPOSER="no"
		;;

	--composer-update)   
		echo " -> COMPOSER WILL UPDATE INSTEAD OF INSTALL" 
		COMPOSER_COMMAND="update"
		;;

	--no-image-build)   
		echo " -> DISABLING DOCKER IMAGE BUILD" 
		RUN_IMAGEBUILD="no"
		;;

	--push-image)   
		echo " -> PUSHING DOCKER IMAGE BUILD" 
		RUN_IMAGEPUSH="yes"
		;;

	esac
done

echo " "

##### Some configurations #####################################################

PROJECT="${PROJECT:-wundertools}"

DOCKERREPO="${DOCKERREPO:-quay.io/}"
IMAGEROOT="${IMAGEROOT:-wunder/project-}"

[ -z "${IMAGENAME}" ] && IMAGENAME="${DOCKERREPO}${IMAGEROOT}${PROJECT}-source"

PROJECTROOT="/app/project"
DRUPALROOT="${PROJECTROOT}/drupal"

RUN_COMPOSER="${RUN_COMPOSER:-yes}"
RUN_IMAGEBUILD="${RUN_IMAGEBUILD:-yes}"
RUN_IMAGEPUSH="${RUN_IMAGEPUSH:-no}"

COMPOSER_COMMAND="${COMPOSER_COMMAND:-install}"

##### BUILD PROJECT SOURCE ####################################################

if [ "${RUN_COMPOSER}" = "yes" ]; then

	# let's build to /app/project/drupal/current, just like wundertools does.
	# Then PHPStorm can easily be made to keep working.

	echo "----- Using composer to generate full project source -----"

	
	BUILDROOT="${DRUPALROOT}/current"

	echo "--> configured
	PROJECTROOT-------:${PROJECTROOT}
	DRUPALROOT--------:${DRUPALROOT}
	BUILDROOT---------:${BUILDROOT}
	"

	echo "--> Creating source build destination ${BUILDROOT}"
	sudo rm -rf "${BUILDROOT}"
	mkdir -p "${BUILDROOT}"

	# Get ready for the composer build
	cp "${DRUPALROOT}/conf/composer.json" "${BUILDROOT}/composer.json"
	cp "${DRUPALROOT}/conf/composer.lock" "${BUILDROOT}/composer.lock"


	# BUild main Drupal
	echo "--> using composer to build full project source"
	(/usr/local/bin/composer --working-dir="${BUILDROOT}" --optimize-autoloader "${COMPOSER_COMMAND}")

	# Add in custom files

	####
	# It is better just to configure PHPstorm to know that the module code is in DRUPALROOT
	# instead of putting that code into current.  The code will be mapped into the right
	# place during docker build, and so isn't needed in current.
	####

	# Add project code and conf
	# echo "--> Adding in custom modules/themes"
	mkdir -p "${BUILDROOT}/web/modules/custom"
	# cp -R "${DRUPALROOT}/code/modules/custom" "${BUILDROOT}/web/modules/custom"
	mkdir -p "${BUILDROOT}/web/modules/custom"
	# cp -R "${DRUPALROOT}/code/themes/custom" "${BUILDROOT}/web/themes/custom"
	#ADD drupal/code/profiles/custom /app/web/profiles/custom
	#ADD drupal/code/libraries/custom /app/web/libraries/custom

	# Prepare for files (creating the folder now fixes file permissions when bound)
	mkdir -p "${BUILDROOT}/web/sites/default/files"

	# Drupal site settings [this overwrites files in the current, so it may be a bit better]
	echo "--> copying over Drupal settings into default site"
	#mkdir -p "${BUILDROOT}/web/sites/default"
	cp -R "${DRUPALROOT}/conf/services.yml" "${BUILDROOT}/web/sites/default/services.yml"
	cp -R "${DRUPALROOT}/conf/settings.php" "${BUILDROOT}/web/sites/default/settings.php"
	cp -R "${DRUPALROOT}/conf/settings.local.php" "${BUILDROOT}/web/sites/default/settings.local.php"
	# rm "${BUILDROOT}/web/sites/default/default.*"
	# rm "${BUILDROOT}/web/sites/example.*"

fi

##### BUILD SOURCE CODE IMAGE #################################################

if [ "${RUN_IMAGEBUILD}" = "yes" ];then

	echo "----- Building Docker image -----"

	# Put the Dockerfile in place
	echo "--> Temporarily copying Dockerfile to project root: ${PROJECTROOT}/.radi/tools/wundertools/Dockerfile => ${PROJECTROOT}/Dockerfile"
	cp "${PROJECTROOT}/.radi/tools/wundertools/Dockerfile" "${PROJECTROOT}/Dockerfile"

	# run the docker build
	echo "--> building docker image for source code [production safe]"
	(sudo docker build --tag "${IMAGENAME}" "${PROJECTROOT}")
	echo "--> image build: ${IMAGENAME}"

	# remove the temp Dockerfile position
	rm "${PROJECTROOT}/Dockerfile"

fi

##### PUSH IMAGE TO DOCKER REPOSITORY #########################################


if [ "${RUN_IMAGEPUSH}" = "yes" ];then

	echo "----- Pushing Docker image -----"

	echo ">> Logging into docker repository: ${DOCKERREPO}"
	sudo docker login "${DOCKERREPO}"

	# run the docker build
	(sudo docker push "${IMAGENAME}")
	echo "--> image pushed: ${IMAGENAME}"

fi

echo ">> Build is finished"
