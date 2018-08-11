﻿<#

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

Invoke-LabCommand -ScriptBlock { 
    Set-ExecutionPolicy Bypass -Scope Process -Force; 
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} -ComputerName (Get-LabVM)

Write-Host "Installiere Software..." -ForegroundColor Yellow

$PWord = ConvertTo-SecureString -String "Somepass1" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "Administrator", $PWord

# Diverse Tools
Invoke-Command -ScriptBlock { 
    # Versionskontrollsysteme und Tools
    C:\ProgramData\chocolatey\choco.exe install -y git.install tortoisehg tortoisegit 
    # Webbrowser
    C:\ProgramData\chocolatey\choco.exe install -y firefox googlechrome
    # Web-Debugger 
    C:\ProgramData\chocolatey\choco.exe install -y fiddler4 
    # SQL Server 2014 und Management Studio, als Datenbank
    C:\ProgramData\chocolatey\choco.exe install -y mssqlserver2014express mssqlservermanagementstudio2014express 
    # docker für docker-Container-Nutzung in der Entwicklungsumgebung
    C:\ProgramData\chocolatey\choco.exe install -y docker-for-windows
    # Code-Editoren
    C:\ProgramData\chocolatey\choco.exe install -y visualstudiocode notepadplusplus.install 
    # Weitere kleine Tools
    C:\ProgramData\chocolatey\choco.exe install -y 7zip.install carbon 
    # PHP in einer aktuellen Version, PHP wird für ggf. Test-Webserver eingesetzt.
    # Die Version ist dabei nicht so wichtig. 
    C:\ProgramData\chocolatey\choco.exe install -y php
    # IDE für PHP 
    C:\ProgramData\chocolatey\choco.exe install -y phpstorm 
    # Node (js) in der Version 6.9.2 
    C:\ProgramData\chocolatey\choco.exe install -y nodejs.install --version 6.9.2
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

