
resource "azurerm_network_interface" "linux-nic" {
  name                = "linux-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

data "azurerm_image" "customngnix" {
  name                = "linux-image"
  resource_group_name = "rg"
}



resource "azurerm_linux_virtual_machine" "linuxVM" {
  name                = "linuxVM"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.linux-nic.id,
  ]

source_image_id = data.azurerm_image.customngnix.id

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  #   ## USE THE CUSTOM IMAGE
  # storage_image_reference {
  # id = "${data.azurerm_image.customngnix.id}"
  # }



  #   source_image_id = data.azurerm_image.linux.id

  #   source_image_reference {
  #     publisher = "Canonical"
  #     offer     = "0001-com-ubuntu-server-jammy"
  #     sku       = "22_04-lts"
  #     version   = "latest"
  #   }
}
