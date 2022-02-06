aks_vnet_name = "aksvnet"

keyvault_rg = "Lab-RG"

keyvault_name = "demo-azurekv"

azure_region = "australiaeast"

resource_group = "AKSCluster-RG"

cluster_name = "AKSTerraform"

dns_name = "AKSTerraform"

admin_username = "aksadmin"

kubernetes_version = "1.21.7"

agent_pools = object({
      name            = string
      count           = number
      vm_size         = string
      os_disk_size_gb = string
    }
  )
