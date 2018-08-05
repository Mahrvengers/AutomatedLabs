<#

    Ein Entwicklungs-System für Tests aufsetzen, dass eine ganze Reihe von Tools 
    beinhaltet.

    05.08.2018 Wir beginnen mit Chocolatey, damit wir Zugriff auf eine Menge Software haben :)

#>

$labName = "DevelopmentLab"

New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV

Add-LabVirtualNetworkDefinition -Name ($labName) -HyperVProperties @{SwitchType = 'External'; AdapterName = 'WLAN'}

$chocolatey = Get-LabPostInstallationActivity -CustomRole ALChocolatey -Properties @{ }
Add-LabMachineDefinition -Name Dev01 -OperatingSystem 'Windows 10 Pro' -Network $labName -Memory 4GB -Processors 4 -PostInstallationActivity $chocolatey

Install-Lab

#Install-LabSoftwarePackage -Path $labSources\SoftwarePackages\npp.7.5.8.Installer.x64.exe -CommandLine '/qn /IAgreeToTheEula' -ComputerName Dev01

Invoke-LabCommand -ScriptBlock { Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} -ComputerName (Get-LabVM)

Show-LabDeploymentSummary -Detailed


