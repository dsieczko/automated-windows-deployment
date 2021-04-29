# Automating Windows with Equinix Metal & Terraform

This repository contains a basic blueprint for deploying Windows 2019 on Equinix Metal using Terraform with added capability for runing post-provisioning PowerShell Scripts.

Each server is deployed with some basic user-data located in the **user-data** that enables remote access to the server.

We generate PowerShell scripts locally for each server using **build-ps-scripts** and then remotely execute the scripts on each provisioned server. There are some example PS commands in the scripts but you can replace it with whatever you want to run on the Windows servers.

There is a `tfvars.template` file that you can copy and use to update with your deployment variables.