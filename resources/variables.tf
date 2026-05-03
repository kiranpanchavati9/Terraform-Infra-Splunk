# EC2 instance type for all Splunk components

variable "type" {
  default = "t3.small"
}

# AMI ID - Amazon Linux / RHEL image in eu-north-1 region

variable "ami" {
  default = "ami-076d128fb049922d4"
}

# Names for each Splunk component instance
# Used with count.index to tag each EC2 instance uniquely

variable "components" {
  default = [
    "splunk-heavy-forwarder",
    "splunk-indexer",
    "splunk-searchhead"]
}


# Splunk ports to open on the Security Group
# 9997 - Splunk Receiver (forwarder to indexer)
# 8089 - Splunk Management / REST API
# 8000 - Splunk Web UI
# 8088 - HTTP Event Collector (HEC)
# 443  - HTTPS / API
# 8080 - Replication port (indexer clustering)

variable "ports" {
  default = [
    "9997",
    "8089",
    "8000",
    "8088",
    "443",
    "8080"]
}


# CIDR block for allowed IP range
# 0.0.0.0/0 means open to all IPs (restrict in production)

variable "cidripv4" {
  default = "0.0.0.0/0"
}

# Protocol for all security group rules

variable "protocol" {
  default = "tcp"
}

# VPC ID where the Security Group and instances will be created


variable "vpcid" {
  default = "vpc-03106aa780f4a0053"
}



