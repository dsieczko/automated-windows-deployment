terraform {
  required_providers {
    metal = {
      source = "equinix/metal"
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
  user_data        = file("${path.module}/assets/user-data.ps1")
}

resource "null_resource" "run-script1-setup" {
  depends_on = [
    metal_device.windows_server
  ]

  connection {
     host        = metal_device.windows_server.access_public_ipv4
     type        = "winrm"
     user        = "Admin"
     password    = var.admin_password
    }

  provisioner "file" {
    source      = templatefile("${path.module}/assets/script1.ps1", {admin_password: var.admin_password})
    destination = "C:\\Users\\Administrator\\Desktop\\script1.ps1"
  }

  provisioner "remote-exec" {
    inline = [
      "powershell.exe -version 4 -File C:\\Users\\Administrator\\Desktop\\script1.ps1"
    ]
  }
}

resource "null_resource" "run-script2-setup" {
  depends_on = [
    metal_device.windows_server,
    null_resource.run-script1-setup
  ]

  connection {
     host        = metal_device.windows_server.access_public_ipv4
     type        = "winrm"
     user        = "Admin"
     password    = var.admin_password
    }

  provisioner "file" {
    source      = file("${path.module}/assets/script2.ps1")
    destination = "C:\\Users\\Administrator\\Desktop\\script2.ps1"
  }

  provisioner "remote-exec" {
    inline = [
      "powershell.exe -version 4 -File C:\\Users\\Administrator\\Desktop\\script2.ps1"
    ]
  }
}


