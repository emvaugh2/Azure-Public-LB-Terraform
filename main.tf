resource "azurerm_resource_group" "lb_rg" {
    name = var.rg # name of the resource azurerm_resource_group
    location = var.loc # Azure region where it will be deployed
}

