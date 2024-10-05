module "app_service" {
  source                     = "./modules/app_service"
  name                       = var.app_service.name
  rg_name                    = module.resourcegroups[var.app_service.rg_key].rg_name
  location                   = module.resourcegroups[var.app_service.rg_key].rg_location
  asp_id                     = module.app_service_plan.id
  log_analytics_workspace_id = resource.azurerm_log_analytics_workspace.la_workspace.id
  env                        = var.app_service.env
  auth_settings              = local.auth_settings

  settings = {
    site_config = {
      application_stack = {
        php_version = "8.3"
      }
    }
  }

  virtual_network_subnet_id = lookup(module.network[var.app_service.vnet_key].subnet_id_list, var.app_service.snet_key)
  identity_type             = "SystemAssigned"

  role_assignments = {}

  allowed_origins = var.app_service.allowed_origins

  app_service_settings = {
    STORAGE_CONNECTION_STRING      = module.storage_account.storage_primary_connection_string
    MYSQL_SERVER_PASSWORD          = module.mysql["mysqlserver"].mysql-administrator-password
    MYSQL_SERVER_HOSTNAME          = module.mysql["mysqlserver"].mysql-fqdn
    MYSQL_SERVER_USERNAME          = module.mysql["mysqlserver"].mysql-administrator-login
    APPINSIGHTS_INSTRUMENTATIONKEY = module.app_insights.instrumentation_key
  }

  log_analytics_destination_type = "AzureDiagnostics"
  tags                           = local.tags
  depends_on                     = [module.app_service_plan]
  public_network_access_enabled  = var.app_service.public_network_access_enabled
}
