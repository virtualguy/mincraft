# Minecraft Minigames Server for Kids

A Docker-based Minecraft server with minigames configured for children aged 7-16.

**Supports both Java Edition and Bedrock Edition (phones, tablets, consoles)!**

## Quick Start

```bash
# Start the server
docker compose up -d

# View logs
docker compose logs -f minecraft

# Stop the server
docker compose down
```

## Installed Plugins

| Plugin | Purpose |
|--------|---------|
| **ScreamingBedWars** | BedWars, CakeWars, EggWars, AnchorWars minigames |
| **BattleArena** | Pre-made arenas: FFA, Deathmatch, Skirmish, Colosseum |
| **EssentialsX** | /home, /spawn, /tpa, /warp, economy, kits |
| **Multiverse-Core** | Multiple worlds management |
| **Terra** | Beautiful custom terrain generation |
| **Geyser + Floodgate** | Bedrock Edition support |
| **Vault** | Economy API |

## Server Settings

| Setting | Value | Description |
|---------|-------|-------------|
| Difficulty | Normal | Standard Minecraft |
| Game Mode | Adventure | Protected spawn area |
| PVP | Enabled | For minigames |
| Online Mode | Disabled | No login required |
| Bedrock Support | Enabled | Via GeyserMC |
| Max Players | 20 | Room for kids + friends |

## Connecting to the Server

### Java Edition (PC/Mac/Linux)
- **Port**: `25565`
- **Address**: Your server's IP address (e.g., `192.168.1.90`)
- Players can use any username (offline mode)

### Bedrock Edition (Phones, Tablets, Xbox, PlayStation, Switch)
- **Port**: `19132`
- **Address**: Your server's IP address (e.g., `192.168.1.90`)

## Minigame Commands

### BattleArena (Ready to Play!)
| Command | Description |
|---------|-------------|
| `/arena join` | Join an arena match |
| `/ffa join` | Join Free-For-All |
| `/deathmatch join` | Join Deathmatch |
| `/skirmish join` | Join Skirmish |
| `/arena leave` | Leave current game |

### BedWars (Requires Setup)
| Command | Description |
|---------|-------------|
| `/bw join <arena>` | Join a BedWars game |
| `/bw leave` | Leave current game |
| `/bw list` | List available arenas |

### EssentialsX Commands
| Command | Description |
|---------|-------------|
| `/spawn` | Teleport to spawn |
| `/home` | Teleport to your home |
| `/sethome` | Set your home location |
| `/tpa <player>` | Request teleport to player |
| `/back` | Return to previous location |

### World Management (Multiverse)
| Command | Description |
|---------|-------------|
| `/mv list` | List all worlds |
| `/mv tp <world>` | Teleport to world |
| `/mv create <name> normal -g Terra:OVERWORLD` | Create Terra world |

## Setting Up BedWars Arenas

BedWars arenas need to be created by an admin in-game:

1. Make yourself an operator:
   ```bash
   docker exec minecraft-server rcon-cli op YourName
   ```

2. In-game, use `/bw admin` to enter setup mode

3. Follow the setup wizard to:
   - Set arena boundaries
   - Place team spawns
   - Place bed locations
   - Add item spawners (iron, gold, diamond, emerald)
   - Set lobby spawn

4. Save with `/bw admin save <arena-name>`

## Waihi Beach World (Real Terrain!)

The server includes a special world based on **real terrain data** from Waihi Beach and Bowentown, New Zealand! The terrain was generated from actual elevation data, so you can explore a Minecraft version of the real coastline.

### Accessing Waihi Beach World
```bash
# Teleport to Waihi Beach
/warp wahibeach

# Or use Multiverse
/mv tp waihi_beach
```

### World Details
- **Coverage**: ~5.3km x 6.7km of real Waihi Beach/Bowentown terrain
- **Coordinates**: -37.44 to -37.38 latitude, 175.92 to 175.98 longitude
- **Features**: Real coastline, hills, and elevation from OpenStreetMap + AWS Terrain Tiles
- **New chunks**: Generated using Terra for seamless coastal terrain

## Creating a Terra World

To create a beautiful custom-generated world:

```bash
# In-game or via console:
/mv create terra_world normal -g Terra:OVERWORLD
```

## Making a Player an Operator

```bash
docker exec minecraft-server rcon-cli op PlayerName
```

## Server Management

```bash
# View logs
docker compose logs -f minecraft

# Restart server
docker compose restart minecraft

# Stop server
docker compose down

# Backup world data
cp -r minecraft-data minecraft-backup-$(date +%Y%m%d)

# Send console command
docker exec -u 1000 minecraft-server mc-send-to-console "say Hello everyone!"
```

## Troubleshooting

### Server won't start
```bash
docker compose logs minecraft
```

### Bedrock players can't connect
- Ensure UDP port 19132 is open in firewall
- Check Geyser loaded: `docker compose logs minecraft | grep -i geyser`

### Performance issues
- Increase MEMORY in docker-compose.yml (default 3-5GB)
- Reduce VIEW_DISTANCE to 8

## Ports Summary

| Port | Protocol | Purpose |
|------|----------|---------|
| 25565 | TCP | Java Edition |
| 19132 | UDP | Bedrock Edition |
