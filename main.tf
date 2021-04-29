terraform {
  required_providers {
    metal = {
      source = "equinix/metal"
    }
  }
}

provider "metal" {
  auth_token = var.auth_token
}

resource "null_resource" "build-ps-scripts" {
  provisioner "local-exec" {
    command = format("${path.module}/build-ps-scripts %g", var.server_count)
  }
}

resource "metal_device" "windows_server" {
  count            = var.server_count
  hostname         = format("%s%02s", var.hostname, count.index +1)
  plan             = var.plan
  metro            = var.metro
  operating_system = "windows_2019"
  billing_cycle    = "hourly"
  project_id       = var.project_id
  user_data        = templatefile("${path.module}/user-data", {})
}

resource "null_resource" "run-script1-setup" {
  count=var.server_count
  connection {
     host        = format("10.10.124.1%02s", count.index +1)
     type        = "winrm"
     user        = "Admin"
     password    = element(metal_device.windows_server.*.root_password, count.index)
    }

  provisioner "file" {
    source      = format("${path.module}/ps-scripts/w%02s-script1.ps1", count.index +1)
    destination = format("C://Users/Admin/Desktop/w%02s-script1.ps1", count.index +1)
  }
  provisioner "remote-exec" {
    inline = [
      "powershell.exe Set-ExecutionPolicy RemoteSigned -force",
      format("powershell.exe -version 4 -ExecutionPolicy Bypass -File C:\\Users\\Admin\\Desktop\\w%02s-script1.ps1", count.index +1)
    ]
  }
}

resource "null_resource" "run-script2-setup" {
  count=var.server_count
  connection {
     host        = format("10.10.124.1%02s", count.index +1)
     type        = "winrm"
     user        = "Administrator"
     password    = var.administrator_password
    }

  provisioner "file" {
    source      = format("${path.module}/ps-scripts/w%02s-script2.ps1", count.index +1)
    destination = format("C://Users/Administrator/Desktop/w%02s-script2.ps1", count.index +1)
  }
#  provisioner "remote-exec" {
#    inline = [
#      "powershell.exe Set-ExecutionPolicy RemoteSigned -force",
#      format("powershell.exe -version 4 -ExecutionPolicy Bypass -File C:\\Users\\Administrator\\Desktop\\w%02s-script2.ps1", count.index +1)
#    ]
#  }
  depends_on = [
    null_resource.run-script1-setup
  ]
}

resource "null_resource" "clean-up" {
  provisioner "local-exec" {
    command = "rm ${path.module}/ps-scripts/*"
  }
  depends_on = [
    null_resource.run-script2-setup
  ]
}

