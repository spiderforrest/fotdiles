#!/usr/bin/env bash

listfile="$HOME/.config/yadm/tracked"
intermediate_dir="$HOME/.local/share/yadm/ext"

case "$1" in

  restore)

    readarray -t files < "$listfile"
    if [[ -z "$2" ]] ; then # take arg for single file or do all

      for file in "${files[@]}" ; do
        # split the path and perms
        IFS='%SEP%' read -ra split <<< "$file"
        path=${split[0]}
        perms="${split[5]}" # what the fuck

        # translate to the weird name scheme for filenames
        flat_path="$(echo "$path" | sed "s/\//%SLASH%/g")"

        sudo cp "$intermediate_dir/$flat_path" "$path"
        sudo chmod "$perms" "$path"

      done
    else
      hit=false
      for file in "${files[@]}" ; do
        # split the path and perms
        IFS='%SEP%' read -ra split <<< "$file"
        path="${split[0]}"
        perms="${split[5]}" # what the fuck
        # translate to the weird name scheme for filenames
        flat_path="$(echo "$path" | sed "s/\//%SLASH%/g")"

        # check if valid
        if [[ "$path" == "$2" && -e "$intermediate_dir/$flat_path" ]] ; then

          hit=true
          sudo cp "$intermediate_dir/$flat_path" "$path"
          sudo chmod "$perms" "$path"
        fi
      done

      if ! $hit ; then
        echo "File not matched!" >&2
      fi
    fi
    ;;

  save)
    readarray -t files < "$listfile"

    # clean up clean up everybody sing the song
    rm -r "$intermediate_dir"
    mkdir "$intermediate_dir"

    for file in "${files[@]}" ; do
      IFS='%SEP%' read -ra split <<< "$file"
      path="${split[0]}"

      flat_path="$(echo "$path" | sed "s/\//%SLASH%/g")"

      cp "$path" "$intermediate_dir/$flat_path"

    done
    ;;

  add)
    find "$2" -printf "%p%%SEP%%%m\n" >> "$listfile" && echo "Tracked $2"
    ;;

  list)
    sed "s/%SEP%/ /g" .config/yadm/tracked
    ;;
  *)
    echo "Args need to be restore, save, list, or add [path]" >&2
    ;;

  esac
