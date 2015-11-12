#!/bin/bash

errors_found=0

if [ -z ${REPO} ] || [ -z ${VERSION} ]; then
	echo "Something is missing either REPO or VERSION";
	exit 1
fi

for dfile in $(git diff --name-status ${VERSION}..$(git rev-parse HEAD | cut -c 1-7) | grep Dockerfile | grep -E '^(A|M|R){1}.*$' | awk '{ print $2 }'); do 
	if ! [ -f $dfile ]; then
		exit 1
	fi
	echo " ===== [ CHECKING $dfile ] ===== "; 
	dockerlint $dfile; 
	if [ $? -ne 0 ]; then 
		echo " ----- [ FINISHED IN ERROR ] ----- "; 
		errors_found=1
	fi; 
	echo ""; 
done

exit $errors_found


