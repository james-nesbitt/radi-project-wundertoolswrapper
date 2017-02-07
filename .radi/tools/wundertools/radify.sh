#!/bin/bash
#
# WUNDERTOOLS : RADIFY
#
# This is a shell script that is meant to be used to convert an existing 
# Wundertools D8 project into a radi compatible project.
#
# The process is meant to be non-destructive, and introduct minimal 
# changes to the project source code.
#
# This script should be run in the root of a wundertools project.
#

# override the init_paths using cmd line variable
[ -z "${INIT_PATHS}" ] && INIT_PATHS="https://raw.githubusercontent.com/wunderkraut/radi-project-wundertoolswrapper/master/.radi/init.yml"

echo "##### RADIFY YOUR WUNDERTOOLS #####

You are about to run a script that will add radi configuration and aids into 
your existing project.

This process is meant to radify an existing WUNDERTOOLS D8 project, with no 
modifications to the actual project.  This script is however not very 
sophisticated, so there is a chance that it will overwrite an existing file.

#### How it works:

The process is primarily template driven.

The script will download some templates into your project, and ask some 
questions. The answers to the questions asked may modify which templates are 
used, but they are primarily used to provide string substitutions for the 
templates, and to allow you to control what actions the script will take.

This script should have been run/downloaded as: 
  https://github.com/wunderkraut/radi-project-wundertoolswrapper/blob/master/.radi/tools/wundertools/radify.sh

#### Running radification

We will now start the script

Shall we proceed? (y/N)
"
read YNPROCEED
case "$YNPROCEED" in
    [Yy]* )

		echo " "
		echo "Proceeding --->"
		echo " "

		;;
    *)
		echo " "
		echo "Aborting "
		echo " "
		exit 1	
esac

### Some utility functions



### STARTING radification

echo "##### Initial questions 

Now we will ask a few questions to preconfigure the process

"

if [ -z "${PROJECT}" ]; then
	echo "What is a good machine name for your project?

	   This should be a lowercase string (no spaces numbers or symbols)

	   This will be used as a template substitution variable, which will populate
	   files used to configure radi for the project.  The result will also impact
	   the docker-compose file, which will mean that all networks, volumes and 
	   containers may contain this string as a root key value.
	   "
	read PROJECT 

	echo " "
fi

echo "##### Processing init templates

In this stage we will use one or more radi initialization templates to add files 
to your project.
We will download each template to a temporary file on your host, process it, and
then run it.

The current templates being 
considered are: 
${INIT_PATHS}

"

for INITURL in $INIT_PATHS; do

	TMPFILE="`mktemp`"

	echo "INIT> ${INITURL} [temporarily in : ${TMPFILE}"

	curl -s -o "${TMPFILE}" "${INITURL}"

	echo "  --> replacing Project template variable"
	sed -i -e "s/\%PROJECT\%/${PROJECT}/g" "${TMPFILE}"

	echo "  --> Running template init:"
	radi local.project.create --project.create.source "${TMPFILE}"

	rm "${TMPFILE}"

done

echo " 

Intialization complete

##### Finalization

Now that the project initialization is complete, you should be able to run radi'
as a command line tool anywhere inside your project.

The first steps that you should perform, in order to be able to start using the
the tool, are to perform the source code image build.
You can do this at anytime using the build command (see .radi/commands.yml)

$/> radi build

The build creates a docker image with source code in it, that can be used in
production, but can also be used locally with local source code bound in place.

"

echo "Would you like me to run the initial image build (probably 5 minutes build time)? (y/N)"
read YNBUILD
case "$YNBUILD" in
    [Yy]* )

		echo " "
		echo "Running build --->"
		echo " "

		(
			radi --environment=initialize initialize
			radi --environment=initialize build-image
		)

		;;
esac
