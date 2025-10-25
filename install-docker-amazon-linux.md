# 🐳 Docker Installation on Amazon Linux

This guide provides a **ready-to-run shell script** for installing Docker on **Amazon Linux 2** or **Amazon Linux 2023**.

---

## 🧩 Script: `install-docker.sh`

```bash
#!/bin/bash
# ===============================================
# Docker Installation Script for Amazon Linux
# Works with: Amazon Linux 2 / Amazon Linux 2023
# ===============================================

set -e

echo "-----------------------------------------"
echo "🚀 Starting Docker installation on Amazon Linux..."
echo "-----------------------------------------"

# Step 1: Update system packages
echo "[1/6] Updating system packages..."
sudo yum update -y

# Step 2: Install required packages
echo "[2/6] Installing required packages..."
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Step 3: Add Docker repository (for Amazon Linux 2)
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$VERSION_ID" == "2" ]]; then
        echo "[3/6] Adding Docker CE repository for Amazon Linux 2..."
        sudo amazon-linux-extras enable docker
        sudo yum install -y docker
    else
        echo "[3/6] Installing Docker from the default repo for Amazon Linux 2023..."
        sudo dnf install -y docker
    fi
else
    echo "Unable to detect OS version. Please verify manually."
    exit 1
fi

# Step 4: Enable and start Docker
echo "[4/6] Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Step 5: Add current user to docker group
echo "[5/6] Adding current user (${USER}) to docker group..."
sudo usermod -aG docker $USER

# Step 6: Verify Docker installation
echo "[6/6] Verifying Docker installation..."
docker --version && echo "✅ Docker installed successfully!" || echo "❌ Docker installation failed."

echo "-----------------------------------------"
echo "🎯 Installation complete!"
echo "You may need to log out and log back in to use Docker without sudo."
echo "-----------------------------------------"


How to Use

Save the script above as install-docker.sh.

Make it executable:

chmod +x install-docker.sh


Run the script:

./install-docker.sh


After installation, log out and log back in so the Docker group membership takes effect.

✅ Verify Installation

1. Open New Terminal and perform below steps.

To confirm Docker is installed and running correctly:

docker run hello-world


Expected output:

Hello from Docker!
This message shows that your installation appears to be working correctly.

Note : If your run  "docker run hello-world" on installed docker terminal,below error comes.

[ec2-user@ip-172-31-83-67 ~]$ docker run hello-world
docker: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Head "http://%2Fvar%2Frun%2Fdocker.sock/_ping": dial unix /var/run/docker.sock: connect: permission denied.
See 'docker run --help'.
[ec2-user@ip-172-31-83-67 ~]$
