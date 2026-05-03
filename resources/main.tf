# ============================================================
# main.tf
# Description : Provisions Splunk infrastructure on AWS
#               - Creates a Security Group with ingress/egress rules
#               - Launches 3 EC2 instances (Heavy Forwarder, Indexer, Search Head)
#               - Attaches the Security Group to instances at launch
# Author      : Kiran Panchavati
# ============================================================

# ---------------------------------------------------------------
# SECURITY GROUP
# Creates a new Security Group inside the specified VPC
# This SG will control inbound and outbound traffic for Splunk
# ---------------------------------------------------------------

resource "aws_security_group" "allow_splunk_firewall_rules" {
  name        = "allow_splunk_firewall"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = var.vpcid

  tags = {
    Name = "allow_splunk_firewall_ports"
  }
}


# ---------------------------------------------------------------
# INGRESS RULES (Inbound Traffic)
# Dynamically creates one ingress rule per port using for_each
# Ports: 9997 (Receiver), 8089 (Management), 8000 (Web),
#        8088 (HEC), 443 (HTTPS/API), 8080 (Replication)
# ---------------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "splunk" {
  for_each = toset(var.ports)

  security_group_id = aws_security_group.allow_splunk_firewall_rules.id
  cidr_ipv4         = var.cidripv4
  from_port         = tonumber(each.value)
  ip_protocol       = var.protocol
  to_port           = tonumber(each.value)
}

# ---------------------------------------------------------------
# EGRESS RULES (Outbound Traffic)
# Dynamically creates one egress rule per port using for_each
# Mirrors the ingress rules to allow outbound on the same ports
# ---------------------------------------------------------------

resource "aws_vpc_security_group_egress_rule" "splunk" {
  for_each = toset(var.ports)

  security_group_id = aws_security_group.allow_splunk_firewall_rules.id
  cidr_ipv4         = var.cidripv4
  from_port         = tonumber(each.value)
  ip_protocol       = var.protocol
  to_port           = tonumber(each.value)
}

# ---------------------------------------------------------------
# EC2 INSTANCES
# Creates 3 Splunk component instances using count
# Each instance gets a unique name from the components variable:
#   [0] splunk-heavy-forwarder
#   [1] splunk-indexer
#   [2] splunk-searchhead
# The Security Group is attached at launch time
# ---------------------------------------------------------------

resource "aws_instance" "splunk-components" {
  count = 3
  ami           = var.ami
  instance_type = var.type
  vpc_security_group_ids = [aws_security_group.allow_splunk_firewall_rules.id]

tags = {
    Name = var.components[count.index]
  }
}

