resource "azurerm_key_vault_key" "this" {
  for_each        = var.keys_list
  name            = each.value.key_name
  key_vault_id    = azurerm_key_vault.this.id
  key_type        = each.value.key_type
  key_size        = each.value.key_size
  expiration_date = each.value.expiration_date == null ? time_offset.expiry_date.rfc3339 : each.value.expiration_date
  key_opts        = each.value.key_opts
  rotation_policy {
    automatic {
      time_after_creation = "P18M"
    }

    expire_after         = "P2Y"
    notify_before_expiry = "P30D"
  }
  tags = var.tags
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "time_offset" "expiry_date" {
  offset_years = 2
}
