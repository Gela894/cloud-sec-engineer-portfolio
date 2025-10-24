# Secure VPC Deployment (AWS)

## 🎯 Objective
Design and deploy a secure two-tier VPC with least privilege IAM, logging, and encryption to meet NIST 800-53 and FedRAMP moderate requirements.

## Scenario
AeroTech Systems, recently won a subcontract supporting  an  initiative titled “SkyShield” — a modernization program aimed at migrating mission-planning and aircraft telemetry systems from on-premise data centers to the Cloud environment.
These systems process **Controlled Unclassified Information (CUI)** and mission-critical data such as flight plans, maintenance logs, and secure communications metadata. Before deployment, it is required that AeroTech build a **secure cloud enclave** that meets **FedRAMP** and **NIST 800-53 Rev. 5** requirements as a prerequisite for an **Authority to Operate (ATO)** under the RMF process.

## 🏗️ Architecture
![Architecture Diagram](../assets/diagrams/vpc-architecture.png)

- VPC with two AZs, public + private subnets
- Public: Application Load Balancer (ALB)
- Private: EC2 Autoscaling Group (web/app)
- Ingress/Egress:
    - ALB → HTTPS (TLS 1.2+) to targets
    - Egress via NAT Gateway (or VPC endpoints for S3/SSM)
- Access: Prefer SSM Session Manager over a bastion (bastion optional for demo)
- Security: SGs, NACLs (deny-by-default + explicit rules)
- Encryption: KMS CMKs for EBS, ALB logs, S3 (logs), CloudTrail, Config
- Observability: CloudTrail (org or account), AWS Config, VPC Flow Logs, CloudWatch Logs
- Hardening: IAM roles for EC2, boundary policies, instance profile with least privilege

## 🔐 Security Controls
| Framework | Control | Description |
|------------|----------|-------------|
| NIST 800-53 | AC-6 | Least privilege via EC2 role + IAM boundary |
| NIST 800-53 | SC-13 | Enable encryption using KMS for EBS, S3 logs, ALB logs, CloudTrail |
| FedRAMP | AU-2 | Enable CloudTrail and Config logging, all regions, all APIs |
| NIST 800-53 | AU-9 | Log integrity: CloudTrail to S3 with bucket/KMS policies; access logging enabled |
| NIST 800-53 | sc-7 | Segmentation with SGs/NACLs, ALB as boundary, restricted egress |
| NIST 800-53 | SC-28 | Encrypt data at rest (EBS/S3); TLS for in-transit |
| NIST 800-53 | CM-2/CM-6 | Terraform IaC; pre-commit policy checks; parameterized modules |

## ⚙️ Implementation
- Terraform deploys VPC, subnets, SGs, IAM roles
- CloudTrail & Config log to encrypted S3 bucket
- IAM policy enforces least privilege on EC2 roles
- Automate compliance evidence

## 🧠 Lessons Learned
Implementing IAM boundaries early simplifies least-privilege troubleshooting and RMF documentation.

## 🧾 Evidence
- [Terraform Code](./main.tf)
- [Compliance Mapping](../docs/NIST_800-53_Control_Mapping.md)

