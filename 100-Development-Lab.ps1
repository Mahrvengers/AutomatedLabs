<#

    Ein Entwicklungs-System für Tests aufsetzen, dass eine ganze Reihe von Tools 
    beinhaltet.

    05.08.2018 Wir beginnen mit Chocolatey, damit wir Zugriff auf eine Menge Software haben :)

#>

$labName = "DevelopmentLab"

New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV -VmPath C:\AutomatedLab-VMs

Add-LabVirtualNetworkDefinition -Name ($labName) -HyperVProperties @{SwitchType = 'External'; AdapterName = 'WLAN'}

$chocolatey = Get-LabPostInstallationActivity -CustomRole ALChocolatey -Properties @{ }
Add-LabMachineDefinition -Name Dev01 -OperatingSystem 'Windows 10 Pro' -Network $labName -Memory 4GB -Processors 4 -PostInstallationActivity $chocolatey 

Install-Lab 

#Install-LabSoftwarePackage -Path $labSources\SoftwarePackages\npp.7.5.8.Installer.x64.exe -CommandLine '/qn /IAgreeToTheEula' -ComputerName Dev01

Invoke-LabCommand -ScriptBlock { 
    Set-ExecutionPolicy Bypass -Scope Process -Force; 
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} -ComputerName (Get-LabVM)

Write-Host "Installiere Software..." -ForegroundColor Yellow

$PWord = ConvertTo-SecureString -String "Somepass1" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "Administrator", $PWord

# Diverse Tools
Invoke-Command -ScriptBlock { 
    C:\ProgramData\chocolatey\choco.exe install -y git.install tortoisehg tortoisegit firefox googlechrome fiddler4 `
      mssqlserver2014express mssqlservermanagementstudio2014express docker-for-windows `
      visualstudiocode notepadplusplus.install phpstorm 7zip.install carbon `
      php nunit
} -ComputerName Dev01 -Credential $Credential

# Visual Studio 2017
Invoke-Command -ScriptBlock { 
    C:\ProgramData\chocolatey\choco.exe install -y visualstudio2017enterprise
    C:\ProgramData\chocolatey\choco.exe install -y visualstudio2017-workload-manageddesktop
    C:\ProgramData\chocolatey\choco.exe install -y visualstudio2017-workload-netweb
} -ComputerName Dev01 -Credential $Credential

# Office 2016
Invoke-Command -ScriptBlock { 
    C:\ProgramData\chocolatey\choco.exe install -y office365proplus
} -ComputerName Dev01 -Credential $Credential



Show-LabDeploymentSummary -Detailed

Write-Host "Fertig!" -ForegroundColor Green

Read-Host -Prompt "Drücken Sie eine Taste, um die VM wieder zu zerstören."

Remove-Lab

