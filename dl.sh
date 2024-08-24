#!/bin/bash

source ./dl_utils.sh

if [[ $1 == "help" ]]; then
  echo ".dl.sh name_of_donwload type_of_download link_or_txt_file"
  exit 1
fi

remove_conf
remove_empty_session

if [[ -z "$1" ]]; then
  list_sessions
  read_session
else
  new_session $1 $2 $3
fi

aria2c



