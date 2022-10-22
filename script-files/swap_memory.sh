set -x 
vol=$1
mount_name=$2
echo $var
newvol=$(echo $vol | tr -d -)
echo $newvol
echo $mount_name
device_name=$(lsblk -o +SERIAL | grep $newvol | cut -d " " -f1)
echo $device_name
echo 'Creating swap'
sudo fdisk -l /dev/$device_name
sudo mkswap -L swap /dev/$device_name
sudo swapon /dev/$device_name
uuid=`lsblk -o +UUID | grep $device_name | awk -F " " '{print $NF}'`
sudo su - -c 'echo UUID="'"$uuid"'" none swap defaults 0 0 | tee -a >> /etc/fstab'
swapon --show
