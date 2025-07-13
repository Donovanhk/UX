# List of essential/core services for Windows 10 + VMware
$essentialServices = @(
    # Core Windows
    "WinDefend","wuauserv","MpsSvc","BITS","EventLog","PlugPlay","RpcSs",
    "lanmanworkstation","lanmanserver","Spooler","Audiosrv","Dhcp","Dnscache","Themes",
    "ShellHWDetection","Power","Wmi","SamSs","LSM","TokenBroker","SecurityHealthService",
    # VMware
    "VMAuthdService", "VMUSBArbService", "VMnetDHCP", "VMwareHostd", "VMware NAT Service"
)

# Get all running, non-essential services
$unnecessaryServices = Get-Service | Where-Object {
    $_.Status -eq 'Running' -and
    $essentialServices -notcontains $_.Name
}

Write-Host "The following non-essential services will be stopped:" -ForegroundColor Yellow
$unnecessaryServices | ForEach-Object { Write-Host $_.Name }

# Stop them (temporary, until reboot)
$unnecessaryServices | Stop-Service -Force

# If you want to disable them from starting at boot, uncomment this line:
# $unnecessaryServices | Set-Service -StartupType Disabled

Write-Host "`nServices stopped. Reboot to restore. If you wish to make this permanent, uncomment the Set-Service line." -ForegroundColor Green
