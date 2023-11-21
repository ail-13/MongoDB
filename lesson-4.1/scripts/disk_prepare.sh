#!/bin/bash
set -e

sudo mkfs.xfs -f /dev/disk/by-id/google-mongo-disk
sudo mkdir /db
sudo mount /dev/disk/by-id/google-mongo-disk /db
echo '/dev/disk/by-id/google-mongo-disk /db xfs defaults 0 2' | sudo tee -a /etc/fstab
