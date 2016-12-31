#!/bin/sh
# This script is designed to create a partition of ram to be
# used as the temp tablespace

sudo mkdir /mnt/ramdisk
sudo mount -t tempfs -o size=10240m /mnt/ramdisk
sudo chgrp dba /mnt/ramdisk

