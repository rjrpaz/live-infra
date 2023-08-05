# dev/terragrunt.hcl

locals {
  common_vars  = yamldecode(file("common_vars.yaml"))
  project_name = basename(get_terragrunt_dir())
  environment  = basename(dirname(get_terragrunt_dir()))
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = local.common_vars.state_name

    key            = "${local.environment}/${path_relative_to_include()}/terraform.tfstate"
    region         = local.common_vars.region
    encrypt        = true
    dynamodb_table = local.common_vars.state_name
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.common_vars.region}"
  # ATTENTION!: is best practice to use different AWS account for every environment
  # If that's the case, uncomment next block and set proper aws role:
  # assume_role {
  #   role_arn = "arn:aws:iam::0123456789:role/terragrunt"
  # }
}
EOF
}

inputs = {
  vpc_name = format("%s-%s", local.environment, local.project_name)
  tags = {
    terraform   = local.common_vars.terraform
    environment = local.environment
  }
}