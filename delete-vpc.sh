set -e

ACCOUNT_ID=$1

# TODO: assume role

for region in $(aws ec2 describe-regions --region eu-west-1 | jq -r .Regions[].RegionName); do
  echo "* Region ${region}"

  DEFAULT_VPC_ID=$(aws ec2 --region ${region} describe-vpcs --filter Name=isDefault,Values=true | jq -r .Vpcs[0].VpcId)
  if [ "${DEFAULT_VPC_ID}" = "null" ]; then
    echo "No default vpc found"
    continue
  fi
  echo "Found default vpc ${DEFAULT_VPC_ID}"

  INTERNET_GATEWAY_ID=$(aws ec2 --region ${region} describe-internet-gateways --filter Name=attachment.vpc-id,Values=${DEFAULT_VPC_ID} | jq -r .InternetGateways[0].InternetGatewayId)
  if [ "${INTERNET_GATEWAY_ID}" != "null" ]; then
    echo "Detaching and deleting internet gateway ${INTERNET_GATEWAY_ID}"
    # aws ec2 --region ${region} detach-internet-gateway --internet-gateway-id ${INTERNET_GATEWAY_ID} --vpc-id ${DEFAULT_VPC_ID}
    # aws ec2 --region ${region} delete-internet-gateway --internet-gateway-id ${INTERNET_GATEWAY_ID}
  fi

  SUBNETS=$(aws ec2 --region ${region} describe-subnets --filters Name=vpc-id,Values=${DEFAULT_VPC_ID} | jq -r .Subnets[].SubnetId)
  if [ "${SUBNETS}" != "null" ]; then
    for subnet_id in ${SUBNETS}; do
      echo "Deleting subnet ${subnet_id}"
      # aws ec2 --region ${region} delete-subnet --subnet-id ${subnet_id}
    done
  fi

  echo "Deleting vpc ${DEFAULT_VPC_ID}"
  # aws ec2 --region ${region} delete-vpc --vpc-id ${DEFAULT_VPC_ID}

done
