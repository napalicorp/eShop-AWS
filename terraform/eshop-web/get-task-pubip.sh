#!/bin/bash

cluster_arn=`terraform -chdir=terraform/eshop-web output -json cluster_arn | jq -r "."`
service_name=`terraform -chdir=terraform/eshop-web output -json service_name | jq -r "."`
task_arn=`aws ecs list-tasks --cluster $cluster_arn --service-name $service_name | jq -r ".taskArns[0]"`
echo "Task Id: $task_arn"
task_ni_id=`aws ecs describe-tasks --cluster $cluster_arn --tasks $task_arn --output json | jq -r '.tasks[0].attachments[0].details[] | select(.name == "networkInterfaceId") | .value'`
echo "Network interface id: $task_ni_id"
task_pubip=`aws ec2 describe-network-interfaces --network-interface-ids $task_ni_id | jq -r ".NetworkInterfaces[0].Association.PublicIp"`
echo "http://$task_pubip"