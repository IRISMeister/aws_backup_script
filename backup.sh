#!/bin/bash -e
# freezing IRIS DBs
./preScript.sh

#Do I want to do this?
#for target in $(findmnt -nlo TARGET -t ext4); do fsfreeze -f $target; done

instance=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
region=`curl -s 169.254.169.254/latest/meta-data/placement/availability-zone`
region=${region::-1}

# add --filter whatever you'd like
volumes=`aws ec2 describe-instance-attribute --instance-id $instance --attribute blockDeviceMapping --output text --query BlockDeviceMappings[*].Ebs.VolumeId --region $region`

# adding volume-id, tag(Name) to description would be nice...
for volume in $(echo $volumes | tr " " "\n")
  do aws ec2 create-snapshot --volume-id $volume --description 'Consistent snapshot of IRIS' --region $region > /dev/null 2>&1
done

#Do I want to do this?
#for target in $(findmnt -nlo TARGET -t ext4); do fsfreeze -u $target; done

# Thawing IRIS DBs
./postScript.sh
