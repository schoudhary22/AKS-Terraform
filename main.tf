data "azurerm_key_vault" "azure_vault" {
  name                = var.keyvault_name
  resource_group_name = var.keyvault_rg
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name         = var.sshkvsecret
  key_vault_id = data.azurerm_key_vault.azure_vault.id
}

data "azurerm_key_vault_secret" "spn_id" {
  name         = var.clientidkvsecret
  key_vault_id = data.azurerm_key_vault.azure_vault.id
}
data "azurerm_key_vault_secret" "spn_secret" {
  name         = var.spnkvsecret
  key_vault_id = data.azurerm_key_vault.azure_vault.id
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_vnet_name
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  address_space       = var.vnetcidr
} 

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks_subnet"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes       = var.subnetcidr
}


resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group
  location = var.azure_region
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = var.dns_name


  default_node_pool {
    name            = var.agent_pools.name
    node_count      = var.agent_pools.count
    vm_size         = var.agent_pools.vm_size
    os_disk_size_gb = var.agent_pools.os_disk_size_gb
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = data.azurerm_key_vault_secret.ssh_public_key.value
    }
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
