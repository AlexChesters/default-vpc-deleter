set -e

rain deploy \
  stacks/accounts-janitor-account/default-vpc-deleter.yml \
  default-vpc-deleter \
  --region eu-west-1 \
  --profile accounts-janitor \
  --yes
