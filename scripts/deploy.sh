set -e

aws cloudformation deploy \
  --template-file stacks/management-account/default-vpc-deleter-role.yml \
  --stack-name default-vpc-deleter-role \
  --capabilities CAPABILITY_NAMED_IAM \
  --region eu-west-1 \
  --profile accounts-janitor
