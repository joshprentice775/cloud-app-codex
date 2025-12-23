resource "azurerm_resource_group" "lab" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "lab" {
  name                = var.vnet_name
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = [var.gateway_subnet_cidr]
}

resource "azurerm_subnet" "adds" {
  name                 = var.adds_subnet_name
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = [var.adds_subnet_cidr]

  delegation {
    name = "aadds"

    service_delegation {
      name = "Microsoft.AAD/domainServices"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_public_ip" "vpn" {
  name                = "${var.name_prefix}-vpn-pip"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_virtual_network_gateway" "vpn" {
  name                = "${var.name_prefix}-vng"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = var.vpn_gateway_sku

  active_active = false
  enable_bgp    = true

  ip_configuration {
    name                          = "vng-ipconfig"
    public_ip_address_id          = azurerm_public_ip.vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }

  bgp_settings {
    asn = var.azure_bgp_asn
  }
}

resource "azurerm_local_network_gateway" "onprem" {
  name                = "${var.name_prefix}-lng"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  gateway_address = var.onprem_vpn_public_ip
  address_space   = [var.onprem_cidr]

  bgp_settings {
    asn                 = var.onprem_bgp_asn
    bgp_peering_address = var.onprem_bgp_peering_address
  }
}

resource "azurerm_virtual_network_gateway_connection" "site_to_site" {
  name                = "${var.name_prefix}-s2s"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem.id

  shared_key = var.ipsec_shared_key
  enable_bgp = true
}

resource "azuread_domain_services" "adds" {
  name                = var.adds_name
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location

  domain_name           = var.adds_domain_name
  sku                   = var.adds_sku
  filtered_sync_enabled = false

  notification_settings {
    notify_global_admins  = true
    notify_dc_admins      = true
    additional_recipients = var.adds_notification_emails
  }

  subnet_id = azurerm_subnet.adds.id
}
