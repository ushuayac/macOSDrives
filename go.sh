#!/bin/bash 
OFF = 0
until [ "$OFF" == 1 ]; do
	echo "Welcome! What would you like to do 1.Elevated Security 2.Install OS 3.Shutdown?" 
	read userinput
	if [ "$userinput" == 1 ]; then
		diskutil unmountDisk force /dev/disk0
		diskutil eraseDisk JHFS+ Mac\ hd /dev/disk0
		diskutil apfs convert disk0
		asr restore -s "/Volumes/e/cat.dmg" -t "/Volumes/Mac hd" --erase --noverify --noprompt
	elif [ "$userinput" == 2 ]; then
		echo "please choose your OS, 1. Sonoma 2. Ventura 3. Monterey 4.Big Sur" 
		read useros
		if [ "$useros" == 1 ]; then
		diskutil eraseDisk JHFS+ Mac\ hd /dev/disk0
		diskutil apfs convert disk0
		asr restore -s "/Volumes/s/sonoma.dmg" -t "/Volumes/Mac hd" --erase --noverify --noprompt
			echo 'process completed please shutdown computer!'
		elif [ "$useros" == 2 ]; then
		diskutil eraseDisk JHFS+ Mac\ hd /dev/disk0
		diskutil apfs convert disk0
		asr restore -s "/Volumes/v/ventura.dmg" -t "/Volumes/Mac hd" --erase --noverify --noprompt
			echo 'process completed please shutdown computer!'
		elif [ "$useros" == 3 ]; then
		diskutil eraseDisk JHFS+ Mac\ hd /dev/disk0
		diskutil apfs convert disk0
		asr restore -s "/Volumes/m/monterey.dmg" -t "/Volumes/Mac hd" --erase --noverify --noprompt
			echo 'process completed please shutdown computer!'
		elif [ "$useros" == 4 ]; then
		diskutil eraseDisk JHFS+ Mac\ hd /dev/disk0
		diskutil apfs convert disk0
		asr restore -s "/Volumes/b/bigsur.dmg" -t "/Volumes/Mac hd" --erase --noverify --noprompt
			echo 'process completed please shutdown computer!'
		else
			echo 'invalid choice, quitting'
			fi
	elif [ "$userinput" == 3 ]; then
	OFF = 1
	echo "Shutting down" 
	afplay /System/Library/Sounds/Funk.aiff
	shutdown -h now
	exit
	fi
done
exit


		
