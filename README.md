# devops-portfolio

My first DevOps learning project focused on infrastructure design and automation in AWS.

The AWS infrastructure is provisioned using Terraform, configured via Ansible, and deploys a Node.js application into a single-node Kubernetes (k3s) cluster using Helm. Monitoring is provided by Prometheus + Grafana, which is also deployed via Ansible.

🇨🇿 [Czech version](README.cs.md)

The deployed application and its CI/CD pipeline are located in a separate repository: [nodeapp-counter](https://github.com/jclblinux/nodeapp-counter).

## Architecture & Stack

* **Infrastructure as Code:** Terraform (AWS EC2, VPC, S3 for remote state management).
* **Configuration:** Ansible (utilizing AWS Dynamic Inventory to find targets based on EC2 tags).
* **Container Orchestration:** Single-node Kubernetes cluster built on k3s.
* **Ingress Controller:** Traefik (pre-installed in k3s - routes web traffic inside the cluster).
* **Application Packaging:** Helm (custom chart for the application + community charts for PostgreSQL and monitoring).
* **Monitoring:** Prometheus + Grafana (kube-prometheus-stack) for metric collection and visualization.

## Structure

```text
devops-portfolio/
├── terraform/
│   ├── modules/
│   │   ├── ec2/                 # Virtual server and network rules (ports 22, 80, 443)
│   │   └── vpc/                 # Network layer (VPC, subnet, internet gateway)
│   └── environments/
│       ├── dev/                 # Development environment (S3 backend)
│       └── prod/                # Preparation for production environment
├── ansible/
│   ├── inventory/               # Dynamic AWS server discovery based on tags
│   ├── group_vars/              # Variables and SSH access settings
│   ├── roles/
│   │   ├── k3s-server/          # Kubernetes (k3s) cluster installation
│   │   ├── helm/                # Helm CLI tool installation on the server
│   │   ├── monitoring/          # Prometheus and Grafana deployment
│   │   ├── postgresql/          # PostgreSQL database installation (Bitnami)
│   │   └── nodeapp/             # Preparation for custom application deployment
│   └── site.yml                 # Main playbook to run the configuration
└── helm/
    ├── monitoring-values.yaml   # Configuration and resource limits for Prometheus/Grafana
    ├── postgresql-values.yaml   # Disk settings and access credentials for the database
    └── nodeapp/                 # Custom Helm chart for the Node.js application
        ├── Chart.yaml           # Chart metadata (name, version)
        ├── values.yaml          # Default application variables
        └── templates/           # Kubernetes manifests (Deployment, Service, Ingress, Secret)

## Workflow

Provisioning Infrastructure (Manual step): Terraform is run manually from the command line using the `terraform apply` command.

Application Deployment (Automated step): Deployment is fully automated via a GitHub Actions pipeline in the [nodeapp-counter](https://github.com/jclblinux/nodeapp-counter) repository. Every push to `main` builds a new Docker image, pushes it to Docker Hub, and triggers the Ansible playbook against the EC2 instance to deploy the new version of the application.

All traffic is routed through the public IP address of the created AWS server.
* The web application is accessible directly at the main address: http://<EC2_PUBLIC_IP>/
* Grafana (monitoring dashboards) is accessible at the subfolder: http://<EC2_PUBLIC_IP>/grafana
