#!/bin/bash

replace_link() {
  if [[ ! -f "${HOME}/.aria2/sessions/${1}.session" ]]; then
    touch "${HOME}/.aria2/sessions/${1}.session"
  fi

  echo $2 > "${HOME}/.aria2/sessions/${1}.session"
}

replace_file() {
  if [[ ! -f "${HOME}/.aria2/sessions/${1}.session" ]]; then
    touch "${HOME}/.aria2/sessions/${1}.session"
  fi
  mv "$2" "${2}.unsorted"
  python3 "${HOME}/Programming/scripts/sort.py" $2
  cp $2 "${HOME}/.aria2/sessions/${1}.session"
  rm "${2}.unsorted"
}

remove_conf() {
  if [[ -f "${HOME}/.config/aria2/aria2.conf" ]]; then
    rm ${HOME}/.config/aria2/aria2.conf
  fi
}

make_conf() {
  touch ${HOME}/.config/aria2/aria2.conf
  cp ${HOME}/.config/aria2/aria2.conf.template ${HOME}/.config/aria2/aria2.conf
  sed -i "s|<DONWLOADDIR>|$1|g" ${HOME}/.config/aria2/aria2.conf
  sed -i "s|<SESSIONFILE>|$2|g" ${HOME}/.config/aria2/aria2.conf
  file_name="${2}"
  dir_name=${file_name/sessions/dirs}
  echo "$1" > "${dir_name}.dir"
}

remove_empty_session() {
  dirfiles=$(ls -A $HOME/.aria2/sessions)
  if [[ ! -z "$dirfiles" ]]; then
    files_in_dir=($HOME/.aria2/sessions/*)
    for key in "${!files_in_dir[@]}"
    do
      if [[ -f "${files_in_dir[$key]}" && $(stat -c %s "${files_in_dir[$key]}") -eq 0 ]]; then
        rm ${files_in_dir[$key]}
        file_name="${files_in_dir[$key]}"
        dir_name=${file_name/sessions/dirs}
        rm "${dir_name}.dir"
      fi
    done
  fi
}

list_sessions() {
  dirfiles=$(ls -A $HOME/.aria2/sessions)
  if [[ ! -z "$dirfiles" ]]; then
    files_in_dir=($HOME/.aria2/sessions/*)
    for key in "${!files_in_dir[@]}"
    do
      echo "$key ${files_in_dir[$key]}"
    done
  fi
}

read_session() {
  dirfiles=$(ls -A $HOME/.aria2/sessions)
  if [[ ! -z "$dirfiles" ]]; then
    files_in_dir=($HOME/.aria2/sessions/*)
    read -p "Enter what to resume: " file
    if [[ ! -z "$files_in_dir[$file]" ]]; then
     file_name="${files_in_dir[$file]}"
     dir_name=${file_name/sessions/dirs}
     downloaddir=$(cat "${dir_name}.dir")
     make_conf $downloaddir "${files_in_dir[$file]}"
    fi
  fi
}

new_session() {
  downloaddir=""
  filename=$1
  dir=$2
  downlink=$3
  downloaddir="${HOME}/Downloads"
  sessionfile=""

  if [[ "$dir" == "m" ]]; then
    downloaddir="${HOME}/Videos/Movies/${filename}"
  elif [[ "$dir" == "a" ]]; then
    downloaddir="${HOME}/Videos/Anime/${filename}"
  elif [[ "$dir" == "s" ]]; then
    downloaddir="${HOME}/Videos/Series/${filename}"
  else
    downloaddir="${HOME}/Downloads/${filename}"
  fi


  if [[ $downlink == *.txt ]]; then
    replace_file $filename $downlink
  else
    replace_link $filename $downlink
  fi

  sessionfile="${HOME}/.aria2/sessions/${filename}.session"

  make_conf $downloaddir $sessionfile
}
