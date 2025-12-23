output "vpn_gateway_public_ip" {
  description = "Public IP of the Azure VPN gateway."
  value       = azurerm_public_ip.vpn.ip_address
}

output "vpn_gateway_bgp_asn" {
  description = "BGP ASN for the Azure VPN gateway."
  value       = azurerm_virtual_network_gateway.vpn.bgp_settings[0].asn
}

output "resource_group" {
  description = "Resource group name."
  value       = azurerm_resource_group.lab.name
}
