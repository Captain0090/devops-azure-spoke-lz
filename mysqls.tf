module "mysql" {
  source                 = "./modules/mysql"
  for_each               = var.mysql
  name                   = each.value.name
  location               = module.resourcegroups[var.storage_profile.rg_key].rg_location
  resource_group_name    = module.resourcegroups[var.storage_profile.rg_key].rg_name
  administrator_login    = each.value.administrator_login
  administrator_password = random_password.password.result
  delegated_subnet_id    = lookup(module.network[each.value.vnet_key].subnet_id_list, each.value.snet_key, null)
  private_dns_zone_id    = data.azurerm_private_dns_zone.dns_zone["mysql"].id
  tags                   = local.tags
  nysql_databases        = each.value.nysql_databases
  identity = {
    type = "SystemAssigned"
  }
  storage = each.value.storage
}


resource "random_password" "password" {
  length           = 8
  lower            = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  numeric          = true
  override_special = "_"
  special          = true
  upper            = true
}