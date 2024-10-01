resource "azurerm_mysql_flexible_server" "default" {
  location                     = var.location
  name                         = var.name
  resource_group_name          = var.resource_group_name
  administrator_login          = var.administrator_login
  administrator_password       = var.administrator_password
  backup_retention_days        = var.backup_retention_days
  delegated_subnet_id          = var.delegated_subnet_id
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  private_dns_zone_id          = var.private_dns_zone_id
  sku_name                     = var.sku_name
  version                      = var.mysql_version
  create_mode                  = var.create_mode

  high_availability {
    mode = var.high_availability_mode
  }
  storage {
    auto_grow_enabled  = var.storage.auto_grow_enabled
    io_scaling_enabled = var.storage.io_scaling_enabled
    iops               = var.storage.io_scaling_enabled ? null : var.storage.iops
    size_gb            = var.storage.size_gb
  }
  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.type == "SystemAssigned" ? [] : identity.value.identity_ids
    }
  }
  tags = var.tags
}

# Manages the MySQL Flexible Server Database
resource "azurerm_mysql_flexible_database" "main" {
  for_each            = { for idx, value in var.nysql_databases : "${idx}" => value }
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
  name                = each.value
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.default.name
}