# radi WT wrapper

This is a radi init template that can be used to make an existing wundertools
project work with radi.

Using the template, you can add the needed files to any wundertools project,
and run a few commands to add the needed docker/radi infrastructure to use
radi right away.

## What is added

### a number of files used to configure radi

1. some base radi settings in .radi
2. a radi command `build` which is used as a replacement for the build.sh that
   wundertools provides, which builds a full source code docker image for the
   project.  This image could be used in production.

### some files usable by docker-compose

. docker-compose.yml which uses the source code image for local development.

### A radi build command

you can run `radi build` which will build a new source code image for the project.

## How to use it:

### 1. Install radi-cli (https://github.com/wunderkraut/radi-cli)

### 2. In any wundertools D8 project root, use the init.yml from this repository

run:

```
$/> radi local.project.create --project.create.source https://raw.githubusercontent.com/wunderkraut/radi-project-wundertoolswrapper/master/.radi/init.yml
```

This should add the needed files.

### 3. Change some settings

The only setting that needs assignment can be done by string replacing %PROJECT% 
across all of the added files with a string name for the project.

This will likey be automated next, but there are only a few instances, so it is usable
already.

