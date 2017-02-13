# radi wrapper for Wundertools D8 Projects

This is a radi init template that can be used to make an existing wundertools
Drupal8 project work with radi.

Using the template, you can add the needed files to any wundertools project,
and run a few commands to get radi to provide commands to manage a local 
development environment.

**More details can be found in the [wiki](https://github.com/wunderkraut/radi-project-wundertoolswrapper/wiki)**

## How to use it:

Before you try to use this, you will need to install the radi-cli (https://github.com/wunderkraut/radi-cli)

### Automatically

You can use our script installer directly to perform that above steps.

This script can be found in this repo `.radi/tools/wundertools/radify.sh`

`https://raw.githubusercontent.com/wunderkraut/radi-project-wundertoolswrapper/master/.radi/tools/wundertools/radify.sh`

You can download that script to your project root, or just run it directly:

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/wunderkraut/radi-project-wundertoolswrapper/master/.radi/tools/wundertools/radify.sh)"
```

This script is not necessary, it just tries to make things a bit easier.  If 
you don't like running random internet scripts, take a look at out manual steps
desribed below.

### Manually

If you don't like the looks of that automatic method, you can manually perform
the automated steps.

Then you can simple follow these 2 steps:

#### 1. In any wundertools D8 project root, use the init.yml from this repository

run:

```
$/> radi local.project.create --project.create.source https://raw.githubusercontent.com/wunderkraut/radi-project-wundertoolswrapper/master/.radi/init.yml
```

This should add the needed files.

#### 2. Change some settings

The only setting that needs assignment can be done by string replacing 
%PROJECT% and %PORTBASE% across all of the added files with a string name for 
the project.

This will likey be automated next, but there are only a few instances, so it is
usable already.


---

More details can be found in the [wiki](https://github.com/wunderkraut/radi-project-wundertoolswrapper/wiki)
