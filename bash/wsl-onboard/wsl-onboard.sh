#!/bin/bash

# Setup resolv.conf
echo "Setting up DNS. You may be prompted for your password."
sudo cp files/resolv.conf /etc/resolv.conf

# Setup wsl.conf
echo "Setting up wsl.conf file."
sudo cp files/wsl.conf /etc/wsl.conf

# Create aliases
if [ -f /home/${USER}/.bash_aliases ]; then
  rm -r /home/${USER}/.bash_aliases
fi
cp ./files/aliases /home/${USER}/.bash_aliases

# Set up git global config
if [ -z "$(git config --global --get user.name)" ]; then
  echo "No user.name found in git global confi2g"
  echo "Please type your first and last name. Ex. John Smith"
  read -r username
  git config --global user.name "$username"
  echo -e "'$username' added to git global config\n"
  sleep 2
else
  echo -e "user.name exists in git global config\n"
  sleep 2
fi

if [ -z "$(git config --global --get user.email)" ]; then
  echo "No user.email found in git global config"
  echo "Please type your Welltower email address. Ex. jsmith@welltower.com"
  read -r email
  git config --global user.email "$email"
  echo -e "'$email' added to git global config\n"
  sleep 2
else
  echo -e "user.email exists in git global config\n"
  sleep 2
fi

# Update apt
echo "Running initial updates..."
sleep 1
echo "You may be prompted for your password..."
sleep 1
echo "This might take a minute..."
sudo apt -qq update 2>/dev/null >/dev/null 
sudo apt -qq upgrade -y 2>/dev/null >/dev/null
sudo apt -qq install pkg-config unzip wslu build-essential gcc jq zsh -y 2>/dev/null >/dev/null
echo "Initial updates complete."
sleep 2

# Create code that allows the user to choose between zsh and bash
echo "Choose your preferred shell:"
echo "1. zsh"
echo "2. bash"

read choice

if [[ ${choice} == 1 ]]; then
  default_shell="zsh"
elif [[ ${choice} == 2 ]]; then
  default_shell="bash"
fi

case $choice in
1)
    # Change default shell to zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>/dev/null >/dev/null
    chsh -s $(which zsh)
    echo -e "\nsourczsh is now your default shell.\n"
    echo "source /home/${USER}/.bash_aliases" | sudo tee -a /home/${USER}/.zshrc 2>/dev/null >/dev/null
    ;;
2)
    echo -e "bash is now your default shell.\n"
    ;;
*)
    echo "Invalid choice. Please enter 1 or 2."
    ;;
esac

