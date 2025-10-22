# Secure VPC Deployment (AWS)

## 🎯 Objective
Design and deploy a secure two-tier VPC with least privilege IAM, logging, and encryption to meet NIST 800-53 and FedRAMP moderate requirements.

## 🏗️ Architecture
![Architecture Diagram](../assets/diagrams/vpc-architecture.png)

- Public Subnet: ALB / Bastion
- Private Subnet: EC2 (web/app)
- Security: SGs, NACLs, IAM roles, KMS encryption, CloudTrail logging

## 🔐 Security Controls
| Framework | Control | Description |
|------------|----------|-------------|
| NIST 800-53 | AC-6 | Enforce least privilege via IAM roles |
| NIST 800-53 | SC-13 | Enable encryption using KMS |
| FedRAMP | AU-2 | Enable CloudTrail and Config logging |

## ⚙️ Implementation
- Terraform deploys VPC, subnets, SGs, IAM roles
- CloudTrail & Config log to encrypted S3 bucket
- IAM policy enforces least privilege on EC2 roles

## 🧠 Lessons Learned
Implementing IAM boundaries early simplifies least-privilege troubleshooting and RMF documentation.

## 🧾 Evidence
- [Terraform Code](./main.tf)
- [Compliance Mapping](../docs/NIST_800-53_Control_Mapping.md)

