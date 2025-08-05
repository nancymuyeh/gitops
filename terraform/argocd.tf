# 1. Create the namespace where Argo CD will live
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
  }
}

# 2. Install Argo CD using the official Helm chart
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.2" # Using a specific version for stability
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  # Wait for the namespace to be created before installing
  depends_on = [
    kubernetes_namespace.argocd
  ]
}