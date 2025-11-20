.PHONY: help build up down restart logs clean ps test

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

# GPU detection
HAS_GPU := $(shell docker run --rm --gpus all nvidia/cuda:11.8.0-base-ubuntu22.04 nvidia-smi 2>/dev/null && echo "yes" || echo "no")

# Docker compose command with or without GPU
ifeq ($(HAS_GPU),yes)
	DOCKER_COMPOSE := docker-compose -f docker-compose.yml -f docker-compose.gpu.yml
	GPU_MSG := GPU detected - GPU support enabled
	GPU_COLOR := $(GREEN)
else
	DOCKER_COMPOSE := docker-compose -f docker-compose.yml
	GPU_MSG := No GPU detected - Running in CPU mode
	GPU_COLOR := $(YELLOW)
endif

help: ## Show this help message
	@echo "$(GREEN)CDSS Docker Commands:$(NC)"
	@echo ""
	@echo "$(GPU_COLOR)GPU Status: $(GPU_MSG)$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

build: ## Build Docker images
	@echo "$(GREEN)Building Docker images...$(NC)"
	@echo "$(GPU_COLOR)GPU Status: $(GPU_MSG)$(NC)"
	@$(DOCKER_COMPOSE) build

up: ## Start all services
	@echo "$(GREEN)Starting CDSS services...$(NC)"
	@echo "$(GPU_COLOR)GPU Status: $(GPU_MSG)$(NC)"
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)Services started!$(NC)"
	@echo "Frontend: http://localhost:3000"
	@echo "Backend API: http://localhost:8000"
	@echo "API Docs: http://localhost:8000/docs"

up-gpu: ## Force start with GPU support (override detection)
	@echo "$(GREEN)Starting CDSS services with GPU (forced)...$(NC)"
	@docker-compose -f docker-compose.yml -f docker-compose.gpu.yml up -d
	@echo "$(GREEN)Services started with GPU!$(NC)"
	@echo "Frontend: http://localhost:3000"
	@echo "Backend API: http://localhost:8000"
	@echo "API Docs: http://localhost:8000/docs"

up-cpu: ## Force start without GPU support
	@echo "$(GREEN)Starting CDSS services in CPU mode (forced)...$(NC)"
	@docker-compose -f docker-compose.yml up -d
	@echo "$(GREEN)Services started in CPU mode!$(NC)"
	@echo "Frontend: http://localhost:3000"
	@echo "Backend API: http://localhost:8000"
	@echo "API Docs: http://localhost:8000/docs"

down: ## Stop all services
	@echo "$(RED)Stopping CDSS services...$(NC)"
	@docker-compose down

restart: ## Restart all services
	@echo "$(YELLOW)Restarting CDSS services...$(NC)"
	@$(DOCKER_COMPOSE) restart

logs: ## Show logs from all services
	@$(DOCKER_COMPOSE) logs -f

logs-backend: ## Show backend logs
	@$(DOCKER_COMPOSE) logs -f backend

logs-frontend: ## Show frontend logs
	@$(DOCKER_COMPOSE) logs -f frontend

ps: ## Show running containers
	@$(DOCKER_COMPOSE) ps

test: ## Test the API
	@echo "$(GREEN)Testing API...$(NC)"
	@sleep 2
	@curl -X POST http://localhost:8000/api/predict \
		-H "Content-Type: application/json" \
		-d '{"age":45,"blood_pressure":130,"cholesterol":200,"glucose":110,"bmi":28.5,"heart_rate":75}' \
		| python -m json.tool

health: ## Check service health
	@echo "$(GREEN)Checking service health...$(NC)"
	@echo "Backend:"
	@curl -s http://localhost:8000/health | python -m json.tool
	@echo ""
	@echo "Frontend:"
	@curl -s -o /dev/null -w "Status: %{http_code}\n" http://localhost:3000/

clean: ## Stop and remove all containers, networks, and volumes
	@echo "$(RED)Cleaning up Docker resources...$(NC)"
	@docker-compose down -v --remove-orphans
	@echo "$(GREEN)Cleanup complete!$(NC)"

rebuild: ## Rebuild and restart all services
	@echo "$(YELLOW)Rebuilding services...$(NC)"
	@$(DOCKER_COMPOSE) down
	@$(DOCKER_COMPOSE) build --no-cache
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)Rebuild complete!$(NC)"

shell-backend: ## Open shell in backend container
	@docker-compose exec backend /bin/bash

shell-frontend: ## Open shell in frontend container
	@docker-compose exec frontend /bin/sh

gpu-check: ## Check GPU availability
	@echo "$(GREEN)Checking GPU availability...$(NC)"
	@if docker run --rm --gpus all nvidia/cuda:11.8.0-base-ubuntu22.04 nvidia-smi 2>/dev/null; then \
		echo "$(GREEN)✓ GPU is available and working!$(NC)"; \
	else \
		echo "$(RED)✗ GPU not available or nvidia-docker not installed$(NC)"; \
		echo "$(YELLOW)The system will run in CPU mode.$(NC)"; \
	fi

install: ## Install and start everything
	@echo "$(GREEN)Installing CDSS...$(NC)"
	@echo "$(GPU_COLOR)GPU Status: $(GPU_MSG)$(NC)"
	@make build
	@make up
	@echo ""
	@echo "$(GREEN)Installation complete!$(NC)"
	@echo "$(YELLOW)Access the application at:$(NC)"
	@echo "  Frontend: http://localhost:3000"
	@echo "  Backend API: http://localhost:8000"
	@echo "  API Docs: http://localhost:8000/docs"
	@echo ""
	@echo "$(GPU_COLOR)GPU Status: $(GPU_MSG)$(NC)"
