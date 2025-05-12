# macOS Setup Scripts

## Usage

### Initial Setup

When setting up a new Mac:

```sh
./init.sh
```

### Sync configurations

```sh
./sync.sh
```

## Troubleshooting

### Debug MCP server for Claude Desktop

```sh
tail -n 20 -f ~/Library/Logs/Claude/mcp*.log
```

### Check the current config for Claude Desktop

```sh
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json
```
