# Providers config
provider "aws" {
  shared_credentials_file = var.credentials_file
  profile                 = var.profile
  region                  = var.region
  version                 = ">= 3.0"
}

provider "random" {
  version = ">= 3.0.0"
} Version constraints inside provider configuration blocks are deprecated

provider "local" {
  version = ">= 1.4.0"
}

provider "template" {
  version = ">= 2.1.2"
}

provider "null" {
  version = ">= 2.1.2"
}

terraform {
  required_version = ">= 1.2.0"
}

