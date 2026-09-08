
# Sovereign AI — local stack, stage 1: Ollama (native) + OpenWebUI (Docker)
#!/bin/bash

STACK_DIR=$(~/MANU/projects/sovereign-ai
cd $STACK_DIR

echo "Starting stack via Docker Compose..."
docker compose up -d

echo "Waiting for Ollama..."
for i in 1 2 3 4 5;do
	if curl -fs http://localhost:11434/api/tags > /dev/null; then
		echo "Ollama is up"
		break
	fi
	sleep 2
done
if $?>0; then
	echo "Ollama isn't up"
fi 

echo "Waiting for OpenWebUI server..."
for i in 1 2 3 4 5;do
	if curl -sf http://localhost:8080 > /dev/null; then
		echo"OpenWebUI is up"
		break
	fi
	sleep 2
done
if $?>0; then
        echo "OpenWebUI isn't up, check 'docker lohs open-webui"
fi
exit 1
