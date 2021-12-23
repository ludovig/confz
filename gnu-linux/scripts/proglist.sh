#!/bin/sh
#
#

outfile="./proglist"

for dir in `echo $PATH | tr ':' ' '`
do
	cd "$dir"

	for file in *
	do
			if [ -x "$file" -a ! -d "$file" ]
			then
				echo $file
			fi
	done

done | sort > $outfile
