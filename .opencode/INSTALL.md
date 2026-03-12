# Installing Pragmatic for OpenCode

## Prerequisites

- [OpenCode.ai](https://opencode.ai) installed
- Git installed

## Installation Steps

### 1. Clone Pragmatic

```bash
git clone https://github.com/xPutnikx/pragmatic.git ~/.config/opencode/pragmatic
```

### 2. Register the Plugin

Create a symlink so OpenCode discovers the plugin:

```bash
mkdir -p ~/.config/opencode/plugins
rm -f ~/.config/opencode/plugins/pragmatic.js
ln -s ~/.config/opencode/pragmatic/.opencode/plugins/pragmatic.js ~/.config/opencode/plugins/pragmatic.js
```

### 3. Symlink Skills

Create a symlink so OpenCode's native skill tool discovers Pragmatic skills:

```bash
mkdir -p ~/.config/opencode/skills
rm -rf ~/.config/opencode/skills/pragmatic
ln -s ~/.config/opencode/pragmatic/skills ~/.config/opencode/skills/pragmatic
```

### 4. Restart OpenCode

Restart OpenCode. The plugin will automatically inject Pragmatic context.

## Usage

### Finding Skills

Use OpenCode's native `skill` tool to list available skills:

```
use skill tool to list skills
```

### Loading a Skill

Use OpenCode's native `skill` tool to load a specific skill:

```
use skill tool to load pragmatic/brainstorming
```

## Updating

```bash
cd ~/.config/opencode/pragmatic
git pull
```

## Troubleshooting

### Plugin not loading

1. Check plugin symlink: `ls -l ~/.config/opencode/plugins/pragmatic.js`
2. Check source exists: `ls ~/.config/opencode/pragmatic/.opencode/plugins/pragmatic.js`
3. Check OpenCode logs for errors

### Skills not found

1. Check skills symlink: `ls -l ~/.config/opencode/skills/pragmatic`
2. Verify it points to: `~/.config/opencode/pragmatic/skills`
3. Use `skill` tool to list what's discovered

## Support

- **Issues**: https://github.com/xPutnikx/pragmatic/issues
