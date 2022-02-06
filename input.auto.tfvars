aks_vnet_name = "aksvnet"

keyvault_rg = "Lab-RG"

keyvault_name = "demo-azurekv"

azure_region = "australiaeast"

resource_group = "AKSCluster-RG"

cluster_name = "AKSTerraform"

dns_name = "AKSTerraform"

admin_username = "aksadmin"

kubernetes_version = "1.21.7"

agent_pools = {
      name            = "pool1"
      count           = 2
      vm_size         = "Standard_D2_v2"
      os_disk_size_gb = "30"
    }
