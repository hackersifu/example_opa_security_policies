[![Twitter](https://img.shields.io/twitter/url?label=Follow%20Me%21&style=social&url=https%3A%2F%2Ftwitter.com%2Fdozercat31)](https://twitter.com/dozercat31)
![GitHub last commit](https://img.shields.io/github/last-commit/hackersifu/example_opa_security_policies)
![GitHub](https://img.shields.io/github/license/hackersifu/example_opa_security_policies)

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
Steps to deploy the policies and commands to a pipeline for evaluation:
1. Add the following files to the repository you want to deploy from:
   * Resource deployment file (e.g. Terraform, CloudFormation, etc.)
   * OPA template file
   * Build script file (e.g. gitlab-ci.yml, buildspec.yml, etc.)
       * If you use the build script file within the sample-config-files subfolder, ensure you replace the FILE_NAME value with the name of the file you want to use.
2. Create a pipeline and build within your respective platform (e.g. GitLab, AWS CodeBuild, GitHub, etc.)
3. Validate that the template deploys successfully (or fails, if the policies are violated).
   * You can review the tail logs to perform this validation.

## Security Policy Templates
The following are the security policy templates that can be used to create policies for OPA:

| Sample Policy                                 | Details                                                           |
| --------------------------------------------- | ----------------------------------------------------------------- |
| [sample-policies/security-groups-terraform.rego](https://github.com/hackersifu/example_opa_security_policies/blob/main/sample-policies/security-groups-terraform.rego) | Policy to evaluate AWS Security Groups deployed by Terraform |
| [sample-policies/security-groups-cloudformation.rego](https://github.com/hackersifu/example_opa_security_policies/blob/main/sample-policies/security-groups-cloudformation.rego) | Policy to evaluate AWS Security Groups deployed by CloudFormation |
| [sample-policies/s3-acl-terraform.rego](https://github.com/hackersifu/example_opa_security_policies/blob/main/sample-policies/s3-acl-terraform.rego) | Policy to evaluate AWS S3 ACLs deployed by Terraform |
| [sample-policies/s3-tag-value-terraform.rego](https://github.com/hackersifu/example_opa_security_policies/blob/main/sample-policies/s3-tag-value-terraform.rego) | Policy to evaluate AWS S3 tag values deployed by Terraform |

## Contributions & Feedback
For any contributions, feel free to create a [GitHub Pull Request](https://github.com/hackersifu/example_opa_security_policies/pulls). Additionally, you can use the Issues section to report bugs or submit feedback.

## License
This project is licensed under the Apache 2.0 licensing terms.
