terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  # Configure with your cluster details (e.g., kubeconfig)
  # For Minikube, use: config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "node_app" {
  metadata {
    name = "node-app"
    labels = {
      app = "node-app"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "node-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "node-app"
        }
      }
      spec {
        container {
          image = "merajansari87/node-app:latest"
          name  = "node-app"
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "node_app" {
  metadata {
    name = "node-app-service"
  }
  spec {
    selector = {
      app = "node-app"
    }
    port {
      port        = 80
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}
