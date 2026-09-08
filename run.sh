
# Sovereign AI — local stack, stage 1: Ollama (native) + OpenWebUI (Docker)
ollama serve &
docker run -d --network=host \
  -v open-webui:/app/backend/data \
  -e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
  --name open-webui \
  ghcr.io/open-webui/open-webui:v0.11.0
