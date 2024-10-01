resource "azurerm_log_analytics_workspace" "la_workspace" {
  name                = var.log_analytics_workspace.name
  location            = module.resourcegroups[var.storage_profile.rg_key].rg_location
  resource_group_name = module.resourcegroups[var.log_analytics_workspace.rg_key].rg_name
  sku                 = "PerGB2018"
  tags                = local.tags
  retention_in_days   = 30
}
