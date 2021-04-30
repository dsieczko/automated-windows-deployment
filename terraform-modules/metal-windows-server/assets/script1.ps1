#ps1

# Set Time Zone
cscript //h:cscript //s //nologo
tzutil /s "Pacific Standard Time"


# Remove Local User Accounts and Delete Profiles
Remove-LocalUser -Name "Admin"
Remove-LocalUser -Name "cloudbase-init"

# Update Local Administrator Password  and set to never expire
$NewPassword = ConvertTo-SecureString ${admin_password} -AsPlainText -Force
Set-LocalUser -Name Administrator -Password $NewPassword
Set-LocalUser -Name Administrator -PasswordNeverExpires 1

# Disable Services and Delete Equinix Scheduled Tasks
sc.exe config "cloudbase-init" start=disabled
sc.exe config "Spooler" start=disabled
Get-ScheduledTask -TaskName "Packet-Config-Network"
Unregister-ScheduledTask -TaskName "Packet-Config-Network" -Confirm:$false

# Remove Equinix Apps
$MyApp = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Cloudbase-Init 1.1.3.dev10"}
$myapp.uninstall()
$MyApp = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Pensando Ionic Driver"}
$myapp.uninstall()