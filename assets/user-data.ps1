#ps1
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client '@{TrustedHosts="*"}'
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any

# Update Local Administrator Password  and set to never expire
$NewPassword = ConvertTo-SecureString "${admin_password}" -AsPlainText -Force
Set-LocalUser -Name Administrator -Password $NewPassword
Set-LocalUser -Name Administrator -PasswordNeverExpires 1

# Create new directory for our post-provisioning PS scripts
New-Item -Path "C:\" -Name "metal-terraform-ps-scripts" -ItemType "directory"