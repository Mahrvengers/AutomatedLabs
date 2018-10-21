<#

    Startet einen Linux-Container mit xfce4 und vnc
    Der VNC kann auf Port 6901 per Webbrowser geöffnet werden (Passwort: vncpassword).

    In der Session stehen u.a. Chromium und Firefox zum Surfen bereit.

#>

Set-Location $PSScriptRoot

docker run -d -p 5901:5901 -p 6901:6901 consol/centos-xfce-vnc
