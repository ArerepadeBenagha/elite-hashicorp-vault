variable "tags" {
  description = "Tag for infrastructure charge."
  type        = map(any)
  default     = {}
}

variable "name" {
  description = "(Required) name of the resource group"
}

variable "location" {
  description = "(Required) location where this resource has to be created"
}