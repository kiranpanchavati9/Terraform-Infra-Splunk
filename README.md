#  terraform-aws-splunk-infra

Terraform project to automate the provisioning of **Splunk infrastructure on AWS** — including Security Groups with dynamic firewall rules and EC2 instances for each Splunk component.

---

##  What This Project Does

-  Creates an AWS **Security Group** with all required Splunk ports
-  Dynamically adds **Ingress & Egress rules** using `for_each`
-  Launches **3 EC2 instances** for Splunk components using `count`
-  Attaches the Security Group to instances **at launch time**

---

##  Architecture

```
VPC (vpc-03106aa780f4a0053)
│
├── Security Group: allow_splunk_firewall
│   ├── Ingress Rules (TCP): 9997, 8089, 8000, 8088, 443, 8080
│   └── Egress Rules  (TCP): 9997, 8089, 8000, 8088, 443, 8080
│
├── EC2: splunk-heavy-forwarder
├── EC2: splunk-indexer
└── EC2: splunk-searchhead
```

---

##  Splunk Ports Reference

| Port | Purpose |
|------|---------|
| 9997 | Splunk Receiver (Forwarder → Indexer) |
| 8089 | Splunk Management / REST API |
| 8000 | Splunk Web UI |
| 8088 | HTTP Event Collector (HEC) |
| 443  | HTTPS / API |
| 8080 | Indexer Replication Port |

---

##  Project Structure

```
terraform-aws-splunk-infra/
├── main.tf        # Security Group, Ingress/Egress rules, EC2 instances
├── variables.tf   # All input variables
├── provider.tf    # AWS provider configuration
└── README.md
```

---

##  Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `vpcid` | VPC ID to deploy resources | `vpc-03106aa780f4a0053` |
| `ami` | AMI ID for EC2 instances | `ami-076d128fb049922d4` |
| `type` | EC2 instance type | `t3.small` |
| `ports` | List of Splunk ports to open | `[9997, 8089, 8000, 8088, 443, 8080]` |
| `cidripv4` | Allowed CIDR range | `0.0.0.0/0` |
| `protocol` | Network protocol | `tcp` |
| `components` | Splunk component names | `[heavy-forwarder, indexer, searchhead]` |

---

##  Getting Started

### Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- AWS CLI configured with appropriate permissions
- AWS account with access to EC2 and VPC

### Steps

```bash
# 1. Clone the repo
git clone https://github.com/kiranpanchavati9/Terraform-Infra-Splunk
cd Terraform-Infra-Splunk

# 2. Initialize Terraform
terraform init

# 3. Preview the changes
terraform plan

# 4. Apply the configuration
terraform apply
```

---

##  Key Terraform Concepts Used

- **`for_each`** — dynamically creates one rule per port without repeating code
- **`toset()`** — converts the ports list to a set for use with `for_each`
- **`count`** — creates multiple EC2 instances from a single resource block
- **`count.index`** — assigns unique names to each instance from a list
- **`tonumber()`** — converts string port values to numbers

---

## ⚠ Security Note

> `cidr_ipv4 = "0.0.0.0/0"` opens ports to the entire internet.  
> In production, restrict this to your specific IP ranges or use security group references.

---

##  Tech Stack

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Splunk](https://img.shields.io/badge/Splunk-000000?style=for-the-badge&logo=splunk&logoColor=white)

---

##  License

MIT License — feel free to use and modify.