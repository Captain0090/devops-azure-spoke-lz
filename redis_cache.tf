resource "azurerm_redis_cache" "this" {
  name                          = var.redis_server_settings.name
  resource_group_name           = module.resourcegroups[var.redis_server_settings.rg_key].rg_name
  location                      = module.resourcegroups[var.redis_server_settings.rg_key].rg_location
  capacity                      = var.redis_server_settings["capacity"]
  family                        = lookup(var.redis_family, var.redis_server_settings.sku_name)
  sku_name                      = var.redis_server_settings["sku_name"]
  enable_non_ssl_port           = var.redis_server_settings["enable_non_ssl_port"]
  minimum_tls_version           = var.redis_server_settings["minimum_tls_version"]
  private_static_ip_address     = var.redis_server_settings["private_static_ip_address"]
  public_network_access_enabled = var.redis_server_settings["public_network_access_enabled"]
  replicas_per_master           = var.redis_server_settings["sku_name"] == "Premium" ? var.redis_server_settings["replicas_per_master"] : null
  shard_count                   = var.redis_server_settings["sku_name"] == "Premium" ? var.redis_server_settings["shard_count"] : null
  subnet_id                     = var.redis_server_settings["sku_name"] == "Premium" ? lookup(module.network[var.app_service.vnet_key].subnet_id_list, "redis") : null
  zones                         = var.redis_server_settings["zones"]
  tags                          = local.tags

  redis_configuration {
    enable_authentication           = lookup(var.redis_configuration, "enable_authentication", true)
    maxfragmentationmemory_reserved = var.redis_server_settings["sku_name"] == "Premium" || var.redis_server_settings["sku_name"] == "Standard" ? lookup(var.redis_configuration, "maxfragmentationmemory_reserved") : null
    maxmemory_delta                 = var.redis_server_settings["sku_name"] == "Premium" || var.redis_server_settings["sku_name"] == "Standard" ? lookup(var.redis_configuration, "maxmemory_delta") : null
    maxmemory_policy                = lookup(var.redis_configuration, "maxmemory_policy")
    maxmemory_reserved              = var.redis_server_settings["sku_name"] == "Premium" || var.redis_server_settings["sku_name"] == "Standard" ? lookup(var.redis_configuration, "maxmemory_reserved") : null
    notify_keyspace_events          = lookup(var.redis_configuration, "notify_keyspace_events")
    rdb_backup_enabled              = var.redis_server_settings["sku_name"] == "Premium" && var.enable_data_persistence == true ? true : false
    rdb_backup_frequency            = var.redis_server_settings["sku_name"] == "Premium" && var.enable_data_persistence == true ? var.data_persistence_backup_frequency : null
    rdb_backup_max_snapshot_count   = var.redis_server_settings["sku_name"] == "Premium" && var.enable_data_persistence == true ? var.data_persistence_backup_max_snapshot_count : null
    rdb_storage_connection_string   = var.redis_server_settings["sku_name"] == "Premium" && var.enable_data_persistence == true ? module.storage_account.storage_primary_connection_string : null
  }

  dynamic "patch_schedule" {
    for_each = var.patch_schedule != null ? [var.patch_schedule] : []
    content {
      day_of_week    = var.patch_schedule.day_of_week
      start_hour_utc = var.patch_schedule.start_hour_utc
    }
  }

  lifecycle {
    # A bug in the Redis API where the original storage connection string isn't being returneds
    ignore_changes = [redis_configuration.0.rdb_storage_connection_string]
  }
}
