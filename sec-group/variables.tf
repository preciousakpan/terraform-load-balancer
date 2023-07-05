variable "nsg_name" {
    type            = string
}

variable "rg-location" {
    type            = string
}

variable "rg-name" {
    type            = string
}

variable "snet-id" {
    type            = string
}

variable "sgr" {
  type = map(object({
    priority                 = number
    direction                = string
    access                   = string
    protocol                 = string
    source_port_range        = string
    destination_port_range   = string
    source_address_prefix    = string
    destination_address_prefix = string
  }))
}
