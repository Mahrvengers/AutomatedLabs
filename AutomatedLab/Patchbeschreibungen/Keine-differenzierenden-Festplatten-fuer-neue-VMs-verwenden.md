# Ich will keine differenzierende Festplatte für die neuen VHDs, sondern eine jeweils vollständige!

Du suchst folgende Datei:

```
C:\Program Files\WindowsPowerShell\Modules\AutomatedLabWorker\5.0.4.62\AutomatedLabWorkerVirtualMachines.psm1
```

Dort gibt es die Funktion `New-LWHypervVM`.

Nach einem riesigen Block, in dem es um die Erstellung von Linux-VMs geht, kommt, folgender Powershell-Block an der Stelle Zeile 401 ff.

```powershell
    else
    {
        $referenceDiskPath = $Machine.OperatingSystem.BaseDiskPath
        $systemDisk = New-VHD -Path $path -Differencing -ParentPath $referenceDiskPath -ErrorAction Stop
        Write-Verbose "`tcreated differencing disk '$($systemDisk.Path)' pointing to '$ReferenceVhdxPath'"
    }
```

Hierbei muss der Aufruf von New-VHD angepasst werden.

```powershell
    {
        $referenceDiskPath = $Machine.OperatingSystem.BaseDiskPath
        #$systemDisk = New-VHD -Path $path -Differencing -ParentPath $referenceDiskPath -ErrorAction Stop
        #Write-Verbose "`tcreated differencing disk '$($systemDisk.Path)' pointing to '$ReferenceVhdxPath'"
        Write-Host "Kopiere $referenceDiskPath nach $path..."
        # Pfad vorbereiten
        $pfad = [System.IO.Path]::GetDirectoryName( $path )
        # Sicherstellen, dass es den Pfad auch gibt
        New-Item $pfad -ItemType Directory
        # Kopieren des Base Images
        Copy-Item $referenceDiskPath -Destination $path -Recurse -Force
        $systemDisk = @{
            'Path' = $path
        }
    }
```
