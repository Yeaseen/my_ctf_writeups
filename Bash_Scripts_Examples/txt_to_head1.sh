#!/bin/bash

# This is one of many ways to solve the problem. Your solution may be different.
# Notice the use of quotes to allow filenames with space in them. 

recursive_name_change()
{
	cd "$1"

# use * to get all files and directories in the current directory instead of `ls`. 
#You will face problems with filenames containing whitespaces if use ls
#similarly, you can get list of all .txt files in the current directory by simply writing *.txt

	for i in *  
	do
		if [ -d "$i" ]
		then
			recursive_name_change "$i"
		elif [ "${i##*.}" = "txt" ]       #Extracting the extension from filename
		then
		    x=`head -1 $i`
			new_name=$x"."${i##*.}
			mv "$i" "$new_name"
		fi
	done
	cd ../
}

recursive_name_change .


# Try the same problem using pushd and popd instead of explicit recursive function.
