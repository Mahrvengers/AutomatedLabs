# Keine Nachfragen mehr

Während der automatisierten Abläufe bei der Installation gibt es leider ein paar unnütze 
Nachfragen. 

Wie schaltet man diese ab?

Die Nachfragen werden durch das Commandlet Enable-LabHostRemoting ausgelöst. 
Leider haben sie nichts mit dem klassischen $Confirm zu tun, dann hätte man 
das Verhalten einfach global steuern können. 

Das Commandlet verfügt aber über einen -Force Parameter, der die Nachfrage 
unterdrückt und einfach Yes annimmt. Nur das der nicht gesetzt ist, und bei 
dem aufrufenden Commandlet gibts auch kein Flag, das man dahin durchreichen könnte. 

Also patchen wir das Modul:

```powershell
# Wir gucken wo es ist :
Get-Module "AutomatedLab" | Select-Object Name, Path

# Merken uns das:
$pfad = Get-Module "AutomatedLab" | Select-Object -ExpandProperty Path

# Gehen hin:
ise $pfad

# Die Ise öffnet gleich die Datei. In Zeile 411 können wir dann -Force anhängen

        if (-not (Test-LabHostRemoting))
        {
            Enable-LabHostRemoting -Force
        }

```

Und schon läuft das vollständige Setup ohne die Nachfrage.

*Achtung:* Um die Datei speichern zu können muss der Editor mit 
Admin-Rechten laufen. Weil das Modul ja im Windows Ordner abgelegt ist.

Tadaaa. Keine Nachfragen mehr.
