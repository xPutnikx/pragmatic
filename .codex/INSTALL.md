# Installing Pragmatic for Codex

Enable Pragmatic skills in Codex via native skill discovery. Just clone and symlink.

## Prerequisites

- Git

## Installation

1. **Clone the Pragmatic repository:**
   ```bash
   git clone https://github.com/xPutnikx/pragmatic.git ~/.codex/pragmatic
   ```

2. **Create the skills symlink:**
   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/pragmatic/skills ~/.agents/skills/pragmatic
   ```

   **Windows (PowerShell):**
   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
   cmd /c mklink /J "$env:USERPROFILE\.agents\skills\pragmatic" "$env:USERPROFILE\.codex\pragmatic\skills"
   ```

3. **Restart Codex** (quit and relaunch the CLI) to discover the skills.

## Verify

```bash
ls -la ~/.agents/skills/pragmatic
```

You should see a symlink (or junction on Windows) pointing to your Pragmatic skills directory.

## Updating

```bash
cd ~/.codex/pragmatic && git pull
```

Skills update instantly through the symlink.

## Uninstalling

```bash
rm ~/.agents/skills/pragmatic
```

Optionally delete the clone: `rm -rf ~/.codex/pragmatic`.
