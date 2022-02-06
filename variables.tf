variable "aks_vnet_name" {
    type = string
    default = "aksvnet"
}

#KeyVault Resource Group and KeyVaultName
variable "keyvault_rg" {
  type    = string
  default = "Lab-RG"
}
variable "keyvault_name" {
  type    = string
  default = "demo-azurekv"
}

variable "azure_region" {
  type    = string
  default = "australiaeast"
}

#  Resource Group Name
variable "resource_group" {
  type    = string
  default = "AKSCluster-RG"
}

# AKS Cluster name
variable "cluster_name" {
  type    = string
  default = "AKSTerraform"
}

#AKS DNS name
variable "dns_name" {
  type    = string
  default = "AKSTerraform"
}

variable "admin_username" {
  type    = string
  default = "aksadmin"
}

# Specify a valid kubernetes version
variable "kubernetes_version" {
  type    = string
  default = "1.21.7"
}

#AKS Agent pools
variable "agent_pools" {
  default = {
      name            = "pool1"
      count           = 2
      vm_size         = "Standard_D1_v2"
      os_type         = "Linux"
      os_disk_size_gb = "30"
    }
}
