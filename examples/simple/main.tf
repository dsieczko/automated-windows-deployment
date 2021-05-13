# This example demonstrates how the Windows starter module can be used
# in a Terraform configuration.

# Save these settings in a terraform.tfvars file to avoid being prompted
variable "auth_token" {}
variable "project_id" {}

# These locals could be variables, but here we set reasonable for demo purposes.
locals {
  metro          = "da"
  plan           = "c3.small.x86"
  server_count   = 1
  hostname       = "windows"
  admin_password = random_password.windows_password.result
  script1_path   = "./assets/script1.ps1"
  script2_path   = "./assets/script2.ps1"
}

terraform {
  required_providers {
    metal = {
      source = "equinix/metal"
    }
  }
}

# Use a password generator
resource "random_password" "windows_password" {
  length = 16
}

# In this configuration the metal provider and token are defined.
# This provider is supplied as an argument to the module.
provider "metal" {
  auth_token = var.auth_token
}

module "windows_server" {
  count = local.server_count

  providers = {
    metal = metal
  }

  # To fetch this module from the Terraform registry, use:
  # source = "dsieczko/windows-starter/metal"
  # version = "1.0.0"

  # This relative "source" will use the git cloned project.
  source           = "../.."
  project_id       = var.project_id
  metro            = local.metro
  admin_password   = local.admin_password
  hostname         = "${local.hostname}${count.index}"
  operating_system = "windows_2019"
  plan             = local.plan
  script1_path     = abspath(local.script1_path)
  script2_path     = abspath(local.script2_path)
}

# Use `terraform output -json` to see the sensitive password
output "admin_password" {
  value     = random_password.windows_password.result
  # sensitive = true
}

output "public_ipv4s" {
  value = module.windows_server[*].public_ipv4
}
