locals {
  custom_public_ip_adress_id_parsed = provider::azurerm::parse_resource_id(var.custom_public_ip_address_id)
  public_ip                         = concat(azurerm_public_ip.main[*], data.azurerm_public_ip.public_ip[*])
}


data "azurerm_public_ip" "public_ip" {
  count = var.custom_public_ip_address_id == null ? 0 : 1

  name                = local.custom_public_ip_adress_id_parsed.resource_name
  resource_group_name = local.custom_public_ip_adress_id_parsed.resource_group_name
}

resource "azurerm_public_ip" "main" {
  count = var.public_ip_enabled && var.custom_public_ip_address_id == null ? 1 : 0

  name     = local.public_ip_name
  location = var.location

  resource_group_name = var.resource_group_name

  sku               = "Standard"
  allocation_method = "Static"
  domain_name_label = coalesce(var.custom_dns_label, local.name)
  zones             = var.public_ip_zones

  tags = merge(local.default_tags, var.extra_tags, var.public_ip_extra_tags)
}

moved {
  from = azurerm_public_ip.public_ip
  to   = azurerm_public_ip.main
}

resource "azurerm_network_interface" "main" {
  name                = local.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  accelerated_networking_enabled = var.nic_accelerated_networking_enabled

  ip_configuration {
    name                          = local.ip_configuration_name
    subnet_id                     = var.subnet.id
    private_ip_address_allocation = var.static_private_ip == null ? "Dynamic" : "Static"
    private_ip_address            = var.static_private_ip
    public_ip_address_id          = one(local.public_ip[*].id)
  }

  dns_servers = var.dns_servers

  tags = merge(local.default_tags, var.extra_tags, var.nic_extra_tags)
}

moved {
  from = azurerm_network_interface.nic
  to   = azurerm_network_interface.main
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count = var.load_balancer_attachment != null ? 1 : 0

  backend_address_pool_id = var.load_balancer_attachment.id
  ip_configuration_name   = local.ip_configuration_name
  network_interface_id    = azurerm_network_interface.main.id
}

moved {
  from = azurerm_network_interface_backend_address_pool_association.lb_pool_association
  to   = azurerm_network_interface_backend_address_pool_association.main
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "main" {
  count = var.application_gateway_attachment != null ? 1 : 0

  backend_address_pool_id = var.application_gateway_attachment.id
  ip_configuration_name   = local.ip_configuration_name
  network_interface_id    = azurerm_network_interface.main.id
}

moved {
  from = azurerm_network_interface_application_gateway_backend_address_pool_association.appgw_pool_association
  to   = azurerm_network_interface_application_gateway_backend_address_pool_association.main
}
