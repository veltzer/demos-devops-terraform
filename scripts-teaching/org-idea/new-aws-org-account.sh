#!/bin/bash -e

function usage() {
    echo "usage: organization_new_acc.sh [-h] --account_name ACCOUNT_NAME
                                      --account_email ACCOUNT_EMAIL
                                      --cl_profile_name CLI_PROFILE_NAME
                                      [--ou_name ORGANIZATION_UNIT_NAME]
                                      [--region AWS_REGION]"
}

newAccName=""
newAccEmail=""
newProfile=""
roleName="OrganizationAccountAccessRole"
destinationOUname=""
region="us-east-1"

while [ "$1" != "" ]
do
    case $1 in
        -n | --account_name )   shift
                                newAccName=$1
                                ;;
        -e | --account_email )  shift
                                newAccEmail=$1
                                ;;
        -p | --cl_profile_name ) shift
                                newProfile=$1
                                ;;
        -o | --ou_name )        shift
                                destinationOUname=$1
                                ;;
        -r | --region )        shift
                                region=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
    esac
    shift
done

if [ "${newAccName}" = "" ] || [ "${newAccEmail}" = "" ] || [ "${newProfile}" = "" ]
then
  usage
  exit
fi

if aws organizations list-accounts --query 'Accounts[?Name==`'"${newAccName}"'`]' | grep "${newAccName}" &>/dev/null
then
	echo "Account ${newAccName} already exists, exiting"
	exit
fi

echo "Create New Account"
ReqID=$(aws organizations create-account --email "${newAccEmail}" --account-name "${newAccName}" --role-name "${roleName}" \
--query 'CreateAccountStatus.[Id]' \
--output text)

echo "Waiting for New Account ..."
orgStat=$(aws organizations describe-create-account-status --create-account-request-id "${ReqID}" \
--query 'CreateAccountStatus.[State]' \
--output text)

while [ "${orgStat}" != "SUCCEEDED" ]
do
  if [ "${orgStat}" = "FAILED" ]
  then
    echo "Account Failed to Create"
    exit 1
  fi
  echo "."
  sleep 10
  orgStat=$(aws organizations describe-create-account-status --create-account-request-id "${ReqID}" \
  --query 'CreateAccountStatus.[State]' \
  --output text)
done

accID=$(aws organizations describe-create-account-status --create-account-request-id "${ReqID}" \
--query 'CreateAccountStatus.[AccountId]' \
--output text)

accARN="arn:aws:iam::${accID}:role/${roleName}"

echo "Create New CLI Profile"
aws configure set region "${region}" --profile "${newProfile}"
aws configure set role_arn "${accARN}" --profile "${newProfile}"
aws configure set source_profile default --profile "${newProfile}"

cfcntr=0
echo "Waiting for CF Service ..."
aws cloudformation list-stacks --profile "${newProfile}" > /dev/null 2>&1
actOut=$?
while [[ "${actOut}" -ne 0 && "${cfcntr}" -le 10 ]]
do
  sleep 5
  aws cloudformation list-stacks --profile "${newProfile}" > /dev/null 2>&1
  actOut=$?
  if [ "${actOut}" -eq 0 ]
  then
    break
  fi
  echo "."
  ((cfcntr=cfcntr+1))
done

if [ "${cfcntr}" -gt 10 ]
then
  echo "CF Service not available"
  exit 1
fi

echo "Create VPC Under New Account"
if ! aws cloudformation create-stack --stack-name VPC --template-body "file://CF-VPC.json" --profile "${newProfile}" > /dev/null 2>&1
then
	echo "CF VPC Stack Failed to Create"
	exit 1
fi

echo "Waiting for CF Stack to Finish ..."
cfStat=$(aws cloudformation describe-stacks --stack-name VPC --profile "${newProfile}" --query 'Stacks[0].[StackStatus]' --output text)
while [ "${cfStat}" != "CREATE_COMPLETE" ]
do
  sleep 5
  echo "."
  cfStat=$(aws cloudformation describe-stacks --stack-name VPC --profile "${newProfile}" --query 'Stacks[0].[StackStatus]' --output text)
  if [ "${cfStat}" = "CREATE_FAILED" ]
  then
    echo "VPC Failed to Create"
    exit 1
  fi
done
echo "VPC Created"

ecoh "Create Role and Policy"
aws cloudformation create-stack --stack-name Roles --template-body file://CF-IAM.json --capabilities CAPABILITY_NAMED_IAM --profile "${newProfile}" > /dev/null 2>&1
cfStat=$(aws cloudformation describe-stacks --stack-name Roles --profile "${newProfile}" --query 'Stacks[0].[StackStatus]' --output text)
while [ "${cfStat}" != "CREATE_COMPLETE" ]
do
  sleep 5
  echo "."
  cfStat=$(aws cloudformation describe-stacks --stack-name Roles --profile "${newProfile}" --query 'Stacks[0].[StackStatus]' --output text)
  if [ "${cfStat}" = "CREATE_FAILED" ]
  then
    echo "Role Failed to Create"
    exit 1
  fi
done
echo "Role Created"

echo "Create Configure Rule"
configRole="arn:aws:iam::${accID}:role/service-role/config-rule-role"

aws configservice put-configuration-recorder --configuration-recorder "name=default,roleARN=${configRole}" --recording-group "allSupported=true,includeGlobalResourceTypes=true" --profile "${newProfile}" > /dev/null 2>&1
aws configservice put-config-rule --config-rule file://CF-ConfigRules.json --profile "${newProfile}" > /dev/null 2>&1

if [ "${destinationOUname}" != "" ]
then
  echo "Moving New Account to OU"
  rootOU=$(aws organizations list-roots --query 'Roots[0].[Id]' --output text)
  destOU=$(aws organizations list-organizational-units-for-parent --parent-id "${rootOU}" --query "OrganizationalUnits[?Name=='${destinationOUname}'].[Id]" --output text)

  if ! aws organizations move-account --account-id "${accID}" --source-parent-id "${rootOU}" --destination-parent-id "${destOU}" > /dev/null 2>&1
  then
    echo "Moving Account Failed"
  fi
fi
