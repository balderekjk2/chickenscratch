#!/bin/bash

echo -n "keep descriptive comments? (y/n): "
read RES

case $RES in
  n)
    echo -n "discarding descriptive comments\n"
    awk '{ sub(/\|? *# .*$/, ""); print }' bash/example.bashrc >> ~/.bashrc
    awk '{ sub(/\|? *" [^\.]*$/, ""); print }' vim/example.vimrc >> ~/.vimrc
    ;;

  y)
    echo -n "keeping descriptive comments\n"
    cat bash/example.bashrc >> ~/.bashrc
    cat vim/example.vimrc >> ~/.vimrc
    ;;

  *)
    echo -n "no action taken\n"
    ;;
esac

echo -e "done\n"
