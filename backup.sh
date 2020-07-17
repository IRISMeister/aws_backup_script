#!/bin/bash -e
# freezing IRIS DBs
./preScript.sh

instance=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
region=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
region=${region::-1}

volumes=`aws ec2 describe-instance-attribute --instance-id $instance --attribute blockDeviceMapping --output text --query BlockDeviceMappings[*].Ebs.VolumeId --region $region`

for volume in $(echo $volumes | tr " " "\n")
do
  nametag=`aws ec2 describe-tags --filters "Name=resource-id,Values=$volume" --query Tags[0].Value`
  echo "nametag:"$nametag
  # Example to process only volumes which have following TAG. Otherwise all attached devices are processed.
  #    "Tags": [
  #      {
  #          "Key": "Name",
  #          "ResourceId": "vol-xxxxxxxxxxxxxxxx",
  #          "ResourceType": "volume",
  #          "Value": "Test-0001-data"
  #      }
  #  ]
  if [[ $nametag == *-data* ]];
  then
    device=`aws ec2 describe-volumes --volume-ids $volume --output text --query Volumes[0].Attachments[*].[Device] --region $region`
    echo $device
   # adding TAG, such as device:xvdc, for convinience (usefull when restoring).
    aws ec2 create-snapshot --volume-id $volume --description 'Consistent snapshot of IRIS on '$device --tag-specifications 'ResourceType=snapshot,Tags=[{Key=device,Value='$device'}]' --region $region > /dev/null 2>&1
  fi
done

# Thawing IRIS DBs
./postScript.sh
