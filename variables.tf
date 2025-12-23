variable "location" {
  type        = string
  description = "Azure region for the lab environment."
  default     = "westus"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for lab resources."
  default     = "rg-lab-network"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for naming lab resources."
  default     = "lab"
}

variable "vnet_name" {
  type        = string
  description = "Virtual network name."
  default     = "vnet-lab"
}

variable "vnet_cidr" {
  type        = string
  description = "Virtual network address space."
  default     = "10.20.0.0/16"
}

variable "gateway_subnet_cidr" {
  type        = string
  description = "Gateway subnet CIDR."
  default     = "10.20.0.0/27"
}

variable "adds_subnet_name" {
  type        = string
  description = "Subnet name for Entra AD DS."
  default     = "snet-aadds"
}

variable "adds_subnet_cidr" {
  type        = string
  description = "Subnet CIDR for Entra AD DS."
  default     = "10.20.1.0/24"
}

variable "vpn_gateway_sku" {
  type        = string
  description = "VPN gateway SKU."
  default     = "VpnGw1"
}

variable "azure_bgp_asn" {
  type        = number
  description = "BGP ASN for Azure VPN gateway."
  default     = 65515
}

variable "onprem_vpn_public_ip" {
  type        = string
  description = "Public IP address of the on-prem FortiGate device."
}

variable "onprem_cidr" {
  type        = string
  description = "On-premises address space."
  default     = "10.10.0.0/16"
}

variable "onprem_bgp_asn" {
  type        = number
  description = "BGP ASN for the on-prem FortiGate device."
}

variable "onprem_bgp_peering_address" {
  type        = string
  description = "BGP peering address on the on-prem FortiGate device."
}

variable "ipsec_shared_key" {
  type        = string
  description = "Pre-shared key for the IPSec tunnel."
  sensitive   = true
}

variable "adds_name" {
  type        = string
  description = "Azure AD Domain Services resource name."
  default     = "adds-lab"
}

variable "adds_domain_name" {
  type        = string
  description = "Managed domain name for Azure AD Domain Services."
  default     = "lab.local"
}

variable "adds_sku" {
  type        = string
  description = "SKU for Azure AD Domain Services."
  default     = "Standard"
}

variable "adds_notification_emails" {
  type        = list(string)
  description = "Notification email addresses for Azure AD Domain Services."
  default     = []
}
