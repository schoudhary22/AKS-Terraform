data "azurerm_key_vault" "terraform_vault" {
  name                = var.keyvault_name
  resource_group_name = var.keyvault_rg
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "LinuxSSHPubKey"
  key_vault_id = data.azurerm_key_vault.terraform_vault.id
}

data "azurerm_key_vault_secret" "spn_id" {
  name         = "spn-id"
  key_vault_id = data.azurerm_key_vault.terraform_vault.id
}
data "azurerm_key_vault_secret" "spn_secret" {
  name         = "spn-secret"
  key_vault_id = data.azurerm_key_vault.terraform_vault.id
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_vnet_name
  resource_group_name = azurerm_resource_group.aks_demo_rg.name
  location            = azurerm_resource_group.aks_demo_rg.location
  address_space       = ["10.0.0.0/12"]
} 

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks_subnet"
  resource_group_name  = azurerm_resource_group.aks_demo_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes       = "10.1.0.0/16"
}


resource "azurerm_resource_group" "aks_demo_rg" {
  name     = var.resource_group
  location = var.azure_region
}

resource "azurerm_kubernetes_cluster" "aks_k2" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks_demo_rg.location
  resource_group_name = azurerm_resource_group.aks_demo_rg.name
  dns_prefix          = var.dns_name


  default_node_pool {
    name            = pool.value.name
    node_count      = pool.value.count
    vm_size         = pool.value.vm_size
    os_disk_size_gb = 30
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = data.azurerm_key_vault_secret.ssh_public_key.value
    }
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"     # Options are calico or azure - only if network plugin is set to azure
    dns_service_ip     = "172.16.0.10" # Required when network plugin is set to azure, must be in the range of service_cidr and above 1
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "172.16.0.0/16" # Must not overlap any address from the VNEt
  }


  role_based_access_control {
    enabled = true
  }

  service_principal {
    client_id     = data.azurerm_key_vault_secret.spn_id.value
    client_secret = data.azurerm_key_vault_secret.spn_secret.value
  }

  tags = {
    Environment = "Demo"
  }
}
