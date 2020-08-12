variable "domain" {
  type = list(string)
  default = [
    "randall.family",
    "theoneblk.xyz"
  ]
}

variable "container_registry" {
  type    = string
  default = "repository"
}

variable "container_registry_slug" {
  type    = string
  default = "basic"
}

variable "kubernetes_cluster" {
  type = object({
    name          = string
    region        = string
    version       = string
    auto_upgrade  = bool
    surge_upgrade = bool
    node_pool = object({
      name       = string
      size       = string
      node_count = number
      auto_scale = bool
      min_nodes  = number
      max_nodes  = number
    })
  })
  default = {
    name          = "k8s-1-18-3-do-0-tor1-1595030703060"
    region        = "tor1"
    version       = "1.18.14-do.0"
    auto_upgrade  = true
    surge_upgrade = false
    node_pool = {
      name       = "pool-1cmvcj203"
      size       = "s-1vcpu-2gb"
      auto_scale = true
      node_count = 2
      min_nodes  = 2
      max_nodes  = 4
    }
  }
}
