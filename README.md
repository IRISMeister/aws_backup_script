# aws_backup_script

Inspired by  
https://aws.amazon.com/jp/blogs/compute/automating-the-creation-of-consistent-amazon-ebs-snapshots-with-amazon-ec2-systems-manager-part-1/

need shell scripts from this repo, too.  
https://github.com/IRISMeister/azure_backup_script.git

Make sure you have enabled O/S auth and have the matching IRIS user such as ubuntu.  
You need to install awscli if it's not.
```bash
sudo apt install awscli
```
You also need to configure aws cli if it's not.
```bash
aws configure
```

```bash
git clone https://github.com/IRISMeister/azure_backup_script.git
git clone https://github.com/IRISMeister/aws_backup_script.git
cd aws_backup_script/
cp ../azure_backup_script/*.sh .
chmod +x *.sh
./backup.sh
```