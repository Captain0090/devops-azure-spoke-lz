locals {
  name_suffix = "${var.landing_zone}-${var.environment}"
  locationshortname = {
    germanywestcentral = "gwc"
  }
  tags = {
    "Environment" : var.environment
  }

  platform_subid      = "b45478e3-5ce4-4658-81f0-af100e88b478"
  private_dns_rg_name = "rg-dns-hub-gwc-001"
  access_policies = {
    policy = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azurerm_client_config.current.object_id
      key_permissions         = ["Get", "Create", "Delete", "Import", "List", "Purge", "Recover", "GetRotationPolicy", "SetRotationPolicy", "UnwrapKey", "WrapKey"]
      secret_permissions      = ["Get", "Set", "Delete", "List", "Purge", "Recover"]
      certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge"]
    }
  }
  secrets = {

  }

  resource_ids = {
    kv              = try(module.keyvaults["kv"].azure_key_vault_id, null)
    storage_account = module.storage_account.storage_account_id
    app             = module.app_service.app_service.id
  }

  auth_settings = {
    enabled                       = false
    token_refresh_extension_hours = 0
  }

  private_dns = {
    webapp    = "privatelink.azurewebsites.net"
    key_vault = "privatelink.vaultcore.azure.net"
    blob      = "privatelink.blob.core.windows.net"
    mysql     = "privatelink.mysql.database.azure.com"
  }

  network_peering_settings_hub = {
    allow_forwarded_traffic      = true
    allow_gateway_transit        = true
    allow_virtual_network_access = true
    use_remote_gateways          = false
  }
  network_peering_settings_spoke = {
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    allow_virtual_network_access = true
    use_remote_gateways          = true
  }
  vnet_peering_v1 = {
    peer-to-platform-conn = {
      name = "vnet-hub-gwc-oo1-${var.vnet_profile["vnet-eus"].name}"
      from = {
        id = data.azurerm_virtual_network.connectivity.id
      }
      to = {
        id = module.network["vnet-eus"].vnet_id
      }
      settings = local.network_peering_settings_hub
    }
    peer-subvnet-to-platform-conn = {
      name = "vnet-hub-gwc-oo1-${var.vnet_profile["vnet-eus"].name}"
      from = {
        id = module.network["vnet-eus"].vnet_id
      }
      to = {
        id = data.azurerm_virtual_network.connectivity.id
      }
      settings = local.network_peering_settings_spoke
    }
  }
}