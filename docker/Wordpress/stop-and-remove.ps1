<#
    Dieses Skript stoppt die Container und löscht die Wordpress 
    Datenbank mit. 
    Wenn du die Wordpress-Datenbank behalten möchtest, dann lasse
    --volumes weg.
#>

docker-compose down --volumes