locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service          = "Elite Technology Services"
    Company          = "EliteSolutions LLC"
    subscriptionname = "elitelabtools"
    ManagedWith      = "Terraform"
  }

  network = {}

  application = {
    alias       = "dev"
    buildregion = "eastus"
  }
}