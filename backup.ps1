# freezing IRIS DBs
Start-Process -Wait preScript.bat

$result = curl http://169.254.169.254/latest/meta-data/instance-id
$instance=$result[0].Content
$result = curl http://169.254.169.254/latest/meta-data/placement/availability-zone
$region=$result[0].Content
$region.Substring(0,$region.Length-1)

$volumes=aws ec2 describe-instance-attribute --instance-id $instance --attribute blockDeviceMapping --query BlockDeviceMappings[*].Ebs.VolumeId --region $region | ConvertFrom-Json

foreach($volume in $volumes) { 
    $nametag=aws ec2 describe-tags --filters "Name=resource-id,Values=$volume" --query Tags[0].Value
    Write-Host "nametag:"$nametag
  
    if ($nametag -like "*-data*") {
        $device=aws ec2 describe-volumes --volume-ids $volume --output text --query Volumes[0].Attachments[*].[Device] --region $region
        echo $device
        aws ec2 create-snapshot --volume-id $volume --description "Consistent snapshot of IRIS on $device" --tag-specifications "ResourceType=snapshot,Tags=[{Key=device,Value='$device'}]" --region $region 2>&1>$null
    }    
}

# Thawing IRIS DBs
Start-Process -Wait postScript.bat