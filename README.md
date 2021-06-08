# Automating Windows with Equinix Metal & Terraform

This repository contains a basic blueprint for deploying Windows 2019 on Equinix Metal using Terraform with added capability for running post-provisioning PowerShell Scripts.

See [examples/simple/main.tf](examples/simple/main.tf) for a single file example of how to use this project as a module.

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

The PowerShell scripts are supplied by the module's user, you can see example scripts in [examples/simple/assets/](examples/simple/assets/). They are deployed using `null_resource` blocks and stored on the remote servers in **C:\\metal-terraform-ps-scripts\\**. They  execute synchronously using `winrm`. Here are the sample scripts:

* [examples/simple/assets/script1.ps1](examples/simple/assets/script1.ps1)
* [examples/simple/assets/script2.ps1](examples/simple/assets/script2.ps1)

These scripts are currently not dynamic, meaning they don't leverage any data returned from the Metal API about provisioned servers to be used in the scripts.
