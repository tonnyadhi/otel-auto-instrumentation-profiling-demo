.PHONY: all build up down clean agent-image app-image

AGENT_REPO=https://github.com/open-telemetry/opentelemetry-go-instrumentation.git
AGENT_DIR=opentelemetry-go-instrumentation
AGENT_IMAGE=otel-go-agent:latest

all: build up

agent-clone:
	@if [ ! -d "$(AGENT_DIR)" ]; then \
		echo "Cloning OpenTelemetry agent repo..."; \
		git clone $(AGENT_REPO) $(AGENT_DIR); \
	else \
		echo "Updating OpenTelemetry agent repo..."; \
		cd $(AGENT_DIR) && git pull; \
	fi

agent-image: agent-clone
	docker build -t $(AGENT_IMAGE) $(AGENT_DIR)

app-image:
	docker build -t my-go-app:latest -f Dockerfile.app .

build: agent-image app-image

up:
	docker compose up --build

down:
	docker compose down

clean:
	docker compose down -v
	docker image rm -f $(AGENT_IMAGE) my-go-app:latest || true