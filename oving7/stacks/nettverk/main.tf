terraform {
  required_version = ">= 1.5.0"
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  base_name = lower(format("%s-%s-%s", var.project, var.environment, var.shortname))
  tags = {
    environment = var.environment
    owner       = var.shortname
    project     = var.project
    managedby   = "terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = format("rg-%s", local.base_name)
  location = var.location
  tags     = local.tags
}

module "network" {
  source = "../../modules/network"

  rg_name        = azurerm_resource_group.rg.name
  location       = var.location
  base_name      = local.base_name
  address_space  = var.address_space
  subnets        = var.subnets
  subnet_newbits = var.subnet_newbits
  tags           = local.tags
}
