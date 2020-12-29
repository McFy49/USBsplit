#!/bin/bash

for i in $*
do 
	# Unmounting the disk to get started
	echo "Starting by unmounting the usb drive you selectionned (in case the usb drive yet have been splitted, the script unmount it as well)
	sudo unmount /dev/$i /dev/$i\1 /dev/$i\2
	echo "Disk(s) Unmounted"

	# Formating the disk to avoid any problems
	sudo mkfs.ext4 /dev/$i
	echo "Formating the disk"

	# Declaration of the partitionning standard
	sudo parted -s /dev/$i mklabel msdos
	echo "Partitionning Standard set to MBR"

	# Creation of the two partitions
	# If you don't wanna split the Disk in exactly 2 half, change the percentage values
	sudo parted -s /dev/$i mkpart primary ext4 0% 50%
	sudo parted -s /dev/$i mkpart primary ext4 50% 100%
	echo "Creation of the 2 partition done"

	#Initialization of the filesystem
	sudo mke2fs -t ext4 /dev/$i\1
	sudo mke2fs -t ext4 /dev/$i\2
	echo "Initialization of the filesystem on each partition"

	# Creation of the mount point, in case they don't exist yet
	# If you want to mount the 2 partition to another mount point edit there: 
	sudo mkdir /media/disk1
	sudo mkdir /media/disk2
	echo "The mount points have been created"

	# Mounting the two partition on the mount point created the step above
	sudo mount -t ext4 /dev/$i\1 /media/disk1
	sudo mount -t ext4 /dev\$i\2 /media/disk2
	echo "Partitions of the disk mounted"

	# A quick check on if everything went well
	sudo parted -s /dev/$i print
	echo "Your USB drive have been partitionned in two half and mounted on two different mount moint"
done
