terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias                      = "platformconnectivity"
  subscription_id            = local.platform_subid
  skip_provider_registration = true
}

provider "azapi" {
  use_oidc = true
}
