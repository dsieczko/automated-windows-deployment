# Remove Local User Accounts and Delete Profiles
Remove-LocalUser -Name "Admin"
Remove-LocalUser -Name "cloudbase-init"

#Delete Unwanted Profiles
Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq 'cloudbase-init' } | Remove-CimInstance
Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq 'Admin' } | Remove-CimInstance

# Disable Allow the computer to turn off this device to save power
$NICs = Get-WmiObject Win32_NetworkAdapter -filter "AdapterTypeID = '0' AND PhysicalAdapter = 'true' AND NOT Description LIKE '%wireless%' AND NOT Description LIKE '%virtual%' AND NOT Description LIKE '%WiFi%' AND NOT Description LIKE '%Bluetooth%'"
Foreach ($NIC in $NICs)
{
    $powerMgmt = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi | where {$_.InstanceName -match [regex]::Escape($nic.PNPDeviceID)}
    If ($powerMgmt.Enable -eq $True)
    {
         $powerMgmt.Enable = $False
         $powerMgmt.psbase.Put()
    }
}

# Remove Current License Key
slmgr /upk /NoRestart

# Convert from Windows Server 2019 from Standard to Data Center
Dism /online /Set-Edition:ServerDatacenter /AcceptEula /ProductKey:WMDGN-G9PQG-XVVXX-R3X43-63DFG -Confirm:$false