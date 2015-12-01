# Functionality for the is_option function
#

# Used to check is a given value is a stored item for a given key
function _is_option() {
  # Check a key is received
  if [ $# -lt 2 ]; then
    _die "Required options key storage to check value existence against"
  fi

  # Get the items passed
  local key=$(echo "$1" | tr '-' '_')

  # Get all the options for the give key
  local options=($(_get_options "$key"))

  # Check the value is set already
  local is=0;
  for item in "${options[@]}"; do
    if [[ "$item" == "$2" ]]; then
      is=1
      break;
    fi
  done

  echo $is
}
