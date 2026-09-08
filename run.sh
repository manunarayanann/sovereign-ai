
# Sovereign AI — local stack, stage 1: Ollama (native) + OpenWebUI (Docker)
#!/bin/bash
set -e
STACK_DIR=$HOME/MANU/projects/sovereign-ai
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
echo "Waiting for OpenWebUI server..."
for i in $(seq 1 100);do
	status=$(docker inspect -f '{{.State.Health.Status}}' open-webui)
	if [ "$status" = "healthy" ]; then
		echo "OpenWebUI is up"
		is_openwebui_up=true
		break
	fi
	sleep 2
done
if [ "$is_openwebui_up" = false ]; then
	echo "OpenWebUI isn't up, check 'docker logs open-webui'"
	exit 1
fi
echo "Stack is up and running. Access OpenWebUI at http://localhost:8080"
exit 0