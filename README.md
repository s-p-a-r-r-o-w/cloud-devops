
---

# Cloud & DevOps Engineer Assessment Task

This repository provides a solution to deploy a static web application on a cloud-based Kubernetes cluster hosted on Google Cloud Platform (GCP). It also includes Prometheus monitoring for Kubernetes and application metrics.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Steps](#steps)
   - [Step 1: Build and Push Docker Image](#step-1-build-and-push-docker-image)
   - [Step 2: Provision Kubernetes Cluster](#step-2-provision-kubernetes-cluster)
   - [Step 3: Deploy Kubernetes Manifests](#step-3-deploy-kubernetes-manifests)
   - [Step 4: Access Your Application](#step-4-access-your-application)
   - [Step 5: Install Prometheus using Helm](#step-5-install-prometheus-using-helm)
3. [Cleanup](#cleanup)

## Prerequisites

Before starting, make sure you have the following installed and configured:

1. **Google Cloud Platform (GCP) account** with billing enabled.
2. **Docker**: Ensure Docker is installed and logged in to your Docker Hub account.
3. **Terraform**: Used for provisioning GCP resources.
4. **kubectl**: Kubernetes CLI for managing Kubernetes clusters.
5. **GCloud CLI**: For interacting with GCP and configuring the Kubernetes cluster.
6. **Helm**: A package manager for Kubernetes, required for installing Prometheus.

## Steps

### Step 1: Build and Push Docker Image

1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/s-p-a-r-r-o-w/cloud-devops.git
   cd cloud-devops
   ```

2. Navigate to the `web-app/` directory where the Dockerfile is located:
   ```bash
   cd web-app/
   ```

3. Build the Docker image:
   ```bash
   docker build -t <dockerhub-username>/web-app:latest -f ../Dockerfile .
   ```

4. Push the Docker image to Docker Hub:
   ```bash
   docker push <dockerhub-username>/web-app:latest
   ```

### Step 2: Provision Kubernetes Cluster

Ensure that **Terraform**, **GCloud CLI**, and **kubectl** are installed and authenticated on your local machine.

1. Navigate to the `terraform/` directory:
   ```bash
   cd terraform
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Apply the Terraform configuration:
   ```bash
   terraform apply -var "project_id=<your-gcp-project-id>"
   ```

4. Configure your local **kubectl** to use the newly created Kubernetes cluster:
   ```bash
   gcloud container clusters get-credentials k8s-cluster --region us-central1-a --project <your-gcp-project-id>
   ```

### Step 3: Deploy Kubernetes Manifests

1. Navigate to the `kubernetes/` directory:
   ```bash
   cd ../kubernetes
   ```

2. Apply the Kubernetes manifests to deploy your application and service:
   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   ```

### Step 4: Access Your Application

1. Get the external IP address of your service:
   ```bash
   kubectl get service web-app-service
   ```

2. Open the external IP in your browser to access the application.

### Step 5: Install Prometheus using Helm

Prometheus will be used for monitoring your Kubernetes cluster and application metrics.

#### 1. Add the Helm Chart Repository

First, add the official **Prometheus Community** Helm chart repository:
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

#### 2. Create a Namespace for Monitoring (Optional)

Create a dedicated namespace for monitoring:
```bash
kubectl create namespace monitoring
```

#### 3. Install Prometheus

Install Prometheus using the **kube-prometheus-stack** Helm chart:
```bash
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring
```

This will install Prometheus, Alertmanager, and Grafana for monitoring and visualization.

#### 4. Verify the Installation

Check that the Prometheus, Grafana, and Alertmanager pods are running:
```bash
kubectl get pods -n monitoring
```

#### 5. Access the Prometheus UI

Port-forward Prometheus to access it locally:
```bash
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
```

Visit [http://localhost:9090](http://localhost:9090) in your browser.

#### 6. Access the Grafana UI

Port-forward Grafana to access it locally:
```bash
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
```

Visit [http://localhost:3000](http://localhost:3000) in your browser.

**Default login credentials**:
- Username: `admin`
- Password: `prom-operator`

## Cleanup

To avoid incurring unnecessary costs, you can destroy the resources after testing.

1. Destroy the Kubernetes cluster using Terraform:
   ```bash
   cd terraform
   terraform destroy
   ```

---