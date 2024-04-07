function aws_listbyipandname(){
  aws ec2 describe-instances --query 'Reservations[].Instances[].[PrivateIpAddress,Tags[?Key==`Name`].Value[]]' --output text
}
function aws_listbyname(){
  aws ec2 describe-instances --query 'Reservations[].Instances[].[Tags[?Key==`Name`].Value[]]' --output text
}

function awslookup {
    cmd="aws --profile $1 ec2 describe-instances --filters \"Name=tag:Name,Values=$2\" --query 'Reservations[].Instances[].[InstanceId,PrivateIpAddress,State.Name,ImageId,join(\`,\`,Tags[?Key==\`Name\`].Value)]' --output ${3:-text}"
    if [ $# -eq 4 ]
    then
      echo "Running $cmd"
    fi
    eval $cmd
}

function aws-roles-available {
    aws iam list-roles --query 'Roles[*].[Arn,RoleName]' --output table  | grep -i "`aws sts get-caller-identity | jq '.Arn' | cut -d '/' -f 2 | cut -d '_' -f 2`Admin\|\/`aws sts get-caller-identity | jq '.Arn' | cut -d '/' -f 2 | cut -d '_' -f 2`\/"
}

function aws-whoami {
      profile="${1}"
      if [[ ! -z "${profile}" ]]; then
          aws --profile "${profile}" iam list-account-aliases --output text 2>/dev/null \
          && aws --profile "${profile}" sts get-caller-identity --output text 2> /dev/null
      else
          aws iam list-account-aliases --output text 2>/dev/null \
          && aws sts get-caller-identity --output text 2>/dev/null
      fi
}

function aws-drop-assume-role {
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_PROFILE
}
