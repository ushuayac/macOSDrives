# Current

## Drive set up

- Test Boot partition (APFS - 35GB)
    
- Sonoma installer
    
- Ventura installer
    
- Monterey installer
    
- Big Sur installer
    
- Catalina installer
    
- “e” partition
    
- Cat.dmg image (test boot for ES)
    
- go.sh script (ASR script with options for our ES image, big sur image, monterey image, and ventura image
    
- es.sh script for ES only
    
- “s” partition containing Sonoma image that doesn’t work
    
- “v” partition containing Ventura image
    
- “m” partition containing Monterey image
    
- “b” partition containing Big Sur image
    

## ES

1.  Boot to recovery mode
    
2.  Ensure connected to internet
    
3.  Open terminal
    
4.  Type:
    

sh /Volumes/e/go.sh

5.  Input 1 for elevated security
    
6.  Restart when completed
    

## OS Installation

1.  Boot to an installer (either to os you wish to install, or a previous version. Some techs prefer the big sur installer)
    
2.  Open terminal
    
3.  Type:
    

sh /Volumes/e/go.sh

4.  &nbsp;Input 2 for OS install
    
5.  Input option for OS you wish to install (sonoma doesn’t work)
    
6.  Restart when completed
    
18. Click on the settings option
    
19. Run erase all contents and settings
    
