terraform {
  required_version = ">=1.7.5"

  required_providers {
    aws={
        source = "registry.terraform.io/hashicorp/aws"
    }
  }
}