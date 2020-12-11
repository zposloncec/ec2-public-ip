#!/bin/bash
#
# Run script with instance id as an argument:
#
# ./remove_public_ip.sh <instance_id>
#
##################################################

if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    exit
fi

#Variables
instance_id=$1
eip_id=
nic_id=

# Get network interface id
echo "Getting network interface for $instance_id"
network_interface_id=$(aws ec2 describe-instances  --instance-id $instance_id --output json | jq -r '.Reservations[].Instances[].NetworkInterfaces[].NetworkInterfaceId')

# Apply Elastic IP
echo "Applying EIP to $network_interface_id"
aws ec2 associate-address --allocation-id $eip_id --network-interface-id $network_interface_id

# Apply Network interface to the instance
echo "Attaching additional network interface to $instance_id"
aws ec2 attach-network-interface --network-interface-id $nic_id --instance-id $instance_id --device-index 1

# Get network attachemnt id from instance
echo "Getting eip association id from $eip_id"
allocation_id=$(aws ec2 describe-addresses --allocation-ids $eip_id | jq -r '.Addresses[].AssociationId')

# Detach eip
echo "Disasocciating EIP $eip_id"
aws ec2 disassociate-address --association-id $allocation_id

# Get network attachemnt id from instance
echo "Getting nic attachment id from $instance_id"
attachment_id=$(aws ec2 describe-instances  --instance-id $instance_id --output json | jq -r '.Reservations[].Instances[].NetworkInterfaces[1].Attachment.AttachmentId')

# detach network interface
echo "Detaching network interface $attachment_id"
aws ec2 detach-network-interface --attachment-id $attachment_id
