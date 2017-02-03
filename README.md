# radi WT wrapper

This is a radi init template that can be used to make an existing wundertools
project work with radi.

Using the template, you can add the needed files to any wundertools project,
and run a few commands to add the needed docker/radi infrastructure to use
radi right away.

## What is added

### a number of files used to configure radi


1. standard docker local environment configuration:

   docker-compose.yml : compose file for a project

   drupal/Dockerfile : source code image build instructions

2. some base radi settings in .radi

    project.yml : project settings
    authorize.yml : pretty lenient permissions set
    commands.yml : common local project commands (plus an additional command mentioned below)

3. some radi commands for the new 'initialize' envirnment:

   `radi --environment=initialize build-source` : build source code without a db

   `radi --environment=initialize build-image` : build a source docker image

4. a radi command to use build.sh in a running project (requires db container is running)

   `radi build.sh -- <build.sh options here>` : run build.sh

5. some wundertools overrides:

   commands.radi-initialize.yml : define a command set used in the radi initialize environment

   site.radi.yml : local site settings for use with radi


## How to use it:

Before you try to use this, you will need to install the radi-cli (https://github.com/wunderkraut/radi-cli)

### Manually

Then you can simple follow these 2 steps:

#### 1. In any wundertools D8 project root, use the init.yml from this repository

run:

```
$/> radi local.project.create --project.create.source https://raw.githubusercontent.com/wunderkraut/radi-project-wundertoolswrapper/master/.radi/init.yml
```

This should add the needed files.

#### 2. Change some settings

The only setting that needs assignment can be done by string replacing %PROJECT% 
across all of the added files with a string name for the project.

This will likey be automated next, but there are only a few instances, so it is usable
already.

### Automatically

You can use our script installer directly to perform that above steps.

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/wunderkraut/radi-project-wundertoolswrapper/radify-script/.radi/tools/wundertools/radify.sh)"
```

This script is not necessary, it just tries to make things a bit easier.
