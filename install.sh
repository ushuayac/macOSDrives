diskutil eraseDisk JHFS+ Mac\ hd /dev/disk0
diskutil apfs convert disk0
asr restore -s "/Volumes/v/ventura.dmg" -t "/Volumes/Mac hd" --erase --noverify --noprompt
Shutdown -r now