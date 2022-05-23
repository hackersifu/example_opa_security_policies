[![Twitter](https://img.shields.io/twitter/url?label=Follow%20Me%21&style=social&url=https%3A%2F%2Ftwitter.com%2Fjdubm31)](https://twitter.com/jdubm31)
![GitHub all releases](https://img.shields.io/github/downloads/hackersifu/example_opa_security_policies/total)

# Example Open Policy Agent (OPA) Security Policies
Example Open Policy Agent (OPA) Policies related to Security. These policies can be used as templates for using OPA within deployment pipelines, to prevent configurations that could lead to potential security issues.

## Prerequisites
The following are prerequisites for using the policies within a CI/CD pipeline:
- Create a deployment template for the resources you want to build (e.g. via Terraform or CloudFormation)
- Create the OPA template using the policies within the [sample-policies](https://github.com/hackersifu/example_opa_security_policies/tree/main/sample-policies) subfolder
- Create script to perform the following actions within a pipeline (examples contained within the [sample-config-files](https://github.com/hackersifu/example_opa_security_policies/tree/main/sample-config-files) subfolder)

## Commands within the CI/CD Pipeline
The following commands are used within the CI/CD pipeline build file (e.g. gitlab-ci.yml for GitLab, buildspec.yml for AWS CodeBuild, etc.) to run the commands needed for performing policy evaluation using OPA.
```
# Installing Terraform (for evaluating Terraform Policies)
echo "Downloading Terraform for JSON conversion"
wget https://releases.hashicorp.com/terraform/1.1.2/terraform_1.1.2_linux_amd64.zip
unzip terraform*.zip
mv terraform /usr/local/bin
terraform --version

# Using Terraform to convert Terraform script to JSON using Terraform show. This is done to parse the JSON output with the OPA policy file.
terraform init
terraform plan --out tfplan.binary
terraform show -json tfplan.binary > tfplan.json
echo "JSON Output using Terraform show"
cat tfplan.json

# Downloading the OPA binary executable
echo "Downloading OPA eval file"
curl -L -o opa https://openpolicyagent.org/downloads/v0.40.0/opa_linux_amd64_static
chmod 755 ./opa

# Performing the OPA policy evaluation.
# Replace the -d value with the Rego file name you want to evaluate against.
echo "OPA Policy Validation Command, replace the -d value to the rego file name you want to evaluate against."
./opa eval --format pretty -i tfplan.json -d <FILE_NAME>.rego "data"
./opa eval --format pretty -i tfplan.json -d <FILE_NAME>.rego "data" | jq --raw-output '.opa_policies.allow' > allow.txt
ALLOW_VALUE=`cat allow.txt`
echo "Allow Value Below:"
echo $ALLOW_VALUE
if [ $ALLOW_VALUE = 'false' ]; then exit 1; fi
```

## How to Use

## Security Policy Templates
The following are the security policy templates that can be used to create policies for OPA:

| Sample Policy                                 | Details                                                           |
| --------------------------------------------- | ----------------------------------------------------------------- |
| [sample-policies/security-groups-terraform.rego](https://github.com/hackersifu/example_opa_security_policies/blob/main/sample-policies/security-groups-terraform.rego) | Policy to evaluate AWS Security Groups deployed by Terraform |
| [sample-policies/security-groups-cloudformation.rego](https://github.com/hackersifu/example_opa_security_policies/blob/main/sample-policies/security-groups-cloudformation.rego) | Policy to evaluate AWS Security Groups deployed by CloudFormation |

## Contributions & Feedback
For any contributions, feel free to create a [GitHub Pull Request](https://github.com/hackersifu/example_opa_security_policies/pulls). Additionally, you can use the Issues section to report bugs or submit feedback.

## License
This project is licensed under the Apache 2.0 licensing terms.
