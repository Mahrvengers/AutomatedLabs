$labName = 'EX2016'

New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV

Add-LabVirtualNetworkDefinition -Name $labName -AddressSpace 192.168.10.0/24  -HyperVProperties @{ SwitchType = 'External'; AdapterName = 'Ethernet' } 

Set-LabInstallationCredential -Username Admin -Password APW-1.1  
 
Add-LabDomainDefinition -Name cls-edv.de -AdminUser Admin -AdminPassword APW-1.1 

$r = Get-LabPostInstallationActivity -CustomRole Exchange2016 -Properties @{ OrganizationName = 'CLS' }

Add-LabMachineDefinition -Name DC01 -Memory 2GB -Network $labName -IpAddress 192.168.10.11 -Gateway 192.168.10.254 `
   -DnsServer1 192.168.10.11 -DomainName cls-edv.de -Roles RootDC `
   -IsDomainJoined -ToolsPath $labSources\Tools -OperatingSystem 'Windows Server 2016 SERVERSTANDARD' 
   
Add-LabMachineDefinition -Name EX01 -Memory 10GB -Network $labName -IpAddress 192.168.10.12 -Gateway 192.168.10.254 `
   -DnsServer1 192.168.10.11 -DomainName cls-edv.de `
   -IsDomainJoined -ToolsPath $labSources\Tools -OperatingSystem 'Windows Server 2016 SERVERSTANDARD' -PostInstallationActivity $r


#Exchange 2016 required at least kb3206632. Hence before installing Exchange 2016, the update is applied

Install-Lab -NetworkSwitches -BaseImages -VMs -Domains -StartRemainingMachines

Install-LabSoftwarePackage -Path $labSources\OSUpdates\2016\windows10.0-kb3206632-x64_b2e20b7e1aa65288007de21e88cd21c3ffb05110.msu -ComputerName EX01 -Timeout 60

Restart-LabVM -ComputerName EX01 -Wait

Install-Lab -PostInstallations

Show-LabDeploymentSummary -Detailed