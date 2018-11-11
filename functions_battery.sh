#!/usr/bin/sh

# I need to cut field-1 for this to trim evenly
function __batt_state() {
  bstate=$(pmset -g batt | awk '/charging|discharging|charged/ {print $4}' | cut -f1 -d';')
  yellow="$(printf '\033[33m')"
  green="$( printf '\033[32m')"
  red="$(   printf '\033[31m')"
  reset="$( printf '\033[00m')"
  crd='charged'
  crg='charging'
  dcg='discharging'
  case "$bstate" in
    charged)
      echo "$green$crd$reset"
      ;;
    charging)
      echo "$yellow$crg$reset"
      ;;
    discharging)
      echo "$red$dcg$reset"
      ;;
    *)
      echo $bstate
      exit
  esac
}

