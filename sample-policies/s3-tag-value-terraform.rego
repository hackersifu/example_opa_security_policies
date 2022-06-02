# Required package to run opa policies
package opa_policies


# Default action to take if no policy is matched
default allow = false


# Deny if S3 is missing a tag value
s3_tag_check [name]{
    res := input.planned_values.root_module.resources
    name := res[_].name
    res[_].type == "aws_s3_bucket"
    # Add the Tag and Value that you want to check for
    object.get(res[_].values.tags, "Tag", "") == "Value"
}

allow = true {
    count(s3_tag_check) == 0
}