
# Sovereign AI — local stack, stage 1: Ollama (native) + OpenWebUI (Docker)
#!/bin/bash
set -e
STACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo $STACK_DIR
cd "$STACK_DIR"

echo "Starting stack via Docker Compose..."
docker compose up -d

echo "Waiting for Ollama..."
is_ollama_up=false
for i in $(seq 1 60);do
	if curl -fs http://localhost:11434/api/tags > /dev/null; then
		echo "Ollama is up"
		is_ollama_up=true
		break
	fi
	sleep 2
done
if [ "$is_ollama_up" = false ]; then
	echo "Ollama isn't up"
	exit 1
fi

is_openwebui_up=false
printf "Waiting for OpenWebUI server...\n"
printf "Docker needs some minutes to become healthy\n"
printf "Elapsed time: 0s"
start_time=$(date +%s)
for i in $(seq 1 100);do
	status=$(docker inspect -f '{{.State.Health.Status}}' open-webui)
	if [ "$status" = "healthy" ]; then
		echo -e "\nOpenWebUI is up"
		is_openwebui_up=true
		break
	fi
	sleep 2
	elapsed_time=$(( $(date +%s) - start_time ))
	printf "\r\033[KElapsed time: ${elapsed_time}s"
done
if [ "$is_openwebui_up" = false ]; then
	echo "OpenWebUI isn't up, check 'docker logs open-webui'"
	exit 1
fi
echo "Stack is up and running. Access OpenWebUI at http://localhost:8080"
exit 0
