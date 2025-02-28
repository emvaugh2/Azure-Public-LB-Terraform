
# Resource Group variable 
variable "rg" {
    description = "The name of the Azure Resource Group"
    type = string
    default = "CreatePubLB"
}

# Location variable
variable "loc" {
    description = "The location where we're deploying all of our resources"
    type = string
    default = "East US"
}

# Virtual Network variable
variable "vnet" {
    description = "The name of the Virtual Network for our project."
    type = string
    default = "myVNet"
}

# Backend Pool Subnet variable
variable "backsubnet" {
    description = "The name of the subnet for out Backend pool."
    type =  string
    default = "myBackendSubnet"
}

# Azure Bastion Subnet variable
variable "bastionsubnet" {
    description = "The name of the subnet for out Bastion resource."
    type =  string
    default = "AzureBastionSubnet"
}

# Load Balancer Public IP name variable
variable "lbpip" {
    description = "The name of the load balancer's public IP address"
    type = string
    default = "myPublicIP"
}

# Azure Bastion host Public IP name variable
variable "bpip" {
    description = "The name of the Azure Bastion's public IP address"
    type = string
    default = "myBastionIP"
}

# NAT Gateway Public IP name variable
variable "natpip" {
    description = "The name of the NAT Gateway's public IP address"
    type = string
    default = "myNATgatewayIP"
}


# Load Balancer name variable
variable "lb" {
    description = "The name of the load balancer"
    type = string
    default = "myLoadBalancer"
}

# Load Balancer Health Probe name variable
variable "lbhp" {
    description = "The name of the load balancer's health probe"
    type = string
    default = "myHealthProbe"
}

# Network Security Group name variable
variable "nsg" {
    description = "The name of the network security group"
    type = string
    default = "myNSG"
}

# Azure Bastion host name variable
variable "bastion" {
    description = "The name of the Azure Bastion host resource"
    type = string
    default = "myBastionHost"
}

################################ Finish the stuff below

# Network Interface 1 name variable
variable "nic1" {
    description = "The name of virtual machine 1's NIC"
    type = string
    default = "myNicVM1"
}

# Network Interface 2 name variable
variable "nic2" {
    description = "The name of virtual machine 2's NIC"
    type = string
    default = "myNicVM2"
}

# Virtual Machine 1 name variable
variable "vm1" {
    description = "The name of virtual machine 1"
    type = string
    default = "myVM1"
}

# Virtual Machine 2 name variable
variable "vm2" {
    description = "The name of virtual machine 2"
    type = string
    default = "myVM2"
}

# NAT Gateway name variable
variable "nat" {
    description = "The name of the NAT gateway resource"
    type = string
    default = "myNATgateway"
}