# airiclenz/homebrew-tap

Personal Homebrew tap for my CLI tools.

## Available formulae

| Formula | Description |
|---------|-------------|
| [`llama-launcher`](https://github.com/airiclenz/llama-launcher) | CLI tool for managing local LLM servers (llama.cpp, Ollama, LM Studio) |
| [`screen-transit`](https://github.com/airiclenz/screen-transit) | Move the cursor between displays from the keyboard |

## Install

```bash
brew tap airiclenz/tap
brew trust --tap airiclenz/tap
brew install llama-launcher    # or screen-transit
```

The `brew trust` step is required on Homebrew 5.1+. Without it, `brew update` prints a `tap is not trusted` warning and a future Homebrew release may refuse to load the tap altogether (when `HOMEBREW_REQUIRE_TAP_TRUST` becomes the default). Running it once per machine clears the warning permanently; trust is recorded in `~/.homebrew/trust.json` (or `$XDG_CONFIG_HOME/homebrew/trust.json`).

## Upgrade

```bash
brew update
brew upgrade llama-launcher    # or screen-transit
```

## Uninstall

```bash
brew uninstall llama-launcher
brew untrust --tap airiclenz/tap    # optional: revoke trust
brew untap airiclenz/tap            # optional: remove the tap
```
