# WSL2 Onboarding Script

## Assumptions

1. You have already installed Windows Subsystem for Linux 2 (WSL2). If you have not you can do so by opening Powershell as an administrator and running:

`wsl --install`

## Description
This script is intended to install the following items in Windows Subsystem for Linux:

1. aws cli
    * Loads the current config for the Welltower AWS SSO
    * You will still need to login to AWS SSO by invoking `aws sso login`
2. Python3 venv
3. Python3 pip
4. kubectl: command-line tool for Kubernetes
    * Creates an alias of `k` for the `kubernetes` command.
5. terraform: command-line tool for Terraform
    * Creates an alias of `tf` for the `terraform` command.
6. kubectx: command-line tool to switch between contexts in Kubernetes
7. kubens: command-line tool to switch between namespaces in Kubernetes

The script also sets up git config by asking for your first and last name and then your email address.

## How to use the script
To invoke the script simply use the following command on the WSL2 command line:

`source wsl-onboard.sh`

You can also invoke the script with `./wsl-onboard.sh` but it will not source the aliases that are added for kubectl (k) and terraform (tf).