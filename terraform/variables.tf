variable "argocd_namespace" {
  description = "Namespace for Argo CD"
  type        = string
  default     = "argocd"
}

# Kubernetes connection variables
variable "kubernetes_host" {
  description = "The Kubernetes API server endpoint"
  type        = string
  # For Minikube, use: https://$(minikube ip):8443
  # For local kind cluster, use: https://127.0.0.1:6443
  # For remote clusters, use the appropriate endpoint URL
  default     = ""  # No default - must be explicitly set
}

variable "kubernetes_client_certificate" {
  description = "PEM-encoded client certificate for TLS authentication"
  type        = string
  default     = ""
  sensitive   = true
}

variable "kubernetes_client_key" {
  description = "PEM-encoded client key for TLS authentication"
  type        = string
  default     = ""
  sensitive   = true
}

variable "kubernetes_cluster_ca_certificate" {
  description = "PEM-encoded root certificates bundle for TLS authentication"
  type        = string
  default     = ""
  sensitive   = true
}