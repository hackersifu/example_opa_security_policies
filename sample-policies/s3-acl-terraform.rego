# Required package to run opa policies
package opa_policies


# Default action to take if no policy is matched
default allow = false


# Deny if S3 bucket has a public ACL
public_acl_check [name]{
    res := input.planned_values.root_module.resources
    name := res[_].name
    res[_].type == "aws_s3_bucket_acl"
    res[_].values.acl != "private"
}

allow = true {
    count(public_acl_check) == 0
}
