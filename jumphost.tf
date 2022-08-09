locals {
  jumphost_image_reference = split(":", var.jumphost_image_reference)
}

resource "azurerm_network_interface" "jumphost" {
  name                    = "nic-${local.resource_suffix}-${var.jumphost_computer_name}"
  resource_group_name     = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  internal_dns_name_label = var.jumphost_computer_name

  ip_configuration {
    name                          = "primary"
    primary                       = true
    subnet_id                     = azurerm_subnet.jumphost.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_ssh_public_key" "jumphost" {
  name                = "ssh-${local.resource_suffix}-${var.jumphost_computer_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  public_key          = file(var.public_key_path)
}

resource "azurerm_linux_virtual_machine" "jumphost" {
  name                            = "vm-${local.resource_suffix}-${var.jumphost_computer_name}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  computer_name                   = var.jumphost_computer_name
  admin_username                  = var.jumphost_admin_username
  disable_password_authentication = true
  size                            = var.jumphost_size

  network_interface_ids = [
    azurerm_network_interface.jumphost.id
  ]

  admin_ssh_key {
    username   = var.jumphost_admin_username
    public_key = azurerm_ssh_public_key.jumphost.public_key
  }

  os_disk {
    name                 = "osdisk-${local.resource_suffix}-${var.jumphost_computer_name}"
    disk_size_gb         = 32
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"

    diff_disk_settings {
      placement = "ResourceDisk"
      option    = "Local"
    }
  }

  source_image_reference {
    publisher = local.jumphost_image_reference.0
    offer     = local.jumphost_image_reference.1
    sku       = local.jumphost_image_reference.2
    version   = local.jumphost_image_reference.3
  }
}
