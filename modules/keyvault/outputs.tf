output "azure_key_vault_id" {
  description = "azure keyvault id"
  value       = azurerm_key_vault.this.id
}

output "azure_key_vault_name" {
  description = "azure keyvault name"
  value       = azurerm_key_vault.this.name
}

output "disk_encryption_sets" {
  description = "disk encryption sets"
  value       = azurerm_disk_encryption_set.this
}

output "key_vault_keys" {
  value = tomap({ for key, value in azurerm_key_vault_key.this : key => { id = value.id } })
}