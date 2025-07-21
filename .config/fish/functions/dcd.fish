# "Docker Compose Down"

function dcd
    echo "COMMAND = docker compose down  $argv"
    docker compose down  $argv

end
