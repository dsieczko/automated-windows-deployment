#ps1

# allow remote access
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client '@{TrustedHosts="*"}'
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any