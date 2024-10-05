
environment  = "dev"
landing_zone = "cityagenda"
location     = "germanywestcentral"

#region Resource Groups
resource_groups = {
  default-eus = {
    prefix   = "rg"
    location = "germanywestcentral"
  }
  network-eus = {
    prefix   = "rg-network"
    location = "germanywestcentral"
  }
}

#region Virtual Networks
vnet_profile = {
  vnet-eus = {
    name             = "vnet-cityagenda-dev-gwc-001"
    address_space    = ["10.68.26.0/24"]
    route_table_name = "udr-cityagenda-dev-gwc-001"
    rg_key           = "network-eus"
    routes           = {}
    subnets = {
      appservice = {
        name                                          = "snet-appservice-cityagenda-dev-gwc-001"
        private_link_service_network_policies_enabled = false
        private_endpoint_network_policies_enabled     = false
        address_prefixes                              = ["10.68.26.0/27"]
        delegation = {
          name = "delegation"
          service_delegation = {
            name = "Microsoft.Web/serverFarms"
          }
        }
        nsg_name  = "nsg-appservice-cityagenda-dev-gwc-001"
        nsg_rules = []
      },
      mysql = {
        name                                          = "snet-mysql-cityagenda-dev-gwc-001"
        private_link_service_network_policies_enabled = false
        private_endpoint_network_policies_enabled     = false
        address_prefixes                              = ["10.68.26.32/28"]
        delegation = {
          name = "delegation"
          service_delegation = {
            name = "Microsoft.DBforMySQL/flexibleServers"
          }
        }
        nsg_name  = "nsg-mysql-cityagenda-dev-gwc-001"
        nsg_rules = []
      },
      snet_pe = {
        name                                          = "snet-app-cityagenda-dev-gwc-001"
        private_link_service_network_policies_enabled = false
        private_endpoint_network_policies_enabled     = true
        address_prefixes                              = ["10.68.26.48/28"]
        nsg_name                                      = "nsg-filestore-cityagenda-dev-gwc-001"
        nsg_rules                                     = []
      }
    }
  }
}

#storage
storage_profile = {
  name                              = "stacityagendagdevwc001"
  rg_key                            = "default-eus"
  account_kind                      = "StorageV2"
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  min_tls_version                   = "TLS1_2"
  shared_access_key_enabled         = false
  infrastructure_encryption_enabled = true
  container_list                    = []
}

#region Private Endpoints
private_endpoint = {
  pe_eus_storage = {
    name                 = "pe-storageaccount-cityagenda-dev-gwc-001"
    rg_key               = "default-eus"
    vnet_key             = "vnet-eus"
    snet_key             = "snet_pe"
    dns_key              = "blob"
    resource             = "storage_account"
    is_manual_connection = false
    subresource_names    = ["Blob"]
  }
  pe_eus_app = {
    name                 = "pe-app-cityagenda-dev-gwc-001"
    rg_key               = "default-eus"
    vnet_key             = "vnet-eus"
    snet_key             = "snet_pe"
    dns_key              = "webapp"
    resource             = "app"
    is_manual_connection = false
    subresource_names    = ["sites"]
  }
 pe_redis = {
    name                 = "pe-redis-cityagenda-dev-gwc-001"
    rg_key               = "default-eus"
    vnet_key             = "vnet-eus"
    snet_key             = "snet_pe"
    dns_key              = "redis"
    resource             = "redis"
    is_manual_connection = false
    subresource_names    = ["redisCache"]
  }
}

#webapp
app_service = {
  name                          = "app-cityagenda-dev-gwc-001"
  rg_key                        = "default-eus"
  vnet_key                      = "vnet-eus"
  snet_key                      = "appservice"
  env                           = "dev"
  docker_image_tag              = "latest"
  public_network_access_enabled = false
}

app_service_plan = {
  name   = "appservice-cityagenda-dev-gwc-001"
  rg_key = "default-eus"
}

app_insights = {
  name   = "appinsight-cityagenda-dev-gwc-001"
  rg_key = "default-eus"
}

log_analytics_workspace = {
  name   = "la-cityagenda-dev-gwc-001"
  rg_key = "default-eus"
}

mysql = {
  mysqlserver = {
    name            = "mysqlsvr-cityagenda-dev-gwc-001"
    rg_key          = "default-eus"
    vnet_key        = "vnet-eus"
    snet_key        = "mysql"
    nysql_databases = []
    mysql_zone      = "2"
  }
}
redis_server_settings = {
  name     = "redis-cityagenda-dev-gwc-001"
  sku_name = "Standard"
  capacity = 0
  enable_non_ssl_port = false
  rg_key              = "default-eus"
}
