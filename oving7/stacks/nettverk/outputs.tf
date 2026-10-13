output "subnet_ids" {
  value       = module.network.subnet_ids
  description = "En mappe med subnett-ID-er, der nøkkelen er subnettnavnet."
}

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Navnet på ressursgruppa som inneholder nettverksressursene."
}
