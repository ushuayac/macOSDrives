#!/bin/bash 


# macOS Installation and Elevated Security Removal Tool
# v2.1-beta
# https://github.com/nkerschner/macOSDrives

cd /
userQuit=0

# declare default paths
ASR_IMAGE_PATH="/Volumes/ASR/"
INSTALLER_VOLUME_PATH="/Volumes/FULL/Applications/"
ES_SOURCE_PATH="/Volumes/ASR/cat.dmg"
INTERNAL_VOLUME_NAME="Macintosh HD"
INTERNAL_VOLUME_PATH="/Volumes/Macintosh HD"


# Get the internal disk
get_internal_disk() {
    echo "==== detecting internal disks ===="
    INTERNAL_DISKS=($(diskutil list internal physical | awk '/^\/dev\// && !/disk[0-9]s[0-9]/ {print $1}'))

    if [ ${#INTERNAL_DISKS[@]} -eq 0 ]; then
        echo "No internal disks found! Exiting..."
        exit 1
    elif [ ${#INTERNAL_DISKS[@]} -eq 1 ]; then
        INTERNAL_DISK=${INTERNAL_DISKS[0]}
    else
        echo "Multiple internal disks detected:"
        for i in "${!INTERNAL_DISKS[@]}"; do
            echo "$((i+1)). ${INTERNAL_DISKS[i]}"
        done
        read -p "Select a disk number to format: " disk_choice
        while ! [[ "$disk_choice" =~ ^[1-${#INTERNAL_DISKS[@]}]$ ]]; do
            echo "Invalid selection. Choose a number between 1 and ${#INTERNAL_DISKS[@]}."
            read -p "Select a disk number to format: " disk_choice
        done
        INTERNAL_DISK=${INTERNAL_DISKS[disk_choice-1]}
    fi

    echo "Selected disk: $INTERNAL_DISK"
    echo
}


# Format the disk
format_disk() {
    echo "==== formatting disk ===="

    diskutil unmountDisk force "$INTERNAL_DISK"
    diskutil eraseDisk APFS "$INTERNAL_VOLUME_NAME" "$INTERNAL_DISK"

    echo ""
}

# Perform SMC reset and NVRAM clear
clear_smcnvram() {
    echo "==== resetting SMC and clearing NVRAM ===="
    pmset -a restoredefaults && nvram -c
    echo ""
}

# Check for an internet connection
check_internet() {
    echo "Checking for internet connection...."
    while ! ping -c 1 -t 5 1.1.1.1 >/dev/null 2>&1; do
        echo "No internet connection detected."
        read -n 1 -s -r -p "Please connect to the internet then press enter: "
    done
    echo "Internet connection detected."
    echo ""
}

# Perform ASR restore
run_asr_restore() {
    local source_image=$1
    if asr restore -s "$source_image" -t "$INTERNAL_VOLUME_PATH" --erase --noverify --noprompt; then
        echo "ASR restore successful. restarting..."
        restart_system
    else
        echo "ASR restore failed! Please check the source image and try again."
    fi
}

# Perform install through application
run_manual_install() {
    local installer_path="$1"

    clear_smcnvram

    echo "Starting manual install"
    "$INSTALLER_VOLUME_PATH$installer_path/Contents/Resources/startosinstall" --agreetolicense --volume "$INTERNAL_VOLUME_PATH"
}

# Elevated Security
elevated_security() {
    check_internet
    format_disk
    run_asr_restore "$ES_SOURCE_PATH"
}

# Check which files exist and build available options
build_available_options() {
    # Define all possible OS options
    declare -A all_asr_images
    all_asr_images[1]="sequoia.dmg"
    all_asr_images[2]="sonoma.dmg"
    all_asr_images[3]="ventura.dmg"
    all_asr_images[4]="monterey.dmg"
    all_asr_images[5]="bigsur.dmg"
    
    declare -A all_installers
    all_installers[1]="Install macOS Sequoia.app"
    all_installers[2]="Install macOS Sonoma.app"
    all_installers[3]="Install macOS Ventura.app"
    all_installers[4]="Install macOS Monterey.app"
    all_installers[5]="Install macOS Big Sur.app"
    all_installers[6]="Install macOS Catalina.app"
    all_installers[7]="Install macOS High Sierra.app"

    declare -A all_os_names
    all_os_names[1]="Sequoia"
    all_os_names[2]="Sonoma"
    all_os_names[3]="Ventura"
    all_os_names[4]="Monterey"
    all_os_names[5]="Big Sur"
    all_os_names[6]="Catalina"
    all_os_names[7]="High Sierra"

    # Clear existing arrays
    unset available_options
    unset asr_images
    unset installers
    unset os_names
    
    declare -g -A available_options
    declare -g -A asr_images
    declare -g -A installers
    declare -g -A os_names
    
    local option_counter=1
    
    # Check each OS option
    for original_key in {1..7}; do
        local has_asr=false
        local has_installer=false
        
        # Check if ASR image exists (only for options 1-5)
        if [[ $original_key -le 5 ]] && [[ -f "$ASR_IMAGE_PATH${all_asr_images[$original_key]}" ]]; then
            has_asr=true
        fi
        
        # Check if installer exists
        if [[ -d "$INSTALLER_VOLUME_PATH${all_installers[$original_key]}" ]]; then
            has_installer=true
        fi
        
        # If either method is available, add to available options
        if [[ "$has_asr" == true ]] || [[ "$has_installer" == true ]]; then
            available_options[$option_counter]=$original_key
            os_names[$option_counter]="${all_os_names[$original_key]}"
            
            if [[ "$has_asr" == true ]]; then
                asr_images[$option_counter]="${all_asr_images[$original_key]}"
            fi
            
            if [[ "$has_installer" == true ]]; then
                installers[$option_counter]="${all_installers[$original_key]}"
            fi
            
            ((option_counter++))
        fi
    done
    
    # Check if any options are available
    if [[ ${#available_options[@]} -eq 0 ]]; then
        echo "Error: No macOS installation files found!"
        echo "Please ensure ASR images are in: $ASR_IMAGE_PATH"
        echo "And/or installer applications are in: $INSTALLER_VOLUME_PATH"
        return 1
    fi
    
    return 0
}

# Prompt for OS selection
select_os() {
    echo 
    echo "Please choose your OS:"
    for key in $(echo ${!os_names[@]} | tr ' ' '\n' | sort -n); do
        echo "$key: ${os_names[$key]}"
    done
    read userOS
    
    while ! [[ "$userOS" =~ ^[1-${#os_names[@]}]$ ]]; do
        echo "Invalid selection. Please enter a number from 1 to ${#os_names[@]}."
        read userOS
    done
}

# Prompt for installation method
select_install_method() {
    local original_key=${available_options[$userOS]}
    local has_asr=false
    local has_installer=false
    
    # Check what methods are available for this OS
    if [[ -n "${asr_images[$userOS]}" ]]; then
        has_asr=true
    fi
    
    if [[ -n "${installers[$userOS]}" ]]; then
        has_installer=true
    fi
    
    if [[ "$has_asr" == true ]] && [[ "$has_installer" == true ]]; then
        echo
        echo "Choose installation method: 1. ASR 2. Installer Application"
        read userMethod
        while ! [[ "$userMethod" =~ ^[1-2]$ ]]; do
            echo "Invalid selection. Please enter 1 for ASR or 2 for Installer Application."
            read userMethod
        done
    elif [[ "$has_asr" == true ]]; then
        echo "Using ASR method (only method available for this OS)"
        userMethod=1
    elif [[ "$has_installer" == true ]]; then
        echo "Using Installer Application method (only method available for this OS)"
        userMethod=2
    else
        echo "Error: No installation method available for selected OS"
        return 1
    fi
}

# Install macOS
install_os() {
    # Build list of available options
    if ! build_available_options; then
        return 1
    fi

    select_os
    select_install_method

    format_disk

    echo "==== starting OS installation ===="    

    # Get the original key for the selected option
    local original_key=${available_options[$userOS]}

    # For Sequoia installation, check internet connection first
    if [[ "$original_key" == 1 ]]; then
        check_internet
    fi
    
    if [[ "$userMethod" == 1 ]]; then
        echo "${os_names[$userOS]} ASR install"
        run_asr_restore "$ASR_IMAGE_PATH${asr_images[$userOS]}"
    elif [[ "$userMethod" == 2 ]]; then
        echo "selected ${os_names[$userOS]} manual install"
        run_manual_install "${installers[$userOS]}"
    fi
}

# Restart system after resetting SMC and clearing NVRAM
restart_system() {
    echo "restarting..."
    clear_smcnvram
    reboot
    
    #try harder if didn't restart after 30 seconds
    sleep 30
    echo "Attempting restart again"
    reboot -q

    exit
}

# Quit the script
quit_script() {
    echo "Exiting script..."
    userQuit=1  # Ensures the loop in main_menu exits cleanly
}

# Main Menu Function
main_menu() {
    until [ "$userQuit" = 1 ]; do
        echo 
        echo "===== macOS Installation and Recovery Tool ====="
        echo "1. Elevated Security"
        echo "2. Install OS"
        echo "3. Restart System"
        echo "4. Reset SMC and Clear NVRAM"
        echo "5. Quit"
        echo "================================================"
        read -p "Enter your choice (1-5): " userinput

        case $userinput in
            1) elevated_security ;;
            2) install_os ;;
            3) restart_system ;;
            4) clear_smcnvram ;;
            5) quit_script ;;
            *) echo "Invalid choice. Please enter 1, 2, 3, or 4." ;;
        esac
    done
}

# Main
get_internal_disk
main_menu