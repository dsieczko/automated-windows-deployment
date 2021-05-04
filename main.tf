terraform {
  required_providers {
    metal = {
      source  = "equinix/metal"
      version = "~> 2.0"
    }
  }
}

resource "metal_device" "windows_server" {
  hostname         = var.hostname
  plan             = var.plan
  metro            = var.metro
  operating_system = var.operating_system
  billing_cycle    = "hourly"
  project_id       = var.project_id
  user_data        = templatefile("${path.module}/assets/user-data.ps1", { admin_password : var.admin_password })
}

resource "null_resource" "run-script1-setup" {
  depends_on = [
    metal_device.windows_server
  ]

  connection {
    host     = metal_device.windows_server.access_public_ipv4
    type     = "winrm"
    user     = "Administrator"
    password = var.admin_password
  }

  provisioner "file" {
    source      = "${path.module}/assets/script1.ps1"
    destination = "C:\\metal-terraform-ps-scripts\\script1.ps1"
  }

  provisioner "remote-exec" {
    inline = [
      "powershell.exe -version 4 -File C:\\metal-terraform-ps-scripts\\script1.ps1"
    ]
  }
}

resource "null_resource" "run-script2-setup" {
  depends_on = [
    metal_device.windows_server,
    null_resource.run-script1-setup
  ]

  connection {
    host     = metal_device.windows_server.access_public_ipv4
    type     = "winrm"
    user     = "Administrator"
    password = var.admin_password
  }

  provisioner "file" {
    source      = "${path.module}/assets/script2.ps1"
    destination = "C:\\metal-terraform-ps-scripts\\script2.ps1"
  }

  provisioner "remote-exec" {
    inline = [
      "powershell.exe -version 4 -File C:\\metal-terraform-ps-scripts\\script2.ps1"
    ]
    # sript2 features reboot.
    on_failure = continue
  }
}


