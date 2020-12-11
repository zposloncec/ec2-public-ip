# Disassociate Public IP from AWS EC2 instance

Script based on the document:
https://medium.com/@shanecfast/how-to-remove-a-public-ip-from-an-aws-ec2-instance-without-restart-or-termination-c91c22e1ce3f

NOTE: Prerequisite is to have jq installed on local machine and also to have one unassociated EIP

Update eip_id varijable in the script and execute.

The script will create temp nic in the subnet of the instance and remove it at the end
 
