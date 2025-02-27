variable "rg" {
    description = "The name of the Azure Resource Group"
    type = string
    default = "CreatePubLBQS-rg"
}

variable "loc" {
    description = "The location where we're deploying all of our resources"
    type = string
    default = "East US"
}

