output "subnet_ids" {
  value = module.nettverk.subnet_ids
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
