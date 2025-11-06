single shell script (install_aws_eksctl_kubectl.sh) that automates:
✅ Installing AWS CLI v2
✅ Installing eksctl
✅ Installing kubectl
✅ Handling both Ubuntu/Debian (apt) and Amazon Linux (yum)

📜 Script: install_aws_eksctl_kubectl.sh
#!/bin/bash
# ------------------------------------------------------------------------
# Script Name: install_aws_eksctl_kubectl.sh
# Description: Installs and configures AWS CLI v2, eksctl, and kubectl
# Works On: Ubuntu/Debian & Amazon Linux
# ------------------------------------------------------------------------

set -e

# Detect OS type
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot detect OS type. Exiting..."
    exit 1
fi

echo "Detected OS: $OS"

# Update system packages
echo "Updating system packages..."
if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    sudo apt-get update -y
elif [[ "$OS" == "amzn" || "$OS" == "centos" || "$OS" == "rhel" ]]; then
    sudo yum update -y
else
    echo "Unsupported OS. Exiting..."
    exit 1
fi

# ------------------------------------------------------------------------
# 1. Install AWS CLI v2
# ------------------------------------------------------------------------
echo "Installing AWS CLI v2..."

cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    sudo apt-get install unzip -y
else
    sudo yum install unzip -y
fi

unzip -q awscliv2.zip
sudo ./aws/install

# Verify AWS CLI installation
echo "Verifying AWS CLI installation..."
aws --version

# Configure AWS CLI
echo "Configuring AWS CLI..."
echo "--------------------------------------------------"
echo "Enter your AWS credentials below:"
aws configure
echo "--------------------------------------------------"

# ------------------------------------------------------------------------
# 2. Install eksctl
# ------------------------------------------------------------------------
echo "Installing eksctl..."

cd /usr/local/bin
sudo curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz"
sudo tar -xzf eksctl_$(uname -s)_amd64.tar.gz
sudo rm eksctl_$(uname -s)_amd64.tar.gz

# Verify eksctl installation
eksctl version

# ------------------------------------------------------------------------
# 3. Install kubectl
# ------------------------------------------------------------------------
echo "Installing kubectl..."

cd /tmp
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Verify kubectl installation
kubectl version --client

# ------------------------------------------------------------------------
echo "✅ Installation completed successfully!"
echo "Tools installed:"
echo "  - AWS CLI: $(aws --version 2>&1)"
echo "  - eksctl:  $(eksctl version)"
echo "  - kubectl: $(kubectl version --client --short)"
echo "--------------------------------------------------"

🔧 Usage
chmod +x install_aws_eksctl_kubectl.sh
sudo ./install_aws_eksctl_kubectl.sh

🧩 Notes

Prompts you interactively to enter AWS credentials (aws configure).

Works seamlessly for both Ubuntu/Debian and Amazon Linux 2.

Installs binaries under /usr/local/bin for global access.

Verifies each tool installation automatically.
