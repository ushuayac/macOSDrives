# WIP update

This update will align the drives to work with both Device Link and regular Mac processing. It will also include updates to allow us to install more recent OS versions.

Also planning on including installers for older macOS versions. Not sure if this will be needed.

Updates to the go.sh script:

- Make it cleaner
    
- Format the Macs drive to APFS and name it Macintosh HD
    - changed from Mac HD
    - Eliminates need to go into disk utility
 
- Checks if the USB is using the new partition scheme (listed below) or the legacy scheme
    
- Include options for launching installers from terminal in addition to ASR installation (in case ASR isn’t working)
    
- Include command to clear SMC and NVRAM and reboot at the end instead of just reboot
    
- Add auto reboot if ASR works
    
- Checks for internet before running ES or Sequoia ASR
    

Updates to cat boot

- ~~Installed Firefox because Chrome is no longer getting security updates~~ Firefox has issues with the keyboard in retest.us. Went back to using old version of Chrome, other option is to use Safari
    
- Considering [<ins>Stats</ins>](https://github.com/exelban/stats) instead of iStat Menus because it’s free and open source
    

## Drive set up

- Partition 1 : (~6.3GB) : El Capitan USB Installer - Use this to boot <=2012 devices
  - May not be necessary at all  
  - If an older OS install is needed, it might be better to run the installer application from recovery mode instead
    
- Partition 2 : (~14GB) : Big Sur USB Installer - Use this to boot <=2017 devices
    
- Partition 3 : (~16GB) : Sonoma USB Installer
    
- Partition 4 : (~18GB) : Sequoia USB Installer
    
- Partition 5 : Full OS Installers: 
  - Create a ~80-100GB partition named FULL of type APFS
  - After creating the FULL partition, create a directory named Applications within it.
  - Within the Applications directory download the following full macOS installer apps
    - ~El Capitan? (6.3GB)~ El Capitan isn’t compatible with APFS, so there’s no point in putting the installer in an APFS volume. Just having a bootable installer should be fine if we need it.
    
    - High Sierra? (~5.3GB)
    
    - Catalina (~8.3GB)
    
    - Big Sur (~12.5GB)
    
    - Monterey (~12.5GB)
    
    - Ventura (~12.5GB)
    
    - Sonoma (~13.7GB)
    
    - Sequoia (~14.5GB)
    
  - Create a directory named Scripts directory within the FULL partition
    
  - Put go.sh in the Scripts directory
    
- Partition 6 : ASR Images: (~125GB)
    
  - Create a partition named ASR of type MacOS Extended Journaled. Size of this partition is variable (based on the total size of your ASR images).
    
- Partition 7: Cat Boot / Test Boot : APFS partition with bootable Catalina for testing
    

## Script Breakdown

- Formats drive0 as APFS and names it Macintosh HD
    
- Gets input to determine ES, OS install, or reboot

- Checks for which version of the partition scheme is in use (Legacy or Device Link)
    
- ES uses ASR restore command to restore cat.dmg to Macintosh HD
    
- OS install gets input to determine OS version and install method
    
- ASR install will use ASR restore command to restore matching OS image to user input
    
- Manual install will run install application from FULL/Applications folder
    
- Manual install will reboot automatically
    
- ES and ASR OS will reboot automatically if ASR command is successful
    
- Reboot will reset SMC, clear NVRAM, then reboot
    

## Sequoia ASR install

### Run Script

1.  Boot to Sequoia installer. Other installers will probably work, but the Sequoia installer is recommended to ensure compatibility.
    
2.  Connect to WiFi or plug in ethernet
    
3.  Open the terminal
    
4.  Type sh /Volumes/FULL/Scripts/go2.sh
    
5.  Input 2 for install OS
    
6.  Input 1 for Sequoia
    
7.  Input 1 for ASR
    
8.  Once it completes, input 3 for reboot
    

### Set Startup Security to Full

9.  Log in to open account with the password “open”
    
10. Reboot to recovery mode by holding command + r when booting
    
11. Click Utilities > Startup Security Utility
    
12. Enter the password “open”
    
13. Set the security to Full security. You can leave allow booting to external media
    
14. Choose Macintosh HD as the boot drive
    

### Erase all contents and settings

15. Reboot into open account
    
16. Press command + spacebar
    
17. Type in Erase all contents and settings
    
18. Click on the settings option
    
19. Run erase all contents and settings
    
