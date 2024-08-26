variable "client_id" {
  type    = string
  default = "################################"
}

variable "client_secret" {
  type    = string
  default = "####################################"
}

variable "tenant_id" {
  type    = string
  default = "####################################"
}

variable "subscription_id" {
  type    = string
  default = "######################################"
}

source "azure-arm" "linux" {
  client_id        = var.client_id
  client_secret    = var.client_secret
  tenant_id        = var.tenant_id
  subscription_id  = var.subscription_id

  managed_image_resource_group_name = "rg"
  managed_image_name                = "linux-image"
#   location                          = "West US"
 

  os_type                            = "Linux"
  image_publisher                    = "Canonical"
  image_offer                        = "UbuntuServer"
  image_sku                          = "18.04-LTS"
  azure_tags = {
    "dept" = "Engineering"
    "env"  = "Test"
  }

  build_resource_group_name          = "rg"
  vm_size                            = "Standard_D2s_v3"
}

build {
  sources = ["source.azure-arm.linux"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y nginx"
    ]
  }
}
