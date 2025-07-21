# "Docker Compose Down (rmi) All"

function dcda
    echo "COMMAND = docker compose down -v --rmi all"
    docker compose down -v --rmi all

end
