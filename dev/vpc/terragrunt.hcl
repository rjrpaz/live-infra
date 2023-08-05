# dev/vpc/terragrunt.hcl

include "root" {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}


terraform {
  source = "git::git@github.com:rjrpaz/terraform-modules.git//networking?ref=v0.0.1"
}


inputs = {
  # ATTENTION!: CIDR can be the same for every environment
  # (p.e. if we use different AWS accounts for every environment)
  # If that's the case, this variable can be defined as a common var
  # (see "common_vars.yaml" file) or in parent directory.
  vpc_cidr = "10.123.0.0/16"
}