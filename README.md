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

When using this as standalone configuration, for example by git cloning the project, you will need to include a `provider "metal" { auth_token="..." }` stanza. A `terraform.tfvars.example` file is provided that you can copy to `terraform.tfvars` and update with your deployment variables.





## Provisioning with Powershell

Each server is deployed with some basic user-data located in the **user-data** that enables remote access to the server.

We generate PowerShell scripts locally for each server using **build-ps-scripts** and then remotely execute the scripts on each provisioned server. There are some example PS commands in the scripts but you can replace it with whatever you want to run on the Windows servers.
