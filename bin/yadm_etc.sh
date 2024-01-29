#!/usr/bin/env bash

listfile="$HOME/.config/yadm/tracked"
intermediate_dir="$HOME/.local/share/yadm/ext"

case "$1" in
  restore)
    readarray -t files < "$listfile"
    for file in "${files[@]}" ; do
      # split the path and perms
      IFS='%SEP%' read -ra split <<< "$file"
      path="${split[0]}"
      perms="${split[5]}" # what the fuck
      user="${split[10]}" # ftr the 'what the fuck' is "every char used in the seperator creates an empty array item"
      # translate to the weird name scheme for filenames
      flat_path="$(echo "$path" | sed "s/\//%SLASH%/g")"

      # check if valid
      if [[ -e "$intermediate_dir/$flat_path" ]] ; then
        sudo install -D -o "$user" -m "$perms" "$intermediate_dir/$flat_path" "$path"
      else
        echo "No saved copy of $path in $intermediate_dir!" >&2
      fi
    done
    ;;

  save)
    readarray -t files < "$listfile"

    # clean up clean up everybody sing the song
    rm -r "$intermediate_dir"
    mkdir "$intermediate_dir"

    for file in "${files[@]}" ; do
      IFS='%SEP%' read -ra split <<< "$file"
      path="${split[0]}"

      # muss up the slashes so the file is named the whole path. prevents name collision ig.
      flat_path="$(echo "$path" | sed "s/\//%SLASH%/g")"

      cp "$path" "$intermediate_dir/$flat_path"
    done
    ;;

    add)
      find "$2" -printf "%p%%SEP%%%m%%SEP%%%u\n" >> "$listfile"
      echo "Tracked $2"
      ;;

    list)
      sed "s/%SEP%/ /g" "$HOME/.config/yadm/tracked"
      ;;

    *)
      echo "Args need to be restore, save, list, or add [path]" >&2
      ;;

    esac
