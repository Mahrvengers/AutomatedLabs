<#

    Installation von Exchange 2016, so dass es auf einen Laptop mit 16GB RAM passt.
    Zusätzlich wird "internal networking" verwendet, d.h. die VMs haben zunächst keinen Internet-
    Zugriff und sehen sich nur gegenseitig. 
    Dann wird unten beschrieben, wie man in dieses interne Netz ein NAT vom Host aus einhängt. 
    Damit ist die Spieldomäne dann vom Umgebungsnetz getrennt, kann also von außen nicht gesehen werden 
    und auch nicht aus versehen was andersherum kaputt machen.

    Skript von SQL Server Junge

#>

New-LabDefinition -Name 'LabEx2016' -DefaultVirtualizationEngine HyperV

#defining default parameter values, as these ones are the same for all the machines
$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:DomainName' = 'contoso.com'
    'Add-LabMachineDefinition:OperatingSystem' = 'Windows Server 2016 Datacenter Evaluation (Desktop Experience)'
}

$r = Get-LabPostInstallationActivity -CustomRole Exchange2016 -Properties @{ OrganizationName = 'Test1' }
Add-LabMachineDefinition -Name Lab2016DC1 -Roles RootDC -Memory 1GB
Add-LabMachineDefinition -Name Lab2016EX1 -Memory 11GB -PostInstallationActivity $r

#Exchange 2016 required at least kb3206632. Hence before installing Exchange 2016, the update is applied
#Alternativly, you can create an updated ISO as described in the introduction script '11 ISO Offline Patching.ps1' or download an updates image that
#has the fix already included.
Install-Lab -NetworkSwitches -BaseImages -VMs -Domains -StartRemainingMachines

Install-LabSoftwarePackage -Path $labSources\OSUpdates\2016\windows10.0-kb3206632-x64_b2e20b7e1aa65288007de21e88cd21c3ffb05110.msu -ComputerName Lab2016EX1 -Timeout 60

Restart-LabVM -ComputerName Lab2016EX1 -Wait

Install-Lab -PostInstallations

Show-LabDeploymentSummary -Detailed

<#
    NAT aufsetzen für Internet-Zugriff

    Setze den Standard-Gateway der VMs auf 192.168.11.254 für Internet-Zugriff.
#>
<#
$ifIndex = (Get-NetAdapter -Name "vEthernet (LabEx2016)").ifIndex
New-NetIPAddress -IPAddress 192.168.11.254 -PrefixLength 24 -InterfaceIndex $ifindex
New-NetNat -Name LabEx2016 -InternalIPInterfaceAddressPrefix 192.168.11.0/24
#>