# Install Linux Brew
if ! command -v brew &> /dev/null; then
  echo -e "Installing Linux brew..."
  yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 2>/dev/null >/dev/null
  (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/${USER}/.${default_shell}rc
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  brew update 2>/dev/null >/dev/null
  echo -e "Linux brew has been installed.\nPlease use 'brew -h' for usage.\n"
  sleep 2
else
  brew update 2>/dev/null >/dev/null
  brew upgrade 2>/dev/null >/dev/null
  echo -e "Linux brew is already installed.\nPlease use 'brew -h' for usage.\n"
  sleep 2
fi

# Install Terraform
if ! command -v terraform &> /dev/null
then
  echo -e "Installing Terraform..."
  sudo apt -qq update 2>/dev/null >/dev/null
  sudo apt -qq install -y gnupg software-properties-common 2>/dev/null >/dev/null
  wget -q -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg 2>/dev/null >/dev/null
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list 2>/dev/null >/dev/null
  sudo apt -qq update 2>/dev/null >/dev/null
  sudo apt -qq install terraform 2>/dev/null >/dev/null
  terraform -install-autocomplete
  echo -e "Terraform has been successfully installed.\nPlease use 'terraform -help' for usage.\nNote: You can also use the alias 'tf'. Ex: 'tf -help'\n"
  sleep 2
else
  echo -e "Terraform is already installed!\nPlease use 'terraform -help' for usage.\nNote: You can also use the alias 'tf'. Ex: 'tf -help'\n"
  sleep 2
fi

if ! command -v tfsec &> /dev/null; then
  curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash 2>/dev/null >/dev/null
  echo -e "tfsec has been successfully installed.\nPlease use 'tfsec -h' for usage.\n"
  sleep 2
else
  echo -e "tfsec is already installed!\nPlease use 'tfsec -h' for usage.\n"
  sleep 2
fi

# Install python3
if ! command -v python3 &> /dev/null; then
  echo -e "Installing python3..."
  sudo apt -qq install python3 -y 2>/dev/null >/dev/null
  echo -e "python3 has been successfully installed.\nPlease use 'python3 -h' for usage.\n"
  sleep 2
else
  echo -e "Python3 is already installed!\nPlease use 'python3 -h' for usage.\n"
  sleep 2
fi

# Install python3-pip
if ! command -v pip &> /dev/null; then
  echo -e "Installing pip..."
  sudo apt -qq install python3-pip -y 2>/dev/null >/dev/null
  echo -e "Pip has been successfully installed.\nPlease use 'pip -h' for usage.\n"
  sleep 2
else
  echo -e "Pip is already installed!\nPlease use 'pip -h' for usage.\n"
  sleep 2
fi

# Install python3-venv
if ! command -v python3 -m venv .venv &> /dev/null; then
  echo -e "Installing python3-venv..."
  sudo apt -qq install python3-venv -y 2>/dev/null >/dev/null
  echo -e "Python3-venv has been successfully installed.\n"
  sleep 2
else
  rm -rf .venv
  echo -e "Python3-venv is already installed!\n"
  sleep 2
fi

# Install Golang
if ! command -v go &> /dev/null; then
  echo -e "Installing golang..."
  curl -s -OL https://golang.org/dl/go1.21.0.linux-amd64.tar.gz
  sudo tar -C /usr/local -xf go1.21.0.linux-amd64.tar.gz
  echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/${USER}/.${default_shell}rc
  rm -rf go1.21.0.linux-amd64.tar.gz
  echo -e "Golang has been successfully installed.\nPlease use 'go -h' for usage.\n"
  sleep 2
else
  echo -e "Golang is already installed!\nPlease use 'go -h' for usage.\n"
  sleep 2
fi

# Install aws cli
if ! command -v aws &> /dev/null; then
  echo -e "Installing aws cli..."
  curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip -qq awscliv2.zip
  sudo ./aws/install 2>/dev/null >/dev/null
  rm -rf aws*
  mkdir /home/${USER}/.aws
  chmod 755 /home/${USER}/.aws
  cp ./files/aws_config /home/${USER}/.aws/config
  chmod 600 /home/${USER}/.aws/config
  echo -e "aws cli has been successfully installed.\nPlease use 'aws -h' for usage.\n"
  sleep 2
else
  echo -e "aws cli is already installed!\nPlease use 'aws -h' for usage.\n"
  sleep 2
fi

# Install docker
if ! command -v docker &> /dev/null; then
  echo -e "Installing docker..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt  -qq update 2>/dev/null >/dev/null
  sudo apt -qq install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 2>/dev/null >/dev/null
  sudo groupadd docker 2>/dev/null >/dev/null
  sudo usermod -aG docker $USER
  echo -e "Docker has been successfully installed.\nPlease use 'docker -h' for usage.\n"
  sleep 2
else
  echo -e "Docker is already installed!\nPlease use 'docker -h' for usage.\n"
  sleep 2
fi

# Install kubectl
if ! command -v kubectl &> /dev/null; then
  echo -e "Installing kubectl..."
  sudo apt -qq update 2>/dev/null >/dev/null
  # apt-transport-https may be a dummy package; if so, you can skip that package
  sudo apt -qq install -y apt-transport-https ca-certificates curl 2>/dev/null >/dev/null
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list 2>/dev/null >/dev/null
  sudo apt -qq update 2>/dev/null >/dev/null
  sudo apt -qq install -y kubectl 2>/dev/null >/dev/null
  if [[ "${default_shell}" == "zsh" ]]; then
    echo "source <(kubectl completion zsh)" | tee -a /home/$USER/.zshrc 2>/dev/null >/dev/null
  else
    kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
    sudo chmod a+r /etc/bash_completion.d/kubectl
    echo 'complete -o default -F __start_kubectl k' >>/home/${USER}/.bashrc
  fi
  source /home/${USER}/.${default_shell}rc
  curl -L -s -O "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl-convert"
  # Validate binary?
  # curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl-convert.sha256"
  # echo "$(cat kubectl-convert.sha256) kubectl-convert" | sha256sum --check
  # if ok kubectl-convert: OK
  sudo install -o root -g root -m 0755 kubectl-convert /usr/local/bin/kubectl-convert
  echo -e "kubectl has been successfully installed.\nPlease use 'kubectl -h' for usage.\n"
  rm -rf kubectl-convert
  echo -e "kubectl has been successfully installed.\nPlease use 'kubectl -h' for usage.\nNote: You can also use the alias 'k'. Ex: 'k -help'\n"
  sleep 2
else
  echo -e "kubectl is already installed!\nPlease use 'kubectl -h' for usage.\nNote: You can also use the alias 'k'. Ex: 'k -help'\n"
  sleep 2
fi

# Create code that allows the user to choose between zsh and bash
echo "Do you access to the Welltower Kubernetes clusters? (y/N)"

read answer

echo ${answer}

# Create kubeconfig from clusters
if [ ${answer} != "y" ]; then
  echo -e "You will need to setup access to the Welltower Kubernetes clusters when you have access.\n"
  echo -e "To setup access run the command 'aws eks update-kubeconfig --region us-east-1 --name <name of cluster>'"
  sleep 2
elif [ ! -e /home/${USER}/.kube/config ]; then
  echo -e "Setting up kubeconfig for Kubernetes."
  sleep 1
  echo -e "A browser window will open and you will need to authenticate to AWS to complete this step.\n"
  sleep 2
# aws sso login --profile welltower-platform-prod
  aws sso login 2>/dev/null >/dev/null
  export AWS_PROFILE=welltower-platform-prod
  aws eks update-kubeconfig --region us-east-1 --name wl-eks-prod
  export AWS_PROFILE=welltower-platform-uat
  aws eks update-kubeconfig --region us-east-1 --name wl-eks-uat
  export AWS_PROFILE=welltower-platform-dev
  aws eks update-kubeconfig --region us-east-1 --name wl-eks-dev
  echo -e "\nAll kubectl contexts have been added.\nTo view contexts use kubectl config --get-contexts.\n"
  sleep 2
elif [ `kubectl config get-contexts | wc -l` -ne "4" ]; then
  aws sso login --profile welltower-platform-prod 2>/dev/null >/dev/null
  if [ ! "`kubectl config get-contexts | grep "arn:aws:eks:us-east-1:725675846413:cluster/wl-eks-dev"`" ]; then
    export AWS_PROFILE=welltower-platform-dev
    aws eks update-kubeconfig --region us-east-1 --name wl-eks-dev
  fi
  if [ ! "`kubectl config get-contexts | grep "arn:aws:eks:us-east-1:358646388167:cluster/wl-eks-uat"`" ]; then
    export AWS_PROFILE=welltower-platform-uat
    aws eks update-kubeconfig --region us-east-1 --name wl-eks-uat
  fi
  if [ ! "`kubectl config get-contexts | grep "arn:aws:eks:us-east-1:602837221957:cluster/wl-eks-prod"`" ]; then
    export AWS_PROFILE=welltower-platform-prod
    aws eks update-kubeconfig --region us-east-1 --name wl-eks-prod 
  fi
  echo -e "\nAll kubectl contexts have been added.\nTo view contexts use kubectl config --get-contexts.\n"
  sleep 2
else
  echo -e "kubeconfig file already exists and has all contexts.\nTo view contexts use kubectl config --get-contexts.\n"
  sleep 2
fi

# Rename contexts in kubeconfig
dev_context_name=$(kubectl config view -o jsonpath='{.contexts[?(@.context.cluster == "arn:aws:eks:us-east-1:725675846413:cluster/wl-eks-dev")].name}')
uat_context_name=$(kubectl config view -o jsonpath='{.contexts[?(@.context.cluster == "arn:aws:eks:us-east-1:358646388167:cluster/wl-eks-uat")].name}')
prod_context_name=$(kubectl config view -o jsonpath='{.contexts[?(@.context.cluster == "arn:aws:eks:us-east-1:602837221957:cluster/wl-eks-prod")].name}')
if [ "${dev_context_name}" != "wl-eks-dev" ] || [ "${uat_context_name}" != "wl-eks-uat" ] || [ "${prod_context_name}" != "wl-eks-prod" ]; then
  echo -e "Renaming kubectl contexts."
  if [ "${dev_context_name}" != "wl-eks-dev" ]; then
    echo -e "Renaming dev kubectl context."
    kubectl config rename-context "${dev_context_name}" wl-eks-dev
    echo ""
    sleep 2
  fi
  if [ "${uat_context_name}" != "wl-eks-uat" ]; then
    echo -e "Renaming uat kubectl context."
    kubectl config rename-context "${uat_context_name}" wl-eks-uat
    echo ""
    sleep 2
  fi
  if [ "${prod_context_name}" != "wl-eks-prod" ]; then
    echo -e "Renaming prod kubectl context."
    kubectl config rename-context "${prod_context_name}" wl-eks-prod
    echo ""
    sleep 2
  fi
  echo -e "kubectl contexts have been renamed.\n"
  sleep 2
else
  echo -e "kubectl contexts are already renamed.\nTo view available contexts run 'kubectl get-contexts'\n"
  sleep 2
fi

# Install k9s
if ! command -v k9s &> /dev/null; then
  echo -e "Installing k9s..."
  brew install derailed/k9s/k9s 2>/dev/null >/dev/null
  echo -e "k9s has been successfully installed.\nPlease use 'go -h' for usage.\n"
  sleep 2
else
  echo -e "k9s is already installed!\nPlease use 'k9s -h' for usage.\n"
  sleep 2
fi

# Install Kubectx and Kubens
if ! command -v kubectx &> /dev/null; then
  echo -e "\nInstalling kubectx and kubens tools..."
  sudo git clone --quiet https://github.com/ahmetb/kubectx /opt/kubectx >/dev/null
  sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
  sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
  git clone --quiet https://github.com/ahmetb/kubectx.git /home/${USER}/.kubectx >/dev/null
  if [[ "${default_shell}" == "zsh" ]]; then
    mkdir -p /home/${USER}/.oh-my-zsh/custom/completions
    chmod -R 755 /home/${USER}/.oh-my-zsh/custom/completions
    ln -s /opt/kubectx/completion/_kubectx.zsh /home/${USER}/.oh-my-zsh/custom/completions/_kubectx.zsh
    ln -s /opt/kubectx/completion/_kubens.zsh /home/${USER}/.oh-my-zsh/custom/completions/_kubens.zsh
    echo "fpath=($ZSH/custom/completions \$fpath)" >> /home/${USER}/.zshrc
  else
    COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
    sudo ln -sf /home/${USER}/.kubectx/completion/kubens.bash $COMPDIR/kubens
    sudo ln -sf /home/${USER}/.kubectx/completion/kubectx.bash $COMPDIR/kubectx
    echo "export PATH=/home/${USER}/.kubectx:\$PATH" >> /home/${USER}/.bashrc
  fi
  echo -e "kubectx and kubens tools have been successfully installed.\nPlease use 'kubectx -h' and 'kubens -h' for usage.\n"
  sleep 2
else
  echo -e "kubectx and kubens tools are already installed!\nPlease use 'kubectx -h' and 'kubens -h' for usage.\n"
  sleep 2
fi

echo -e "All tools have been installed.\n"
sleep 2

echo -e "All aliases are located in /home/${USER}/.bash_aliases. You can view these aliases by running 'cat /home/${USER}/.bash_aliases'."