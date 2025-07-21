# docker == podman

function docker
    echo "ALIASING (docker = podman) + $argv"
    podman $argv

end
