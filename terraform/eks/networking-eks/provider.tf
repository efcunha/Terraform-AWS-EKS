# Providers config
provider "aws" {
  shared_credentials_file = var.credentials_file
  profile                 = var.profile
  region                  = var.region
  version                 = ">= 3.38"
}

provider "random" {
  version = ">= 2.2.1"
}

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
  required_version = ">= 0.14.0"
}

