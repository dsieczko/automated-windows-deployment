# Set Time Zone
cscript //h:cscript //s //nologo
tzutil /s "Pacific Standard Time"

# Disable Services and Delete Equinix Scheduled Tasks
sc.exe config "cloudbase-init" start=disabled
sc.exe config "Spooler" start=disabled
Get-ScheduledTask -TaskName "Packet-Config-Network"
Unregister-ScheduledTask -TaskName "Packet-Config-Network" -Confirm:$false

# Remove Equinix Apps
$MyApp = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Cloudbase-Init 1.1.3.dev10"}
if ($MyApp) { $MyApp.uninstall() } else { "No Cloudbase-Init 1.1.3.dev10 to uninstall" }
$MyApp = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Pensando Ionic Driver"}
if ($MyApp) { $MyApp.uninstall() } else { "No Pensando Ionic Driver" }