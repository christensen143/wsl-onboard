# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a WSL2 (Windows Subsystem for Linux 2) onboarding automation script that sets up a complete cloud-native development environment. The project consists of a single main bash script (`wsl-onboard.sh`) that installs and configures various development tools.

## Key Commands

### Running the Script
```bash
# Recommended - preserves aliases in current shell
source wsl-onboard.sh

# Alternative - runs in subshell (aliases won't persist)
./wsl-onboard.sh
```

### Testing Changes
Since this is an installation script, test changes by:
1. Running in a fresh WSL2 environment or container
2. Checking individual tool installations with `command -v <tool>`
3. Verifying aliases are set correctly after sourcing

## Architecture

### Script Structure
The `wsl-onboard.sh` script follows this installation flow:
1. Sources aliases from `files/aliases`
2. Configures git user settings (interactive)
3. Updates system packages
4. Prompts for shell preference (Zsh or Bash)
5. Installs tools in this order:
   - Homebrew
   - AWS CLI
   - Python3 ecosystem (pip, venv)
   - Terraform (with tfsec)
   - Go (v1.21.0)
   - Docker
   - Kubernetes tools (kubectl, kubectx/kubens, k9s)
6. Configures shell completions and PATH

### Key Design Patterns
- **Idempotent installations**: Each tool checks if already installed using `command -v`
- **Silent output**: Uses `2>/dev/null >/dev/null` to suppress verbose installation output
- **Shell-agnostic**: Supports both Bash and Zsh with appropriate configuration
- **User feedback**: Shows clear progress messages during installation

### File Structure
```
/
├── wsl-onboard.sh      # Main installation script
├── files/
│   ├── aliases         # Shell aliases (tf, k, kns, kctx, sso-login)
│   └── aws/
│       └── config      # AWS CLI configuration template
├── README.md           # User documentation
└── CLAUDE.md          # This file
```

## Important Considerations

1. **WSL2 Requirement**: This script is specifically designed for WSL2 environments
2. **Shell Sourcing**: The script must be sourced (not executed) to properly set aliases
3. **Version Pinning**: Some tools use specific versions (Go 1.21.0, kubectl 1.31)
4. **Docker Permissions**: Script adds user to docker group - requires logout/login to take effect
5. **Interactive Prompts**: Script asks for git config and shell preference - cannot be fully automated
6. **AWS Configuration**: Script copies AWS config template to ~/.aws/config if it doesn't exist

## Common Modifications

When modifying the script:
- Maintain the installation check pattern: `if ! command -v <tool> &>/dev/null; then`
- Keep output suppression for clean user experience
- Update both Bash and Zsh configuration sections when adding shell-specific features
- Test in a fresh WSL2 environment to ensure idempotency