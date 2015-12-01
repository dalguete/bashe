# Functionality for the get_operation_data function
#
# Arguments:
#  <name> <type>
#   Name of the operation to get the main info from
#   Type of data to get from a given operations. Options are:
#     - <Nothing>, gives the operation function name
#     - "short options", gives the operation short options set
#     - "long options", gives the operation long options set
#     - "usage", gives the operation usage function
#     - "consume", gives the operation consume function
#

# Used to register an operation
function _get_operation_data() {
  # Check at least a name is given
  if [ ! $# ]; then
    _die "No operation name passed to work with"
  fi

  # Check the operation is set
  local operation=$(echo "$1" | tr '-' '_')

  if [[ $(_is_option "operations" "$operation") == 0 ]]; then
    _die "Operation '$1' not recognized"
  fi

  # Get the operation data required
  local options=()
  case "$2" in
    "short options")
      options=($(_get_options "operation_${operation}_short_options"))
      [[ ${#options[@]} != 0 ]] && echo "${options[-1]}"
      ;;

    "long options")
      options=($(_get_options "operation_${operation}_long_options"))
      [[ ${#options[@]} != 0 ]] && echo "${options[-1]}"
      ;;

    "usage")
      options=($(_get_options "operation_${operation}_usage"))
      [[ ${#options[@]} != 0 ]] && echo "${options[-1]}"
      ;;

    "consume")
      options=($(_get_options "operation_${operation}_consume"))
      [[ ${#options[@]} != 0 ]] && echo "${options[-1]}"
      ;;

    *) # Operation Name
      echo $operation
      ;;
  esac  
}

