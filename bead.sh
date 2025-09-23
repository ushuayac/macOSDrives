#!/bin/bash
mount_usb() {
    diskutil mount $(diskutil list | grep -i blancco | awk '{print $NF}')
}

eject_usb() {
    diskutil eject /Volumes/BLANCCO
}

copy_agent_from_usb() {
    if cp -R "/Volumes/BLANCCO/BEAD Agent" /Users/Shared/; then
        echo "successfully copied BEAD Agent files"
    else
    echo "Could not copy necessary files. Exiting..."
        exit 1
    fi
}

get_bead_host() {
    read -p "Enter the user and IP of your BEAD Host (e.g. example@127.0.0.1): " BEAD_HOST
}

copy_agent_from_host() {
    if scp -o StrictHostKeyChecking=no -r $BEAD_HOST:~/Desktop/Bead\ Agent /Users/shared/; then
        echo "successfully copied BEAD Agent files"
    else
        echo "Could not copy necessary files. Exiting..."
        exit 1
    fi
}

open_agent() {
    echo "Opening BEAD Agent"
    if ! [ open -a "BEAD Agent" ]; then
        echo "Failed to open BEAD Agent, trying again in 5 seconds"
        sleep 5
        open -a "BEAD Agent"
    fi
}

clean_up() {
    read -p "Once finished with diagnostic testing, press enter to remove the files: " removeFiles
    rm -rf "/Users/Shared/Bead Agent"
}


# Main
if mount_usb; then
    copy_agent_from_usb
    eject_usb
else
    get_bead_host
    copy_agent_from_host
fi

open_agent
clean_up
