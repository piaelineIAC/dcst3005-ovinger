terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

locals {
  computer_name = substr(replace(var.base_name, "-", ""), 0, 15)
}

resource "azurerm_network_interface" "nic" {
  name                = format("nic-%s", var.base_name)
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  ip_configuration {
    name = "internal"

    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = format("vm-%s", var.base_name)
  computer_name       = local.computer_name
  location            = var.location
  resource_group_name = var.rg_name

  size = var.vm_size

  encryption_at_host_enabled = true
  allow_extension_operations = false

  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = var.tags
}