
# Creates the Resource Group for our entire project
resource "azurerm_resource_group" "lb_rg" {
    name = var.rg # name of the resource azurerm_resource_group
    location = var.loc # Azure region where it will be deployed
}

# Creates the Virtual Network
resource "azurerm_virtual_network" "vnet" {
    name = var.vnet
    location = var.loc
    resource_group_name = var.rg
    address_space = ["10.1.0.0/16"]

    depends_on = [azurerm_resource_group.lb_rg]

}
    
# Creates the Backend pool subnet
resource "azurerm_subnet" "backsubnet" {
    name = var.backsubnet
    resource_group_name = var.rg
    virtual_network_name = var.vnet
    address_prefixes = ["10.1.0.0/24"]

    depends_on = [azurerm_virtual_network.vnet]
}

# Creates the Azure Bastion subnet
resource "azurerm_subnet" "bastionsubnet" {
    name = var.bastionsubnet
    resource_group_name = var.rg
    virtual_network_name = var.vnet
    address_prefixes = ["10.1.1.0/27"]

    depends_on = [azurerm_virtual_network.vnet]
}



# Creates the Public IPs for our resources

resource "azurerm_public_ip" "lbpip" {
    name = var.lbpip
    resource_group_name = var.rg
    location = var.loc
    allocation_method = "Static"

    depends_on = [azurerm_resource_group.lb_rg]
}

resource "azurerm_public_ip" "bpip" {
    name = var.bpip
    resource_group_name = var.rg
    location = var.loc
    allocation_method = "Static"

    depends_on = [azurerm_resource_group.lb_rg]
}

resource "azurerm_public_ip" "natpip" {
    name = var.natpip
    resource_group_name = var.rg
    location = var.loc
    allocation_method = "Static"

    depends_on = [azurerm_resource_group.lb_rg]
}

# Creates the Network Security Group

resource "azurerm_network_security_group" "nsg" {
    name = var.nsg
    location = var.loc
    resource_group_name = var.rg

    security_rule {
        name = "myNSGRuleHTTP"
        priority = 200
        direction = "Inbound"
        access = "Allow"
        protocol = "*"
        source_port_range = "*"
        destination_port_range = "80"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "nic1" {
    name = var.nic1
    location = var.loc
    resource_group_name = var.rg

    ip_configuration {
        name = "ipconfig1"
        subnet_id = azurerm_subnet.backsubnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_network_interface" "nic2" {
    name = var.nic2
    location = var.loc
    resource_group_name = var.rg


    ip_configuration {
        name = "ipconfig1"
        subnet_id = azurerm_subnet.backsubnet.id
        private_ip_address_allocation = "Dynamic"
    }
}