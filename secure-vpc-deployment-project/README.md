### 1️⃣ Project Title + One-Liner

**Secure VPC Deployment — Operation SkyShield**

> A secure, multi-tier AWS VPC built with Terraform, implementing segmentation, controlled egress, identity-based access, centralized logging, and validated detection.
> 

---

### 2️⃣ Architecture Overview (Visual First)

- Insert architecture diagram image
- 1–2 bullets max explaining tiers:
    - Public (entry)
    - Private App
    - Private Data

📌 *No paragraphs here.*

---

### 3️⃣ What This Project Demonstrates

Short bullets — this is the money section.

- Secure VPC design with tiered network isolation
- Controlled outbound internet access using NAT and VPC endpoints
- Identity-based instance management via IAM + SSM (no SSH)
- Centralized logging with CloudTrail and VPC Flow Logs
- Basic detection and alerting for risky configuration changes
- Infrastructure defined and versioned using Terraform

---

### 4️⃣ Security Controls at a Glance

High level only — no control IDs.

- Network segmentation and boundary protection
- Least privilege (network + identity)
- Encrypted, auditable logging
- Detect-and-alert capability for sensitive events

---

### 5️⃣ Verification Summary

3 bullets max:

- Private subnets have no direct internet exposure
- App tier outbound traffic restricted via NAT/endpoints
- Logging and detection validated through test events

---

### 6️⃣ Proof (Minimal Screenshots)

**Include no more than 3 images**

- VPC resource map
- Route table showing NAT vs IGW
- Flow Logs or Alarm triggered

---

### 7️⃣ Documentation & Evidence

Link out — don’t embed.

- 🔗 **Notion Case File (Full Build, Evidence & Decisions)**
- 📁 `/docs/` — Control validation & assumptions
- 📁 `/evidence/` — Test results (referenced)

---

### 8️⃣ Tech Stack

One line list:

- AWS (VPC, EC2, IAM, CloudTrail, CloudWatch, SSM)
- Terraform
- Notion (documentation)
