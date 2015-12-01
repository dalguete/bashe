# libashe
Basic library with functionality to be used by bash scripts, when arguments, options
and operations handling is required.

**libashe** tried to stand for **li**brary for **bash** used as bas**e**. Yeah, a
crappy name but the idea was to have something original, so there you go!

How to use it
=============

The idea is to use this as a helper, so you can define your custom script solution
using operations, arguments and options, short and long, no worries.

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

  # Load operation modules (main functionality)
  _load "</path/to/main/modules/files/>*.sh"

  # Check any setting file, if required
  if [ -f <path/to/file/to/check> ]; then
    . <path/to/file/to/check>
  else
    _die "<message to display on no file detected error>"
  fi

  # Arguments passed are consumed, and operation called, if any found
  _consume "$@"

  ##########################################
  # Finish almost unnoticed subshell start #
  ##########################################
  )
}

# Call the main function with all params passed
<main function> "$@"
```

Explaining things a bit:

* **\<main function\>**: Name of the script's main function. Be sure to not collide
  with an already existing one. Functions prefixed with a single '\_' are libashe reserved.
  However more than one '\_' has no restriction.

* **\</path/to/main/modules/files/\>**: Path where all operation scripts live.

* **\<path/to/file/to/check\>**: Just an example on how a check would be done in
  case a file needs to exist prior execution. The whole logic can change to adapt
  to custom requirements. The idea is nothing will run is at least these min reqs
  are satisfied. If so the **\<message to display on no file detected error\>** will be displayed.

As can be seen, `_consume` is the main part of all. To know how to deal with that guy,
check the next section

Per Operation Script
--------------------

These are the scripts that will actually do the job. In the main script they will
be loaded in the part `_load "</path/to/main/modules/files/>*.sh"`

Their definition will go like this:

```
# Functionality for the <operation name> operation
_set_operation "<operation name>" "<short options>" "<long options>"

# Function used to display operation usage
function <operation name>_usage() {
  _die "Usage this operation like this"
}

# Function used to consume operation passed options
function <operation name>_consume() {
  # Process all input data. Only valid entries will live here. Non valid ones are
  # filtered in the main consume process.
  while [ $# -gt 0 ]
  do
    case "$1" in
      -o|--option) # Indicates the option <- JUST AN EXAMPLE
        _set_option "option" "$2"
        shift
        ;;
    esac

    shift
  done
}

# Actual implementation of operation.
function <operation name>() {
  # All options registered can be accessed using _get_option and the key passed.
  # In the example, it'd be "option"
  # Arguments are stored in an array called ARGS
}

```

Explaining things a bit:

* **\<operation name\>**: Name of the operation to implement. Be sure to not collide
  with an already existing one. Functions prefixed with a single '_' are libashe reserved.
  However more than one '_' has no restriction.

* **\<short options\>**: List of `getopt` short options available for the given operation.
  Format can be something like "abc:d::e" (more on `getopt`, http://man7.org/linux/man-pages/man1/getopt.1.html)

* **\<long options\>**: List of `getopt` long options available for the given operation.
  Format can be something like "airplane,boat,coconut:discovery::enjoy" (more on `getopt`, http://man7.org/linux/man-pages/man1/getopt.1.html)

* **`set_operation` function call**: When the script will be loaded, info about the
  operation will be registered in the whole solution (name and supported options).

* **\<operation name\>_usage function**: When an invalid option is found, this function
  will be called to display operation usage information.

* **\<operation name\>_consume function**: Function used to consume all options
  passed. The function `_set_option` is there to help on that task. Arguments can
  be consumed too, but they are handled by default by libashe so you won't have
  to worry about them.

* **\<operation name\> function**: Actual place where the operation processing happens.
  Options can be checked with `_get_option` function, and arguments using the ARGS
  array.

These per operation scripts can happen as many times as operations required for the
custom solution being implemented.

Examples
--------

Check the [e9ter](https://github.com/dalguete/eater) project

Available Functions
===================

Next are detailed all available functions you can use in your custom scripts.
Remember, function prefixed with one '_' are libashe reserved. However more than one
'_' has no restriction.

* _consume
* _crossos
* _die
* _get_operation_data
* _set_operation
* _get_last_option
* _get_options
* _is_option
* _remove_option
* _reset_options
* _set_option
* _remove_duplicates_array
* _reverse_array
* _status
* _yaml_parser


Ubuntu PPA
==========

You can find the package as a PPA here https://launchpad.net/~dalguete/+archive/ubuntu/libashe

Sidenote: About My Experience Creating Deb Packages Plus Ubuntu's PPA
---------------------------------------------------------------------

http://dalguete.github.io/#about-my-experiences-creating-deb-packages-plus-ubuntus-ppa

