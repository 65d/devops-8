#!/bin/bash

IMAGE_ID="ami-01bc990364452ab3e"
INSTANCE_TYPE="t2.micro"
KEY_NAME="key"
SECURITY_GROUP_ID="sg-02e97f1db4c6059a4"
SUBNET_ID="subnet-0e0a8ff71e33c6727"
TAG_NAME="$1"

if [ -z "$TAG_NAME" ]; then
    echo "Usage: $0 <tag-name>"
    exit 1
fi

echo "Launching EC2 instance..."
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $IMAGE_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SECURITY_GROUP_ID \
    --subnet-id $SUBNET_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_NAME}]" \
    --user-data file://user_data.sh \
    --query "Instances[0].InstanceId" \
    --iam-instance-profile "Name=ec2-instance-profile" \
    --output text)

echo "Instance ID: $INSTANCE_ID"


aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0


echo "Waiting for instance to be ready..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID
sleep 20

echo "Instance is ready"

PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)

echo "Public IP: $PUBLIC_IP"


echo "Connecting to EC2 instance..."
ssh -i $KEY_NAME.pem -o StrictHostKeyChecking=no ec2-user@$PUBLIC_IP

echo "Instance ID: $INSTANCE_ID"

./terminate.sh "$INSTANCE_ID"
