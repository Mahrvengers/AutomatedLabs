<#

    Dieses Skript startet die Bash auf dem Docker Container mit Wordpress

    Führe dort z.B. 
    
    apt-get update; apt-get install vim 
    
    aus, um einen Texteditor zu bekommen und dann kannste auch schon loscoden :).

#>

docker ps

$containerName = Read-Host -Prompt "Container-Id vom Wordpress Container"
docker exec -it $containerName /bin/bash