# devops-portfolio

Můj první DevOps learning projekt, který je zaměřený na návrh a automatizaci infrastruktury v AWS.

AWS infrastruktura je vytvořena pomocí Terraformu, konfiguruje ji přes Ansible a nasazuje Node.js aplikaci do single-node Kubernetes (k3s) klastru přes Helm. Monitoring zajišťuje Prometheus + Grafana, který je také nasazován pomocí Ansible.

🇬🇧 [English version](README.md)

Nasazovaná aplikace + CI/CD pipeline se nachází v samostatném repozitáři: [nodeapp-counter](https://github.com/jclblinux/nodeapp-counter).

## Architektura & Stack

* **Infrastructure as Code:** Terraform (AWS EC2, VPC, S3 pro vzdálený state management).
* **Configuration:** Ansible (využití AWS Dynamic Inventory pro dynamické vyhledávání cílů podle EC2 tagů).
* **Orchestrace kontejnerů:** single-node Kubernetes klastr postavený na k3s.
* **Ingress Controller:** Traefik (předinstalovaný v k3s - směřuje webvový provoz uvnitř klastru).
* **Balíčkování aplikací:** Helm (vlastní chart pro aplikaci + komunitní charty pro PostgreSQL a monitoring).
* **Monitoring:** Prometheus + Grafana (kube-prometheus-stack) pro sběr metrik a vizualizaci.

## Struktura

```text
devops-portfolio/
├── terraform/
│   ├── modules/
│   │   ├── ec2/                 # Virtuální server a síťová pravidla (porty 22, 80, 443)
│   │   └── vpc/                 # Síťová vrstva (VPC, podsíť, internetová brána)
│   └── environments/
│       ├── dev/                 # Vývojové prostředí (S3 backend)
│       └── prod/                # Příprava pro produkční prostředí
├── ansible/
│   ├── inventory/               # Dynamické vyhledávání AWS serverů podle tagů
│   ├── group_vars/              # Proměnné a nastavení SSH přístupu
│   ├── roles/
│   │   ├── k3s-server/          # Instalace Kubernetes (k3s) klastru
│   │   ├── helm/                # Instalace nástroje Helm na server
│   │   ├── monitoring/          # Nasazení Prometheus a Grafana
│   │   ├── postgresql/          # Instalace PostgreSQL databáze (Bitnami)
│   │   └── nodeapp/             # Příprava nasazení vlastní aplikace
│   └── site.yml                 # Hlavní playbook pro spuštění konfigurace
└── helm/
    ├── monitoring-values.yaml   # Konfigurace a limity pro Prometheus/Grafana
    ├── postgresql-values.yaml   # Nastavení disku a přístupů pro databázi
    └── nodeapp/                 # Vlastní Helm chart pro Node.js aplikaci
        ├── Chart.yaml           # Metadata balíčku (název, verze)
        ├── values.yaml          # Výchozí proměnné aplikace
        └── templates/           # Kubernetes manifesty (Deployment, Service, Ingress, Secret)
```text

## Workflow

Vytvoření infrastruktury (Manuální krok): Terraform se spouští ručně z příkazového řádku pomocí příkazu terraform apply.

Nasazení aplikace je automatizované přes GitHub Actions pipeline v repu [nodeapp-counter](https://github.com/jclblinux/nodeapp-counter): každý push do `main` postaví novou Docker image, pushne ji do Docker Hubu a spustí Ansible playbook proti EC2 instanci, který nasadí novou verzi aplikace.

Veškerý provoz je směrován přes veřejnou IP adresu vytvořeného AWS serveru.
* Webová aplikace je dostupná přímo na hlavní adrese: http://<EC2_PUBLIC_IP>/
* Grafana (přehledy monitoringu) je dostupná na podsložce: http://<EC2_PUBLIC_IP>/grafana
