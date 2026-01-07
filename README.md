# Minecraft Private Server for Kids

A Docker-based Minecraft server configured for safe play for children aged 7-16.

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

## Server Settings

| Setting | Value | Description |
|---------|-------|-------------|
| Difficulty | Easy | Suitable for younger players |
| Game Mode | Survival | Classic Minecraft experience |
| PVP | Disabled | No player vs player combat |
| Online Mode | Disabled | No login required, any username works |
| Bedrock Support | Enabled | Via GeyserMC |
| Max Players | 10 | Room for kids + friends |

## Connecting to the Server

### Java Edition (PC/Mac/Linux)
- **Port**: `25565`
- **Address**: Your server's IP address (e.g., `192.168.1.100`)
- Players can use any username they want (offline mode)

### Bedrock Edition (Phones, Tablets, Xbox, PlayStation, Switch)
- **Port**: `19132`
- **Address**: Your server's IP address (e.g., `192.168.1.100`)

#### Adding the Server on Bedrock:
1. Open Minecraft Bedrock Edition
2. Go to **Play** → **Servers** tab
3. Scroll down and click **Add Server**
4. Enter:
   - Server Name: `Kids Server` (or whatever you like)
   - Server Address: Your server's IP
   - Port: `19132`
5. Click **Save** and then **Join**

### Finding Your Server's IP Address

On the computer running the server:
- **Linux**: `hostname -I` or `ip addr`
- **Windows**: `ipconfig`
- **Mac**: `ifconfig`

Look for an IP like `192.168.x.x` or `10.0.x.x`

## Player Usernames

Since the server runs in **offline mode**:
- Java players can choose any username when launching Minecraft
- Bedrock players use their Xbox/Microsoft gamertag
- Multiple kids can play simultaneously with different usernames
- No paid Minecraft accounts required for Java Edition

## Making a Player an Operator (Admin)

To give a player admin commands:

```bash
docker exec minecraft-server rcon-cli op PlayerName
```

## Server Management Commands

```bash
# View server logs
docker compose logs -f minecraft

# Restart server
docker compose restart minecraft

# Stop server (saves world)
docker compose down

# Backup world data
cp -r minecraft-data minecraft-backup-$(date +%Y%m%d)
```

## Useful In-Game Commands (for operators)

| Command | Description |
|---------|-------------|
| `/op <name>` | Make player an operator |
| `/gamemode creative <name>` | Switch player to creative mode |
| `/gamemode survival <name>` | Switch player to survival mode |
| `/time set day` | Set time to day |
| `/weather clear` | Clear the weather |
| `/tp <player1> <player2>` | Teleport player1 to player2 |
| `/give <player> <item> [amount]` | Give items to a player |

## Customization

Edit `docker-compose.yml` to change:

- **DIFFICULTY**: `peaceful`, `easy`, `normal`, `hard`
- **MODE**: `survival`, `creative`, `adventure`, `spectator`
- **PVP**: `true` or `false`
- **MEMORY**: Adjust based on your system (default 2-4GB)
- **SEED**: Set a specific world seed

## Troubleshooting

### Server won't start
```bash
# Check logs for errors
docker compose logs minecraft
```

### Bedrock players can't connect
- Ensure UDP port 19132 is open in your firewall
- On some platforms (Xbox, Switch), you may need workarounds for LAN servers
- Check that GeyserMC loaded: `docker compose logs minecraft | grep -i geyser`

### Can't connect from other computers
- Ensure firewall allows ports 25565 (TCP) and 19132 (UDP)
- Verify the host IP address is correct

### Performance issues
- Increase MEMORY and MAX_MEMORY in docker-compose.yml
- Reduce VIEW_DISTANCE to 8 or 6

## Ports Summary

| Port | Protocol | Purpose |
|------|----------|---------|
| 25565 | TCP | Java Edition |
| 19132 | UDP | Bedrock Edition (GeyserMC) |
