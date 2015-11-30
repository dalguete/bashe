# libashe
Basic library with functionality to be used by bash scripts, when arguments, options
and operations handling is required.

**libashe** tried to stand for **li**brary for **bash** used as bas**e**. Yeah, a
crappy name but the idea was to have something original, so there you go!

How to use it
=============

The idea with is to use this as a helper, so you can define your custom script solution
using operations, arguments adn options, short and long, no worries.

There are two important parts: 1) main script and 2) per operation script.

Main Script
-----------

Main structure that will source the libashe file. That will bring all the power
offered by libashe into your script and operation ones.

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

As can be seen, `consume` is the main part of all. To know how to deal with that guy,
check the next section

Per Operation Script
--------------------

These are the scripts that will actually do the job. In the main script they will
be loaded in the part `_load "</path/to/main/modules/files/>*.sh"`

Their defintion will go like this:

```
# Functionality for the <operation name> operation
set_operation "<operation name>" "<short options>" "<long options>"

# Function used to display operation usage
function <operation name>_usage() {
  die "Usage this operation like this"
}

# Function used to consume operation passed options
function <operation name>_consume() {
  # Process all input data. Only valid entries will live here. Non valid ones are
  # filtered in the main consume process.
  while [ $# -gt 0 ]
  do
    case "$1" in
      -o|--option) # Indicates the option <- JUST AN EXAMPLE
        set_option "option" "$2"
        shift
        ;;
    esac

    shift
  done
}

# Actual implementation of operation.
function <operation name>() {
  # All options registered can be accessed using get_option and the key passed.
  # In the example, it'd be "option"
  # Arguments are stored in an array called ARGS
}

```

Explaining things a bit:

* **\<operation name\>**: Name of the operation to implement. Be sure to not collide
  with an already existing one nor prefixed 'libashe_'

* **\<short options\>**: List of `getopt` short options available for the given operation.
  Format can be something like "abc:d::e" (more on `getopt`, http://man7.org/linux/man-pages/man1/getopt.1.html)

* **\<long options\>**: List of `getopt` long options available for the given operation.
  Format can be something like "airplane,boat,coconut:discovery::enjoy" (more on `getopt`, http://man7.org/linux/man-pages/man1/getopt.1.html)

These per operation scripts can happen as many times as operations required for the
custom solution being implemented.

Available Functions
===================

Next are detailed all available functions you can use in your custom scripts.
It's encouraged for you to use prefixed function names, under a namespace-like
concept, to avoid collitions.

* consume
* crossos
* die
* get_operation_data
* set_operation
* get_last_option
* get_options
* is_option
* remove_option
* reset_options
* set_option
* remove_duplicates_array
* reverse_array
* status
* yaml_parser


Ubuntu PPA
==========

You can find the package as a PPA here https://launchpad.net/~dalguete/+archive/ubuntu/libashe

Sidenote: About My Experience Creating Deb Packages Plus Ubuntu's PPA
---------------------------------------------------------------------

http://dalguete.github.io/#about-my-experiences-creating-deb-packages-plus-ubuntus-ppa

