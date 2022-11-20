set -e

aws cloudformation deploy \
  --template-file stacks/accounts-janitor-account/default-vpc-deleter.yml \
  --stack-name default-vpc-deleter \
  --capabilities CAPABILITY_NAMED_IAM \
  --region eu-west-1 \
  --profile accounts-janitor
