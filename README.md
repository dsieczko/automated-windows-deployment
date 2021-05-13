# Automating Windows with Equinix Metal & Terraform

This repository contains a basic blueprint for deploying Windows 2019 on Equinix Metal using Terraform with added capability for running post-provisioning PowerShell Scripts.

See [examples/simple/main.tf](examples/simple/main.tf) for an single file example of how to use this project as a module.

To try the example:

```sh
cd examples/simple/main.tf
vim main.tf # edit the locals
terraform init -upgrade
terraform apply
```

When using this as standalone configuration, for example by git cloning the project, you will need to include a `provider "metal" { auth_token="..." }` stanza. 


## Provisioning with PowerShell

Each server is deployed with some basic user-data located in [assets/user-data.ps1](assets/user-data.ps1) that enables remote access to the server, updates the `Admin` user's password, and creates a directory called **C:\\metal-terraform-ps-scripts.**

The PowerShell scripts in [assets/](assets/) are stored in **C:\\metal-terraform-ps-scripts\\**. They will execute synchronously using `winrm`.

* [assets/script1.ps1](assets/script1.ps1)
* [assets/script2.ps1](assets/script2.ps1)

These are currently not dynamic. If you need to pass data from other Terraform resources, e.g. `metal_device`, you can pass variables in [main.tf](main.tf) using the [templatefile(path, vars)](https://www.terraform.io/docs/language/functions/templatefile.html) function in the `null_resource` blocks.
