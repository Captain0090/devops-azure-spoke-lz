data "azurerm_client_config" "current" {
}

data "azurerm_private_dns_zone" "dns_zone" {
  for_each            = local.private_dns
  name                = each.value
  resource_group_name = local.private_dns_rg_name
  provider            = azurerm.platformconnectivity
}

data "azurerm_virtual_network" "connectivity" {
  name                = "vnet-hub-gwc-001"
  resource_group_name = "rg-network-hub-gwc-001"
  provider            = azurerm.platformconnectivity
}


