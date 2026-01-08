.PHONY: start stop restart logs status backup restore op cmd help

# Default backup directory
BACKUP_DIR := backups
WORLD_NAME := waihi_beach

help:
	@echo "Minecraft Server Management"
	@echo ""
	@echo "Server commands:"
	@echo "  make start      - Start the server"
	@echo "  make stop       - Stop the server"
	@echo "  make restart    - Restart the server"
	@echo "  make logs       - Follow server logs"
	@echo "  make status     - Show server status"
	@echo ""
	@echo "Backup commands:"
	@echo "  make backup                    - Backup waihi_beach world"
	@echo "  make backup WORLD_NAME=world   - Backup specific world"
	@echo "  make list-backups              - List available backups"
	@echo "  make restore FILE=<backup>     - Restore from backup"
	@echo ""
	@echo "Admin commands:"
	@echo "  make op NAME=<player>          - Make player an operator"
	@echo "  make cmd CMD='<command>'       - Run server command"
	@echo ""
	@echo "Examples:"
	@echo "  make backup"
	@echo "  make restore FILE=backups/waihi_beach_20260108_120000.tar.gz"
	@echo "  make op NAME=o_man_2000"
	@echo "  make cmd CMD='say Hello everyone!'"

# Server management
start:
	docker compose up -d
	@echo "Server starting... use 'make logs' to watch startup"

stop:
	@echo "Saving world before shutdown..."
	-docker exec minecraft-server rcon-cli "save-all"
	@sleep 3
	docker compose down
	@echo "Server stopped"

restart:
	@echo "Restarting server..."
	-docker exec minecraft-server rcon-cli "save-all"
	@sleep 2
	docker compose restart minecraft
	@echo "Server restarting... use 'make logs' to watch startup"

logs:
	docker compose logs -f minecraft

status:
	@docker compose ps
	@echo ""
	@docker exec minecraft-server rcon-cli "list" 2>/dev/null || echo "Server not running"

# Backup management
backup:
	@mkdir -p $(BACKUP_DIR)
	@echo "Saving world before backup..."
	-docker exec minecraft-server rcon-cli "save-all" 2>/dev/null
	-docker exec minecraft-server rcon-cli "save-off" 2>/dev/null
	@sleep 2
	@TIMESTAMP=$$(date +%Y%m%d_%H%M%S); \
	BACKUP_FILE=$(BACKUP_DIR)/$(WORLD_NAME)_$$TIMESTAMP.tar.gz; \
	echo "Creating backup: $$BACKUP_FILE"; \
	tar -czvf $$BACKUP_FILE -C minecraft-data $(WORLD_NAME)/; \
	echo "Backup complete: $$BACKUP_FILE"; \
	ls -lh $$BACKUP_FILE
	-docker exec minecraft-server rcon-cli "save-on" 2>/dev/null

list-backups:
	@echo "Available backups:"
	@ls -lh $(BACKUP_DIR)/*.tar.gz 2>/dev/null || echo "No backups found in $(BACKUP_DIR)/"

restore:
ifndef FILE
	@echo "Error: specify backup file with FILE=<path>"
	@echo "Example: make restore FILE=backups/waihi_beach_20260108_120000.tar.gz"
	@exit 1
endif
	@if [ ! -f "$(FILE)" ]; then echo "Error: $(FILE) not found"; exit 1; fi
	@echo "WARNING: This will overwrite the current $(WORLD_NAME) world!"
	@read -p "Are you sure? [y/N] " confirm; \
	if [ "$$confirm" != "y" ] && [ "$$confirm" != "Y" ]; then \
		echo "Cancelled"; exit 1; \
	fi
	@echo "Stopping server..."
	-docker compose down
	@echo "Extracting backup..."
	tar -xzvf $(FILE) -C minecraft-data/
	@echo "Restore complete. Start server with 'make start'"

# Admin commands
op:
ifndef NAME
	@echo "Error: specify player name with NAME=<player>"
	@echo "Example: make op NAME=o_man_2000"
	@exit 1
endif
	docker exec minecraft-server rcon-cli "op $(NAME)"

cmd:
ifndef CMD
	@echo "Error: specify command with CMD='<command>'"
	@echo "Example: make cmd CMD='say Hello!'"
	@exit 1
endif
	docker exec minecraft-server rcon-cli "$(CMD)"

# Convenience targets
warp-waihi:
	@echo "Players can use: /warp wahibeach"
	@echo "Or: /mv tp waihi_beach"

worlds:
	docker exec minecraft-server rcon-cli "mv list"
