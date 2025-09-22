#!/bin/bash

echo "Enter the user and IP of your BEAD Host (e.g. example@127.0.0.1): "
read BEAD_HOST

if scp -o StrictHostKeyChecking=no -r $BEAD_HOST:~/Desktop/Bead\ Agent /Users/shared/; then
    echo "successfully copied Bead Agent files"
else
    echo "exiting"
    exit 1
fi

open -a "Bead Agent"



echo "Once finished with diagnostic testing, type y to remove the files"
read removeFiles
while [ "$removeFiles" != "y" ]; do
    echo "Once finished with diagnostic testing, type y to remove the files"
done
rm -rf "/Users/Shared/Bead Agent"

