# Terraform Configuration for ArgoCD Deployment

This Terraform configuration deploys ArgoCD to a Kubernetes cluster.

## Connection Error Resolution

### Connection Refused Error

If you encounter the error `dial tcp 127.0.0.1:80: connect: connection refused` when running `terraform apply`, it means Terraform cannot connect to your Kubernetes cluster. This could be because:

1. Your Kubernetes cluster (like Minikube) is not running
2. Your kubectl configuration is not properly set up
3. You need to provide explicit connection details

### DNS Resolution Error

If you encounter the error `dial tcp: lookup kubernetes.default.svc on 127.0.0.53:53: no such host`, it means Terraform is trying to connect to a Kubernetes hostname that cannot be resolved. This happens when:

1. You're trying to use the internal Kubernetes DNS name (`kubernetes.default.svc`) from outside the cluster
2. You haven't specified the correct Kubernetes API endpoint for your environment

This error requires you to explicitly set the `kubernetes_host` variable to the correct API server endpoint for your environment.

## How to Use This Configuration

### Option 1: Using a Local Kubernetes Cluster (Minikube)

If you want to use Minikube:

1. Start Minikube:
   ```
   minikube start
   ```

2. Create a terraform.tfvars file with the following content:
   ```hcl
   kubernetes_host = "https://$(minikube ip):8443"
   kubernetes_client_certificate = file("~/.minikube/profiles/minikube/client.crt")
   kubernetes_client_key = file("~/.minikube/profiles/minikube/client.key")
   kubernetes_cluster_ca_certificate = file("~/.minikube/ca.crt")
   ```
   
   Note: The port 8443 is the default API server port for Minikube. Make sure to include both the https:// prefix and the port.

### Option 2: Using an Existing Kubernetes Cluster

If you have an existing Kubernetes cluster:

#### For Kind Cluster

```hcl
kubernetes_host = "https://127.0.0.1:6443"  # Default Kind API server endpoint
kubernetes_client_certificate = file("~/.kube/kind-config-my-cluster")  # Path to your Kind config
kubernetes_client_key = file("~/.kube/kind-config-my-cluster")  # Path to your Kind config
kubernetes_cluster_ca_certificate = file("~/.kube/kind-config-my-cluster")  # Path to your Kind config
```

#### For EKS (AWS)

```hcl
kubernetes_host = "https://your-eks-cluster-endpoint.eks.amazonaws.com"
# Use AWS CLI to get credentials
```

#### For GKE (Google Cloud)

```hcl
kubernetes_host = "https://your-gke-cluster-endpoint-ip:443"
# Use gcloud to get credentials
```

#### For AKS (Azure)

```hcl
kubernetes_host = "https://your-aks-cluster-endpoint.hcp.region.azmk8s.io:443"
# Use az CLI to get credentials
```

#### Using kubeconfig

Alternatively, you can use a kubeconfig file by modifying the providers.tf file:
```hcl
provider "kubernetes" {
  config_path = "~/.kube/config"  # Default kubeconfig path
  # Or specify a custom path
  # config_path = "/path/to/your/kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Default kubeconfig path
    # Or specify a custom path
    # config_path = "/path/to/your/kubeconfig"
  }
}
```

### Option 3: Using Environment Variables

You can also set the following environment variables:

#### For Minikube

```bash
export MINIKUBE_IP=$(minikube ip)
export TF_VAR_kubernetes_host="https://${MINIKUBE_IP}:8443"
export TF_VAR_kubernetes_client_certificate=$(cat ~/.minikube/profiles/minikube/client.crt)
export TF_VAR_kubernetes_client_key=$(cat ~/.minikube/profiles/minikube/client.key)
export TF_VAR_kubernetes_cluster_ca_certificate=$(cat ~/.minikube/ca.crt)
```

#### For Kind

```bash
export TF_VAR_kubernetes_host="https://127.0.0.1:6443"
# You'll need to extract the certificates from your kubeconfig
```

#### For Cloud Providers (AWS, GCP, Azure)

```bash
# First, update your kubeconfig using the appropriate CLI tool
# For AWS: aws eks update-kubeconfig --name cluster-name --region region
# For GCP: gcloud container clusters get-credentials cluster-name --zone zone --project project-id
# For Azure: az aks get-credentials --resource-group resource-group --name cluster-name

# Then extract the information from your kubeconfig
export TF_VAR_kubernetes_host="https://your-cluster-endpoint"
# Extract certificates from your kubeconfig file
```

## Applying the Configuration

Once you've set up your connection details, run:

```bash
terraform init
terraform apply
```

## Troubleshooting

If you still encounter connection issues:

1. Verify your Kubernetes cluster is running:
   ```bash
   kubectl cluster-info
   ```

2. Check your kubectl configuration:
   ```bash
   kubectl config view
   ```

3. Ensure you have the correct credentials and permissions to access the cluster.

4. For the "no such host" error specifically:
   - Make sure you're using the correct API server endpoint (not the internal Kubernetes DNS name)
   - Verify that the hostname you're using is resolvable from your machine
   - Try using an IP address instead of a hostname if DNS resolution is problematic

## Summary of Changes

This configuration has been updated to address common connection issues:

1. The default value for `kubernetes_host` has been removed to prevent DNS resolution errors
2. Clear examples have been provided for different Kubernetes environments:
   - Minikube
   - Kind
   - EKS (AWS)
   - GKE (Google Cloud)
   - AKS (Azure)
3. Multiple options for configuration are provided:
   - Using terraform.tfvars
   - Using environment variables
   - Using kubeconfig files

Remember that the most important setting to get right is the `kubernetes_host` variable, which must point to a resolvable Kubernetes API server endpoint with the correct protocol (https://) and port.