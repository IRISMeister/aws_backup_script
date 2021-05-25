import boto3

def run():
    print('started')
    client = boto3.client('ec2', region_name='ap-northeast-1')
    response = client.create_snapshots(
        Description='string',
        InstanceSpecification={
            'InstanceId': 'i-xxxxxxxxxxxxxx',
            'ExcludeBootVolume': False
        },
        DryRun=False
    )
    print('finished')
