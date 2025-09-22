#!/bin/bash

get_bead_host() {
    echo "Enter the user and IP of your BEAD Host (e.g. example@127.0.0.1): "
    read BEAD_HOST
}

copy_agent_from_host() {
    if scp -o StrictHostKeyChecking=no -r $BEAD_HOST:~/Desktop/Bead\ Agent /Users/shared/; then
        echo "successfully copied Bead Agent files"
    else
        echo "exiting"
        exit 1
    fi
}

open_agent() {
    open -a "Bead Agent"
}

clean_up() {
    echo "Once finished with diagnostic testing, type y to remove the files"
    read removeFiles
    while [ "$removeFiles" != "y" ]; do
        echo "Once finished with diagnostic testing, type y to remove the files"
    done
    rm -rf "/Users/Shared/Bead Agent"
}

# Main
get_bead_host
copy_agent_from_host
open_agent
clean_up
