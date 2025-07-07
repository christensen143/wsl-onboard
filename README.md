# WSL2 Development Environment Setup Script

A comprehensive automation script that sets up a complete cloud-native development environment on Windows Subsystem for Linux 2 (WSL2). This script installs and configures essential development tools, saving hours of manual setup time.

## 🎯 Purpose

This script automates the setup of a professional development environment for:
- Cloud infrastructure management (AWS, Terraform)
- Kubernetes development and operations
- Container-based development (Docker)
- Modern programming languages (Python, Go)
- DevOps workflows

## 📋 Prerequisites

- **Windows Subsystem for Linux 2 (WSL2)** must be installed
  - To install WSL2, open PowerShell as Administrator and run:
    ```powershell
    wsl --install
    ```
  - Restart your computer after installation
- **Ubuntu** (or similar Linux distribution) installed in WSL2
- **Internet connection** for downloading packages

## 🚀 Quick Start

1. Clone or download this repository to your WSL2 environment
2. Navigate to the script directory
3. Run the script using:
   ```bash
   source wsl-onboard.sh
   ```
   
   **Important:** Use `source` to ensure aliases are loaded in your current shell session

## 📦 What Gets Installed

### Development Tools
- **Homebrew** - Package manager for Linux
- **Git** - Version control (with user configuration)
- **Zsh or Bash** - Your choice of shell (with Oh My Zsh for Zsh)

### Cloud & Infrastructure
- **AWS CLI** - Amazon Web Services command-line interface
  - Includes AWS config template at `~/.aws/config`
- **Terraform** - Infrastructure as Code tool
  - Alias: `tf` → `terraform`
- **tfsec** - Static analysis security scanner for Terraform

### Container & Orchestration
- **Docker** - Container platform with Docker Compose
- **kubectl** (v1.31) - Kubernetes command-line tool
  - Alias: `k` → `kubectl`
- **kubectx/kubens** - Kubernetes context and namespace switchers
  - Aliases: `kctx` → `kubectx`, `kns` → `kubens`
- **k9s** - Terminal UI for Kubernetes clusters

### Programming Languages
- **Python 3** - With pip and venv support
- **Go** (v1.21.0) - Go programming language

### Additional Utilities
- Build essentials (gcc, make, etc.)
- Common tools (jq, unzip, curl, wget)

## 🛠️ Features

### Intelligent Installation
- **Idempotent**: Safe to run multiple times - skips already installed tools
- **Non-destructive**: Checks for existing installations before proceeding
- **Clean output**: Suppresses verbose installation logs while showing progress

### Shell Configuration
- **Shell choice**: Interactive selection between Zsh and Bash
- **Auto-completion**: Sets up command completion for kubectl and terraform
- **Persistent aliases**: Configured in `~/.bash_aliases` for both shells

### AWS Integration
- **Config template**: Provides a starter AWS config file
- **SSO support**: Includes `sso-login` alias for AWS SSO authentication

## 📝 Aliases Created

| Alias | Command | Description |
|-------|---------|-------------|
| `tf` | `terraform` | Terraform shorthand |
| `k` | `kubectl` | Kubernetes CLI shorthand |
| `kns` | `kubens` | Switch Kubernetes namespaces |
| `kctx` | `kubectx` | Switch Kubernetes contexts |
| `sso-login` | `aws sso login` | AWS SSO authentication |

## ⚙️ Post-Installation

### Docker Setup
After installation, log out and back in for Docker group permissions to take effect, or run:
```bash
newgrp docker
```

### AWS Configuration
Customize your AWS profiles by editing:
```bash
nano ~/.aws/config
```

### Shell Reload
If aliases aren't immediately available, reload your shell configuration:
```bash
# For Bash
source ~/.bashrc

# For Zsh
source ~/.zshrc
```

## 🔧 Customization

### Adding Tools
To add new tools to the script:
1. Create an installation check using `command -v`
2. Add the installation commands
3. Include any necessary PATH or completion setup

### Modifying Aliases
Edit the `files/aliases` file to add or modify command aliases

## 📁 Project Structure

```
wsl-onboard/
├── wsl-onboard.sh      # Main installation script
├── files/
│   ├── aliases         # Shell aliases configuration
│   └── aws/
│       └── config      # AWS CLI configuration template
├── README.md           # This file
└── CLAUDE.md          # Development documentation
```

## ❗ Important Notes

- **Run time**: Initial installation takes 10-15 minutes depending on internet speed
- **Disk space**: Requires approximately 2-3 GB for all tools
- **Updates**: The script updates existing tools when re-run
- **Errors**: If any installation fails, you can safely re-run the script

## 🤝 Contributing

Feel free to submit issues or pull requests to improve the script. When contributing:
- Maintain the idempotent nature of installations
- Follow the existing code style
- Test changes in a fresh WSL2 environment

## 📄 License

This project is provided as-is for personal and commercial use.