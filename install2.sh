diskutil eraseDisk JHFS+ Mac\ hd /dev/disk0
diskutil apfs convert disk0
asr restore -s "/Volumes/m/monterey.dmg" -t "/Volumes/Mac hd" --erase --noverify --noprompt
Shutdown -r now