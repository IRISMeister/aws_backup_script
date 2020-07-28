# aws_backup_script

Inspired by  
https://aws.amazon.com/jp/blogs/compute/automating-the-creation-of-consistent-amazon-ebs-snapshots-with-amazon-ec2-systems-manager-part-1/  
Needs shell scripts from this repo, too.  
https://github.com/IRISMeister/azure_backup_script.git

## Prerequisite

1. Create a new role which has AmazonEC2FullAccess policy.
Or create a (less privileged) new policy like this and assign it to the role.
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "ec2:CreateSnapshot",
        "ec2:DeleteSnapshot"
      ],
      "Resource": "*"
    }
  ]
}
```

2. Assign the role to a target VM instance.  
This will allow you to execute necessary "aws ec2" commands without AWS Access Key.

3. Add 'Name' TAG and value(XXX-data) to volumes you wish to take snapshots.  
Example) Name:Test-0001-data

4. You need to install and configure awscli if it's not. Leave AWS Access Key and AWS Secret Access Key blank.
```bash
$ sudo apt update
$ sudo apt install awscli
$ aws configure
AWS Access Key ID [None]:
AWS Secret Access Key [None]:
Default region name [None]: ap-northeast-1
Default output format [None]:
$ cat ~/.aws/config
[default]
region = ap-northeast-1
$
```
Make sure the following command works for you, now.
```bash
$ aws ec2 describe-instances
```

5. Enable O/S authentication and have the matching IRIS user such as 'ubuntu'.  
Make sure the following command works for you, without entering user/password, now.
```bash
$ whoami
ubuntu
$ iris session iris
USER>h
$
```

## How to install and run.
```bash
git clone https://github.com/IRISMeister/azure_backup_script.git
git clone https://github.com/IRISMeister/aws_backup_script.git
cd aws_backup_script/
cp ../azure_backup_script/*.sh .
chmod +x *.sh
./backup.sh
```
You will see new snapshots are created.