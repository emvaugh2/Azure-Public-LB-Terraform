terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm" # This tells us the Azure RM provider which is Hashicorp
            version = "~>4.0" # The "~>" says use at least version 4.0 up to but not including 5.0
        }
        azuread = {
            source = "hashicorp/azuread" # This allows us to use Azure AD which we'll need for our service principal
        }
    }
}

# This is a required block for the Azure RM provider. Include this with every file. 
provider "azurerm" {
    features {}
    subscription_id = "e3110257-2243-4023-af5e-714fe2c7daae"
}