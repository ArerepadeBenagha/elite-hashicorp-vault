terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 0.14"

  backend "remote" {
    organization = "EliteSolutionsIT"

    workspaces {
      name = "elite-hashicorp-vault"
    }
  }
}

terraform {
  required_version = ">=0.12"
}

provider "aws" {
  region = "us-east-1"
}

# Terraform 0.13+ uses the Terraform Registry:

terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}


# Configure the Datadog provider
provider "datadog" {
  alias   = "datadog_dev"
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}