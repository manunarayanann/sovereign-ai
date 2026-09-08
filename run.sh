
# Sovereign AI — local stack, stage 1: Ollama (native) + OpenWebUI (Docker)
#!/bin/bash

STACK_DIR=$(~/MANU/projects/sovereign-ai)
cd $STACK_DIR

echo "Starting stack via Docker Compose..."
docker compose up -d

echo "Waiting for Ollama..."
is_ollama_up=false
for i in 1 2 3 4 5;do
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
for i in 1 2 3 4 5;do
	if curl -sf http://localhost:8080 > /dev/null; then
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