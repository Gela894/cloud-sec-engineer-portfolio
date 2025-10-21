# NIST 800-53 Control Mapping

| Control ID | Control Name | AWS Service | Implementation |
|-------------|---------------|--------------|----------------|
| AC-2 | Account Management | IAM | IAM users, groups, roles, and policies with least privilege |
| AC-6 | Least Privilege | IAM, Config | Config Rules enforce policy violations |
| AU-2 | Audit Events | CloudTrail, CloudWatch | Centralized event logging enabled |
| CM-2 | Baseline Configuration | Config, SSM | Configuration drift detection |
| IR-4 | Incident Handling | EventBridge, Lambda | Automated incident response for GuardDuty findings |
| SC-13 | Cryptographic Protection | KMS | Server-side encryption for S3, EBS, RDS |
