#!/usr/bin/sh
# Tested working on OSX Mojave

__batt_yellow=$(tput setaf 184)
__batt_green=$( tput setaf 120)
__batt_red=$(   tput setaf 160)
__batt_reset="$(tput init)"

# I need to cut field-1 for this to trim evenly
# print the battery state with colors based on level
function __batt_state() {
  bstate=$(pmset -g batt | awk '/charging|discharging|charged/ {print $4}' | cut -f1 -d';')
  case "$bstate" in
    charged)
      echo "$__batt_green$bstate$__batt_reset"
      ;;
    charging)
      echo "$__batt_yellow$bstate$__batt_reset"
      ;;
    discharging)
      echo "$__batt_red$bstate$__batt_reset"
      ;;
    *)
      echo $bstate
      exit
  esac
}

function __batt_pct() {
  bpct=$(pmset -g batt | egrep '([0-9]+)%.*' -o | cut -f1 -d';')
  bpct=${bpct%?} # remove last char (%)
  if [[ $1 == "-n" ]] ; then
    echo "$bpct%"
  else
    case 1 in
      $(($bpct <= 15))) echo "$__batt_red$bpct%$__batt_reset" ;;
      $(($bpct <= 65))) echo "$__batt_yellow$bpct%$__batt_reset" ;;
                     *) echo "$__batt_green$bpct%$__batt_reset" ;;
    esac
  fi
}

# now, as a function, we can easily handle a conditional
function __batt_time() {
  btime=$(pmset -g batt | grep -Eo '([0-9][0-9]|[0-9]):[0-5][0-9]')
  btime=${btime:2}
  if [[ "$btime" == "0:00" ]]; then echo ''; else echo " [$btime]"; fi
}
