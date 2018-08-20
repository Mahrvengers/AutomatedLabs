<#

	Ein einfaches erstes Testsystem zu Demonstrationszwecken!

#>


$labName = "GettingStarted"

New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV

# Make the network definition
Add-LabVirtualNetworkDefinition -Name $labName -HyperVProperties @{
	SwitchType = 'External';
	AdapterName = 'WLAN'}

Add-LabMachineDefinition -Name DC01 -OperatingSystem 'Windows Server 2016 Standard Evaluation (Desktop Experience)' -Network $labName -Memory 4GB -Processors 2

Install-Lab

Show-LabDeploymentSummary