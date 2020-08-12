terraform {
  backend "remote" {
    organization = "blakerandall"
    workspaces {
      name = "tf-do"
    }
  }

  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}

provider "digitalocean" {}

provider "kubernetes" {
  load_config_file       = false
  host                   = digitalocean_kubernetes_cluster.this.kube_config[0].host
  token                  = digitalocean_kubernetes_cluster.this.kube_config[0].token
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = digitalocean_kubernetes_cluster.this.kube_config[0].host
    token                  = digitalocean_kubernetes_cluster.this.kube_config[0].token
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
  }
}

resource "digitalocean_domain" "this" {
  for_each = { for domain in var.domain : domain => domain }

  name = each.value
}

resource "digitalocean_container_registry" "this" {
  name                   = var.container_registry
  subscription_tier_slug = var.container_registry_slug
}

resource "digitalocean_kubernetes_cluster" "this" {
  name          = var.kubernetes_cluster.name
  region        = var.kubernetes_cluster.region
  version       = var.kubernetes_cluster.version
  auto_upgrade  = var.kubernetes_cluster.auto_upgrade
  surge_upgrade = var.kubernetes_cluster.surge_upgrade

  node_pool {
    name       = var.kubernetes_cluster.node_pool.name
    size       = var.kubernetes_cluster.node_pool.size
    node_count = var.kubernetes_cluster.node_pool.node_count
    auto_scale = var.kubernetes_cluster.node_pool.auto_scale
    min_nodes  = var.kubernetes_cluster.node_pool.min_nodes
    max_nodes  = var.kubernetes_cluster.node_pool.max_nodes
  }
}
