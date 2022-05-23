# Required package to run opa policies
package opa_policies


# Default action to take if no policy is matched
default allow = false


# Deny if Security Group is has open SSH/RDP ports to the world
sg_open_ports_ssh [name]{
    res:=input.Resources[name]
    res.Type == "AWS::EC2::SecurityGroup"
    object.get(res.Properties.SecurityGroupIngress[_], "ToPort", "") == "22"
    object.get(res.Properties.SecurityGroupIngress[_], "CidrIp", "") == "0.0.0.0/0"
}


sg_open_ports_rdp [name]{
    res:=input.Resources[name]
    res.Type == "AWS::EC2::SecurityGroup"
    object.get(res.Properties.SecurityGroupIngress[_], "ToPort", "") == "3389"
    object.get(res.Properties.SecurityGroupIngress[_], "CidrIp", "") == "0.0.0.0/0"
}


allow = true {
    count(sg_open_ports_ssh) == 0
    count(sg_open_ports_rdp) == 0
}