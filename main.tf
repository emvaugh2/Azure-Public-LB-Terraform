
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

    depends_on = [azurerm_resource_group.lb_rg]

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

# Creates the Network Interfaces (NICs) for both VMs

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

# Associates the NICs to the Network Security Group (NIC)

resource "azurerm_network_interface_security_group_association" "nsg_assoc_1" {
    network_interface_id = azurerm_network_interface.nic1.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc_2" {
    network_interface_id = azurerm_network_interface.nic2.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

# Creates the Load Balancer and FrontEnd IP

resource "azurerm_lb" "lb" {
    name = var.lb
    location = var.loc
    resource_group_name = var.rg
    sku = "Standard"
    
    frontend_ip_configuration {
        name = var.frontend
        public_ip_address_id = azurerm_public_ip.lbpip.id
    }
}

# Creates the Load Balancer Backend Pool

resource "azurerm_lb_backend_address_pool" "myBackEndPool" {
    loadbalancer_id = azurerm_lb.lb.id
    name = var.backend

    depends_on = [azurerm_lb.lb]
}

# Creates the Load Balancer Health Probe
resource "azurerm_lb_probe" "lbhp" {
    loadbalancer_id = azurerm_lb.lb.id
    name = var.lbhp
    protocol = "Tcp"
    port = 80

    depends_on = [azurerm_lb.lb]
}

# Creates the Load Balancer HTTP rule 
resource "azurerm_lb_rule" "lbrule" {
    loadbalancer_id = azurerm_lb.lb.id
    name = "myHTTPRule"
    protocol = "Tcp"
    frontend_port = 80
    backend_port = 80
    frontend_ip_configuration_name = var.frontend 
    backend_address_pool_ids =  [azurerm_lb_backend_address_pool.myBackEndPool.id]
    probe_id = azurerm_lb_probe.lbhp.id
    disable_outbound_snat = true
    idle_timeout_in_minutes = 15
    enable_tcp_reset = true

    depends_on = [azurerm_lb.lb]
}

# Creates Azure Bastion host

#resource "azurerm_bastion_host" "bastion" {
#    resource_group_name = var.rg
#    location = var.loc
#    name = "myBastionHost"
#    
#    ip_configuration {
#        subnet_id = azurerm_subnet.bastionsubnet.id
#        public_ip_address_id = azurerm_public_ip.bpip.id
#        name = "AzureBastionSubnet"
#    }
#    
#    depends_on = [azurerm_subnet.bastionsubnet]
#}

# Creates the virtual machines (VM)
resource "azurerm_windows_virtual_machine" "vm1" {
    name = var.vm1
    location = var.loc
    resource_group_name = var.rg
    admin_username = azureuser
    admin_password = azureuser1
    network_interface_ids = [azurerm_network_interface.nic1.id]
    size = "Standard_DS1_v2"

    os_disk {
        name = "myOsDisk1"
        caching = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2019-datacenter-gensecond"
        version = "latest"
    }
    depends_on = [azurerm_network_interface.nic1]

}


# Creates the virtual machines (VM)
resource "azurerm_windows_virtual_machine" "vm2" {
    name = var.vm2
    location = var.loc
    resource_group_name = var.rg
    admin_username = azureuser
    admin_password = azureuser1
    network_interface_ids = [azurerm_network_interface.nic1.id]
    size = "Standard_DS1_v2"

    os_disk {
        name = "myOsDisk1"
        caching = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2019-datacenter-gensecond"
        version = "latest"
    }
    depends_on = [azurerm_network_interface.nic2]

}


