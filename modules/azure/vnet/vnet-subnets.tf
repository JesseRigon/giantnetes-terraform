resource "azurerm_virtual_network" "cluster_vnet" {
  name                = "${var.cluster_name}"
  resource_group_name = "${var.resource_group_name}"
  address_space       = ["${var.vnet_cidr}"]
  location            = "${var.location}"

  tags {
    Environment = "${var.cluster_name}"
  }
}

# NOTE: Using one subnet per role, because Azure does not have availability zones yet.
# They just released availability zones for public preview in two locations.
# https://azure.microsoft.com/en-us/updates/azure-availability-zones/

resource "azurerm_subnet" "bastion_subnet" {
  name                      = "${var.cluster_name}_bastion_subnet"
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${azurerm_virtual_network.cluster_vnet.name}"
  address_prefix            = "${cidrsubnet(var.vnet_cidr, 8, 0)}"
  network_security_group_id = "${azurerm_network_security_group.bastion.id}"
}

resource "azurerm_subnet" "vault_subnet" {
  name                      = "${var.cluster_name}_vault_subnet"
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${azurerm_virtual_network.cluster_vnet.name}"
  address_prefix            = "${cidrsubnet(var.vnet_cidr, 8, 1)}"
  network_security_group_id = "${azurerm_network_security_group.vault.id}"
}

resource "azurerm_subnet" "worker_subnet" {
  name                      = "${var.cluster_name}_worker_subnet"
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${azurerm_virtual_network.cluster_vnet.name}"
  address_prefix            = "${cidrsubnet(var.vnet_cidr, 8, 2)}"
  network_security_group_id = "${azurerm_network_security_group.worker.id}"
}