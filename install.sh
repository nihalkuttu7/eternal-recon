#!/bin/bash

echo "[*] Installing required tools for automated reconnaissance..."

# Update and install prerequisites
echo "[*] Updating system and installing prerequisites..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget python3 python3-pip

# Install Go (required for Assetfinder, Httpx, Katana, Nuclei)
echo "[*] Installing Go programming language..."
GO_VERSION="1.21.1"
wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
export PATH=$PATH:/usr/local/go/bin
echo "[*] Go installed successfully!"

# Install Assetfinder
echo "[*] Installing Assetfinder..."
go install github.com/tomnomnom/assetfinder@latest
echo "[*] Assetfinder installed."

# Install Httpx
echo "[*] Installing Httpx..."
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
echo "[*] Httpx installed."

# Install Katana
echo "[*] Installing Katana..."
go install github.com/projectdiscovery/katana/cmd/katana@latest
echo "[*] Katana installed."

# Install Nuclei
echo "[*] Installing Nuclei..."
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
echo "[*] Nuclei installed."

# Clone Custom Nuclei Templates repository
TEMPLATES_DIR="/home/kali/Custom-Nuclei-Templates"
echo "[*] Cloning custom Nuclei templates repository into $TEMPLATES_DIR..."
if [ -d "$TEMPLATES_DIR" ]; then
    echo "[*] Directory $TEMPLATES_DIR already exists. Pulling the latest changes..."
    git -C $TEMPLATES_DIR pull
else
    git clone https://github.com/0xKayala/Custom-Nuclei-Templates.git $TEMPLATES_DIR
fi
echo "[*] Custom Nuclei templates set up in $TEMPLATES_DIR."

# Cleanup
echo "[*] Cleaning up installation files..."
sudo apt autoremove -y
sudo apt autoclean -y

# Finish
echo "[*] Installation complete. Ensure the tools are in your PATH."
echo "[*] Restart your terminal or run 'source ~/.bashrc' to apply changes."
