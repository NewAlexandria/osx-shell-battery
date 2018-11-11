#!/usr/bin/sh
# Tested working on OSX Mojave

# I need to cut field-1 for this to trim evenly
# print the battery state with colors based on level
function __batt_state() {
  bstate=$(pmset -g batt | awk '/charging|discharging|charged/ {print $4}' | cut -f1 -d';')
  yellow=$(tput setaf 184)
  green=$( tput setaf 120)
  red=$(   tput setaf 160)
  reset="$(tput init)"
  case "$bstate" in
    charged)
      echo "$green$bstate$reset"
      ;;
    charging)
      echo "$yellow$bstate$reset"
      ;;
    discharging)
      echo "$red$bstate$reset"
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
      $(($bpct <= 15))) echo "$red$bpct%$reset" ;;
      $(($bpct <= 65))) echo "$yellow$bpct%$reset" ;;
                     *) echo "$green$bpct%$reset" ;;
    esac
  fi
}

# now, as a function, we can easily handle a conditional
function __batt_time() {
  btime=$(pmset -g batt | grep -Eo '([0-9][0-9]|[0-9]):[0-5][0-9]')
  btime=${btime:2}
  if [[ "$btime" == "0:00" ]]; then echo ''; else echo " [$btime]"; fi
}
