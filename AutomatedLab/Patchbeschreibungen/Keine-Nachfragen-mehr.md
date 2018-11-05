# Keine Nachfragen mehr

W�hrend der automatisierten Abl�ufe bei der Installation gibt es leider ein paar unn�tze 
Nachfragen. 

Wie schaltet man diese ab?

Die Nachfragen werden durch das Commandlet Enable-LabHostRemoting ausgel�st. 
Leider haben sie nichts mit dem klassischen $Confirm zu tun, dann h�tte man 
das Verhalten einfach global steuern k�nnen. 

Das Commandlet verf�gt aber �ber einen -Force Parameter, der die Nachfrage 
unterdr�ckt und einfach Yes annimmt. Nur das der nicht gesetzt ist, und bei 
dem aufrufenden Commandlet gibts auch kein Flag, das man dahin durchreichen k�nnte. 

Also patchen wir das Modul:

```powershell
# Wir gucken wo es ist :
Get-Module "AutomatedLab" | Select-Object Name, Path

# Merken uns das:
$pfad = Get-Module "AutomatedLab" | Select-Object -ExpandProperty Path

# Gehen hin:
ise $pfad

# Die Ise �ffnet gleich die Datei. In Zeile 416 k�nnen wir dann -Force anh�ngen

        if (-not (Test-LabHostRemoting))
        {
            Enable-LabHostRemoting -Force
        }

```

Und schon l�uft das vollst�ndige Setup ohne die Nachfrage.

*Achtung:* Um die Datei speichern zu k�nnen muss der Editor mit 
Admin-Rechten laufen. Weil das Modul ja im Windows Ordner abgelegt ist.

Tadaaa. Keine Nachfragen mehr.
