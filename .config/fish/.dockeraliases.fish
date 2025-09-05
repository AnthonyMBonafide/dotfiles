set -gx CONTAINERMGR podman

abbr docker podman
abbr dcu docker-compose up -d
abbr dcd docker-compose down -v
abbr dcowui podman create -p 127.0.0.1:3000:8080 --network pasta:-T,11434 --add-host localhost:127.0.0.1 --env "OLLAMA_BASE_URL http://localhost:11434" --env "ANONYMIZED_TELEMETRY False" -v open-webui:/app/backend/data --label io.containers.autoupdate registry --name open-webui ghcr.io/open-webui/open-webui:main
abbr dsowui podman start open-webui
abbr pms podman machine start
