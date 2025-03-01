# The `aws` CLI
#aws #cli #iam #sts #todo
TODO: Organize this mess!
## AWS CLI Configuration

```sh
# Install using `pip install -U gimme-aws-creds`
gimme-aws-creds  # And configure

# View all profiles
aws configure list-profiles

# Set profile for multiple commands
export AWS_PROFILE=<profile of choice>
aws configure list  # to double check!

# Configure profile
aws configure
# Configure a specific profile
aws configure --profile <profile of choice>

# I don't think this works
aws configure set profile <profile of choice>
aws configure get profile  # to double check!

# Get Account ID and some other identity details
aws sts get-caller-identity
```

```sh
# Likely you need to use the --profile flag
# it is possible you need to specify the --region as well
aws ecr get-login-password
aws ecr describe-repositories
aws ecr list-images --repository-name <repository name e.g. some-repo>

aws ecr get-login-password | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
```

```sh
# Don't forget --profile
aws iam create-access-key --user-name <iam username>
aws iam list-access-keys --user-name <iam username>
```

```sh
aws iam list-roles
aws sts assume-role --role-arn <arn> --role-session-name <descriptive name>

export AWS_ACCESS_KEY_ID=<AccessKeyId>
export AWS_SECRET_ACCESS_KEY=<SecretAccessKey>
export AWS_SESSION_TOKEN=<SessionToken>

# Alternatively! 
eval $(aws sts assume-role --role-arn arn:aws:sts::XXXXXXXXX:role/my_role --role-session-name testingsess --query 'Credentials.[AccessKeyId, SecretAccessKey, SessionToken]' --output text | awk '{ print "export AWS_ACCESS_KEY_ID=\"" $1 "\"\n" "export AWS_SECRET_ACCESS_KEY=\"" $2 "\"\n" "export AWS_SESSION_TOKEN=\"" $3 "\"" }')

# When done and want to return to a particular profile
unset AWS_ACCESS_KEY_ID; unset AWS_SECRET_ACCESS_KEY; unset AWS_SESSION_TOKEN
aws configure --profile <profile>  # Accept defaults if they're correct
# confirm
aws sts get-caller-identity
```