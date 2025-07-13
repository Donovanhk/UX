# List of essential/core services for Windows 10 + VMware
$essentialServices = @(
    # Core OS
    "RpcSs",        # Remote Procedure Call (RPC)
    "PlugPlay",     # Plug and Play (hardware detection)
    "LSM",          # Local Session Manager
    "SamSs",        # Security Accounts Manager
    "Wmi",          # Windows Management Instrumentation

    # Networking (adjust if you need networks in VMs)
    "Dhcp",         # DHCP Client (if using dynamic IP)
    "Dnscache",     # DNS Client

    # VMware Services (required for VMware Workstation)
    "VMAuthdService",       # VMware Authorization Service
    "VMUSBArbService",      # VMware USB Arbitration Service
    "VMnetDHCP",            # VMware DHCP Service
    "VMwareHostd",          # VMware Workstation Server
    "VMware NAT Service"    # VMware NAT Service
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
