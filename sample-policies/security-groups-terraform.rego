# Required package to run opa policies
package opa_policies


# Default action to take if no policy is matched
default allow = false


# Deny if Security Group is has open SSH/RDP ports to the world
sg_open_ports_ssh [name]{
    res := input.planned_values.root_module.resources
    name := res[_].name
    res[_].type == "aws_security_group"
    object.get(res[_].values.ingress[_], "to_port", "") == 22
    cidr := input.planned_values.root_module.resources[_].values.ingress[_].cidr_blocks[_]
    print("cidr", cidr)
    cidr == "0.0.0.0/0"
}


sg_open_ports_rdp [name]{
    res := input.planned_values.root_module.resources
    name := res[_].name
    res[_].type == "aws_security_group"
    object.get(res[_].values.ingress[_], "to_port", "") == 3389
    cidr := input.planned_values.root_module.resources[_].values.ingress[_].cidr_blocks[_]
    print("cidr", cidr)
    cidr == "0.0.0.0/0"
}


allow = true {
    count(sg_open_ports_ssh) == 0
    count(sg_open_ports_rdp) == 0
}