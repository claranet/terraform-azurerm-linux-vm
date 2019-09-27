resource "azurerm_public_ip" "public_ip" {
  name                = coalesce(var.custom_public_ip_name, "${local.vm_name}-pubip")
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = coalesce(var.custom_dns_label, local.vm_name)

  tags = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_network_interface" "nic" {
  name                = coalesce(var.custom_nic_name, "${local.vm_name}-nic")
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${local.vm_name}-nic-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = merge(local.default_tags, var.extra_tags)
}

