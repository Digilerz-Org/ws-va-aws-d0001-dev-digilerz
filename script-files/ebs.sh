set -x 
vol=$1
mount_name=$2
echo $var
newvol=$(echo $vol | tr -d -)
echo $newvol
echo $mount_name
device_name=$(lsblk -o +SERIAL | grep $newvol | cut -d " " -f1)
echo $device_name
isdevExits=$(cat /proc/mounts|grep -c ${device_name})
echo isdevExits
if [ $isdevExits -eq 0 ]; then
   echo "Please mount the Volume"
   sudo mkdir -p /$mount_name
   sudo lsblk -f
   sudo file -s /dev/$device_name
   sudo mkfs -t xfs /dev/$device_name
   sudo file -s /dev/$device_name
   sudo mount /dev/$device_name /$mount_name
   uuid=`lsblk -o +UUID | grep $device_name | awk -F " " '{print $NF}'`
   sudo su - -c 'echo UUID="'"$uuid"'" '"/$mount_name"'  xfs  defaults,nofail  0  2 | tee -a >> /etc/fstab'
   df -h
else
   echo "Device is exists"
   df -h
fi
