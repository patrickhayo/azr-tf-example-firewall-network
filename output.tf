output "basion" {
  description = "Basiton Host Module Settings (deployed)."
  value       = module.bastion_host
}

output "nat" {
  description = "NAT Gateway Module Settings (deployed)."
  value       = module.nat
}

output "network" {
  description = "VNET Module Settings (deployed)."
  value       = module.network
}

output "nsgs" {
  description = "NSG Module Settings (deployed)."
  value       = module.nsg
}

output "privatednszone" {
  description = "Private DNZ Zone Module Settings (deployed)."
  value       = module.privatednszone
}

output "route_tables" {
  description = "Route Table Module Settings (deployed)."
  value       = module.rt
}
