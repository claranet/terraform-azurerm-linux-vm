module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure_network_vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

module "azure_network_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.azure_network_vnet.virtual_network_name
  subnet_cidr_list     = ["10.10.10.0/24"]

  route_table_name = module.azure_network_route_table.route_table_name

  network_security_group_name = module.network_security_group.network_security_group_name
}

module "network_security_group" {
  source  = "claranet/nsg/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
}

module "azure_network_route_table" {
  source  = "claranet/route-table/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

resource "azurerm_availability_set" "vm_avset" {
  name                = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-as"
  location            = module.azure_region.location
  resource_group_name = module.rg.resource_group_name
  managed             = true
}

module "run" {
  source  = "claranet/run/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  monitoring_function_enabled = false
  vm_monitoring_enabled       = true
  backup_vm_enabled           = true
  update_center_enabled       = true

  update_center_periodic_assessment_enabled = true
  update_center_periodic_assessment_scopes  = [module.rg.resource_group_id]
  update_center_maintenance_configurations = [
    {
      configuration_name = "Donald"
      start_date_time    = "2021-08-21 04:00"
      recur_every        = "1Day"
    },
    {
      configuration_name = "Hammer"
      start_date_time    = "1900-01-01 03:00"
      recur_every        = "1Week"
    }
  ]

  recovery_vault_cross_region_restore_enabled = true
  vm_backup_daily_policy_retention            = 31
}

data "azuread_group" "vm_admins_group" {
  display_name = "Virtual Machines Admins"
}

data "azuread_group" "vm_users_group" {
  display_name = "Virtual Machines Users"
}

module "vm" {
  source  = "claranet/linux-vm/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name


  subnet_id      = module.azure_network_subnet.subnet_id
  vm_size        = "Standard_B2s"
  custom_name    = "app-${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-vm"
  admin_username = var.vm_administrator_login
  ssh_public_key = var.ssh_public_key

  diagnostics_storage_account_name      = module.run.logs_storage_account_name
  azure_monitor_data_collection_rule_id = module.run.data_collection_rule_id

  # Set to null to deactivate backup
  backup_policy_id = module.run.vm_backup_policy_id

  patch_mode                    = "AutomaticByPlatform"
  maintenance_configuration_ids = [module.run.maintenance_configurations["Donald"].id, module.run.maintenance_configurations["Hammer"].id]

  availability_set_id = azurerm_availability_set.vm_avset.id
  # or use Availability Zone
  # zone_id = 1

  vm_image = {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }

  storage_data_disk_config = {
    appli_data_disk = {
      name                 = "appli_data_disk"
      disk_size_gb         = 512
      lun                  = 0
      storage_account_type = "Standard_LRS"
      extra_tags = {
        some_data_disk_tag = "some_data_disk_tag_value"
      }
    }
    logs_disk = {
      # Used to define Logical Unit Number (LUN) parameter
      lun          = 10
      disk_size_gb = 64
      caching      = "ReadWrite"
      extra_tags = {
        some_data_disk_tag = "some_data_disk_tag_value"
      }
    }
  }

  aad_ssh_login_enabled           = true
  aad_ssh_login_admin_objects_ids = [data.azuread_group.vm_admins_group.object_id]
  aad_ssh_login_user_objects_ids  = [data.azuread_group.vm_users_group.object_id]
}
