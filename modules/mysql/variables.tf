variable "location" {
  type        = string
  description = "(Required) The Azure Region where the MySQL Flexible Server should exist. Changing this forces a new MySQL Flexible Server to be created."
}

variable "name" {
  type        = string
  description = "(Required) The name which should be used for this MySQL Flexible Server. Changing this forces a new MySQL Flexible Server to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where the MySQL Flexible Server should exist. Changing this forces a new MySQL Flexible Server to be created."
}

variable "administrator_login" {
  type        = string
  description = "(Optional) The Administrator login for the MySQL Flexible Server. Required when create_mode is Default. Changing this forces a new MySQL Flexible Server to be created."
}

variable "mysql_zone" {
  type        = string
  description = "(Optional) Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are 1, 2 and 3."
}

variable "administrator_password" {
  type        = string
  description = "(Optional) The Password associated with the administrator_login for the MySQL Flexible Server. Required when create_mode is Default."
}

variable "backup_retention_days" {
  type        = number
  description = "(Optional) The backup retention days for the MySQL Flexible Server. Possible values are between 1 and 35 days. Defaults to 7."
  default     = 35
}

variable "create_mode" {
  type        = string
  description = "(Optional)The creation mode which can be used to restore or replicate existing servers. Possible values are Default, PointInTimeRestore, GeoRestore, and Replica. Changing this forces a new MySQL Flexible Server to be created."
  default     = "Default"
}

variable "delegated_subnet_id" {
  type        = string
  description = "(Optional) The ID of the virtual network subnet to create the MySQL Flexible Server. Changing this forces a new MySQL Flexible Server to be created."
  default     = null
}

variable "geo_redundant_backup_enabled" {
  type        = string
  description = " (Optional) Should geo redundant backup enabled? Defaults to false. Changing this forces a new MySQL Flexible Server to be created."
  default     = false
}

variable "private_dns_zone_id" {
  type        = string
  description = "(Optional) The ID of the private DNS zone to create the MySQL Flexible Server. Changing this forces a new MySQL Flexible Server to be created."
  default     = null
}

variable "sku_name" {
  type        = string
  description = "(Optional) The SKU Name for the MySQL Flexible Server."
  default     = "GP_Standard_D2ds_v4"
}

variable "mysql_version" {
  type        = string
  description = "(Optional) The version of the MySQL Flexible Server to use. Possible values are 5.7, and 8.0.21. Changing this forces a new MySQL Flexible Server to be created."
  default     = "8.0.21"
}

variable "high_availability_mode" {
  type        = string
  description = "(Required) The high availability mode for the MySQL Flexible Server. Possibles values are SameZone and ZoneRedundant."
  default     = "SameZone"
}


variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "enable ManagedIndentity or system assigned identity."
  default     = null
}

variable "storage" {
  type = object({
    auto_grow_enabled  = optional(bool, true)
    io_scaling_enabled = optional(bool, false)
    iops               = optional(number, 360)
    size_gb            = optional(number, 20)
  })
  description = "(Optional) A storage definition for the mysql flexi server."
}

variable "nysql_databases" {
  type        = list(string)
  description = "list of databases to be created in the mysql server."
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
