#!/bin/bash
set -e

AGENT_REPO="https://github.com/open-telemetry/opentelemetry-go-instrumentation.git"
AGENT_DIR="opentelemetry-go-instrumentation"
AGENT_IMAGE="otel-go-agent:latest"

# Clone or update OpenTelemetry agent repo
if [ ! -d "$AGENT_DIR" ]; then
  echo "Cloning OpenTelemetry agent repo..."
  git clone "$AGENT_REPO" "$AGENT_DIR"
else
  echo "Updating OpenTelemetry agent repo..."
  (cd "$AGENT_DIR" && git pull)
fi

# Build the agent image
docker build -t "$AGENT_IMAGE" "$AGENT_DIR"

# Build your app image
docker build -t my-go-app:latest -f Dockerfile.app .

# Run the stack
docker compose up --build