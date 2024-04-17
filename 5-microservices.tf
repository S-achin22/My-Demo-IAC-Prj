# K8s Deployment for a microservice 
# Reference :https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider?variants=kubernetes%3Aeks

resource "kubernetes_deployment" "microservice1" {
  metadata {
    name = "microservice1"
    labels = {
      app = "microservice1"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "microservice1"
      }
    }
    template {
      metadata {
        labels = {
          app = "microservice1"
        }
      }
      spec {
        container {
          image = "your-registry-url/microservice1:latest"
          name  = "microservice1"
          
          port {
            container_port = 8080
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

# Define Kubernetes Service for Microservice 1
resource "kubernetes_service" "microservice1" {
  metadata {
    name = "microservice1"
  }

  spec {
    selector = {
      app = "microservice1"
    }

    port {
      port        = 80
      target_port = 8080
    }
    # Define type as "ClusterIP", "NodePort", or "LoadBalancer" depending on your needs
    type = "Loadbalancer"
  }
}

resource "kubernetes_deployment" "microservice2" {
  metadata {
    name = "microservice2"
    labels = {
      app = "microservice2"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "microservice2"
      }
    }
    template {
      metadata {
        labels = {
          app = "microservice2"
        }
      }
      spec {
        container {
          image = "your-registry-url/microservice2:latest"
          name  = "microservice2"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "microservice2" {
  metadata {
    name = "microservice2"
  }

  spec {
    selector = {
      app = "microservice2"
    }

    port {
      port        = 80
      target_port = 8081
    }
    type = "Loadbalancer"
  }
}




# Define Kubernetes Ingress for Microservice 1
resource "kubernetes_ingress" "app-ingress" {
  metadata {
    name = "app-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "microservice1.example.com"
      http {
        path {
          path = "/microservice1"
          backend {
            service_name = kubernetes_service.microservice1.metadata[0].name
            service_port = kubernetes_service.microservice1.spec[0].port[0].port
          }
        }
        path {
          path = "/microservice2"
          backend {
            service_name = kubernetes_service.microservice2.metadata[0].name
            service_port = kubernetes_service.microservice2.spec[0].port[0].port
          }
        }
      }
    }
  }
}
