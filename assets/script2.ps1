#ps1

# Remove Current License Key
slmgr /upk -confirm:\$False

# Convert from Windows Server 2019 from Standard to Data Center
Dism /online /Set-Edition:ServerDatacenter /AcceptEula /ProductKey:WMDGN-G9PQG-XVVXX-R3X43-63DFG

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