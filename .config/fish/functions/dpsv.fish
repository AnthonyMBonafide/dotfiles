# "Docker Prune System Volume"

function dpsv
    echo "COMMAND = yes | docker system prune -a"
    yes | docker system prune -a
    echo "COMMAND = yes | docker volume prune"
    yes | docker volume prune

end
