module "network" {
  for_each            = var.vnet_profile
  source              = "./modules/network"
  name                = each.value.name
  location            = module.resourcegroups[each.value.rg_key].rg_location
  resource_group_name = module.resourcegroups[each.value.rg_key].rg_name

  address_space    = each.value.address_space
  route_table_name = each.value.route_table_name
  routes           = each.value.routes
  subnets          = each.value.subnets
  tags             = local.tags
}

#peering hub and spke vnet
resource "azapi_resource" "peering" {
  type      = "Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01"
  for_each  = local.vnet_peering_v1
  name      = each.value.name
  parent_id = each.value.from.id
  body = jsonencode({
    properties = {
      allowForwardedTraffic     = try(each.value.settings.allow_forwarded_traffic, false)
      allowGatewayTransit       = try(each.value.settings.allow_gateway_transit, false)
      allowVirtualNetworkAccess = try(each.value.settings.allow_virtual_network_access, true)
      doNotVerifyRemoteGateways = try(each.value.settings.do_not_verify_remote_gateways, false)
      useRemoteGateways         = try(each.value.settings.use_remote_gateways, false)
      remoteVirtualNetwork = {
        id = each.value.to.id
      }
    }
  })
}
