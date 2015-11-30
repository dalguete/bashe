# libashe
Basic library with functionality to be used by bash scripts, when arguments, options
and operations handling is required.

**libashe** tried to stand for **li**brary for **bash** used as bas**e**. Yeah, a
crappy name but the idea was to have something original, so there you go!

How to use it
=============

Inside any bash script you wanna deal with, source the libashe file. That will bring
all the power offered by libashe into your scripts.

Your script will only need to deal with basic stuff, like checking initialization
things in place, the load of other files/folders, etc. One basic starting point
can be this:

```
#!/usr/bin/env bash
#
# Script description.

<main function>() {
  ###################################
  # Start almost unnoticed subshell #
  ###################################
  # This is key, to let inner processes use the main function to get results.
  # This causes the whole processing to be run in an isolated new subshell,
  # avoiding pollute shell with vars, and second and most important giving the chance
  # for inner processes to directly call the main function with total confidence, knowing
  # that changes made there won't affect variables already set in a current call.
  # Without this, any inner main function call would override variables set in parent
  # call, possible producing undesirable results.
  (

  # Load libashe
  . /usr/lib/libashe/libashe

  # Load main modules (main functionality)
  _load "</path/to/main/modules/files/>*.sh"

  # Check any setting file, if required
  if [ -f <path/to/file/to/check> ]; then
    . <path/to/file/to/check>
  else
    die "<message to display on no file detected error>"
  fi

  # Arguments passed are consumed, and operation called, if any found
  consume "$@"

  ##########################################
  # Finish almost unnoticed subshell start #
  ##########################################
  )
}

# Call the main function with all params passed
<main function> "$@"
```

Available Functions
===================

Next are detailed all available functions you can use in your custom scripts.
It's encouraged for you to use prefixed function names, under a namespace-like
concept, to avoid collitions.


Ubuntu PPA
==========

You can find the package as a PPA here https://launchpad.net/~dalguete/+archive/ubuntu/libashe

Sidenote: About My Experience Creating Deb Packages Plus Ubuntu's PPA
---------------------------------------------------------------------

http://dalguete.github.io/#about-my-experiences-creating-deb-packages-plus-ubuntus-ppa

