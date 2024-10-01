output "mysql-fqdn" {
  description = "The fully qualified domain name of the MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.default.fqdn
}

output "mysql-id" {
  description = "The ID of the MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.default.id
}

output "mysql-name" {
  description = "The name of the MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.default.name
}

output "mysql-administrator-login" {
  description = "The administrator_login  of the MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.default.administrator_login
}

output "mysql-administrator-password" {
  description = "The administrator_login  of the MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.default.administrator_password
}