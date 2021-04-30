terraform {
  required_providers {
    metal = {
      source  = "equinix/metal"
      version = ">= 2.0.0"
    }
  }
}

provider "metal" {
  auth_token = local.api_key
}


module "windows_servers" {
  source                    = "./terraform-modules/metal-windows-server"
  api_key                   = local.api_key
  project_id                = local.project_id
  count                     = local.server_count
  metro                     = local.metro
  admin_password            = local.admin_password
  hostname                  = "${local.hostname}${count.index}"
  operating_system          = "windows_2019"
  plan                      = local.plan
  billing_cycle             = "hourly"
}
