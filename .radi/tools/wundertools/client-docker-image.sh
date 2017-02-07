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
WunderTools -> Radi build handler
"

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/app/bin:/app/vendor/bin:/app/.composer/vendor/bin"

##### Interpret arguments #####################################################

sflag="-s"
for arg in "$@"
do
	case "$arg" in

	--run-buildsh)
		echo " -> ENABLING BUILD.SH RUN"
		RUN_BUILDSH="yes"
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

PROJECTROOT="${PROJECTROOT:-/app/project}"
[ -z "${DRUPALROOT}" ] && DRUPALROOT="${PROJECTROOT}/drupal"

RUN_BUILDSH="${RUN_BUILDSH:-no}"
RUN_IMAGEBUILD="${RUN_IMAGEBUILD:-yes}"
RUN_IMAGEPUSH="${RUN_IMAGEPUSH:-no}"

COMPOSER_COMMAND="${COMPOSER_COMMAND:-install}"

##### BUILD PROJECT SOURCE ####################################################

if [ "${RUN_BUILDSH}" = "yes" ]; then

	echo "----- Using build.sh generate full project source -----

Now using the drupal/build.sh to generate source.

Note that we have no need of generating source on the host, but we do 
so in order to give local developers access to source code for code editor
compatibility.

	"

	(
		cd "${DRUPALROOT}"
		./build.sh -c conf/site.radi.yml -o conf/commands.radi-initialize.yml new
	)

fi

##### BUILD SOURCE CODE IMAGE #################################################

if [ "${RUN_IMAGEBUILD}" = "yes" ];then

	echo "----- Building Docker image -----

This command will now build a local docker image for source code
using the Dockerfile in the drupal root

Image: ${IMAGENAME}


	"

	# run the docker build
	echo "--> building docker image for source code [production safe]"
	(sudo docker build --tag "${IMAGENAME}" "${DRUPALROOT}")
	echo "--> image build: ${IMAGENAME}"

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
