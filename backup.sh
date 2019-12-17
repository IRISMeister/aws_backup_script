#!/bin/bash -e
# freezing IRIS DBs
./preScript.sh

instance=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
region=`curl -s 169.254.169.254/latest/meta-data/placement/availability-zone`
region=${region::-1}

# add --filter whatever you'd like, otherwise you will get all volumes this instance is attaching.
# ex) --filters "Name=tag-key,Values=Backup" "Name=tag-value,Values=1"
volumes=`aws ec2 describe-instance-attribute --instance-id $instance --attribute blockDeviceMapping --output text --query BlockDeviceMappings[*].Ebs.VolumeId --region $region`

# adding volume-id, tag(Name) to description would be nice for later use (restore).
for volume in $(echo $volumes | tr " " "\n")
  # expecting only one device here
do 
  device=`aws ec2 describe-volumes --volume-ids $volume --output text --query Volumes[0].Attachments[*].[Device] --region $region`
  aws ec2 create-snapshot --volume-id $volume --description 'Consistent snapshot of IRIS on '$device --tag-specifications 'ResourceType=snapshot,Tags=[{Key=device,Value='$device'}]' --region $region > /dev/null 2>&1
done

# Thawing IRIS DBs
./postScript.sh
