#!/bin/bash

file=""/usr/local/bin/tbox""
[ -f $file ] && sudo rm $file

sudo ln tbox.sh $file
