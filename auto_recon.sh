#!/bin/bash

# Display banner with Figlet
if ! command -v figlet &> /dev/null; then
    echo "[*] Installing figlet for banner display..."
    sudo apt update && sudo apt install -y figlet
fi

figlet "Eternal Recon"

# Prompt the user for a domain
echo -n "Enter the domain: "
read domain

# Ensure output directory exists
OUTPUT_DIR="recon_output"
mkdir -p $OUTPUT_DIR

# Step 2: Enumerate subdomains with Assetfinder
SUBDOMAINS_FILE="$OUTPUT_DIR/subdomains.txt"
echo "[*] Finding subdomains for $domain using Assetfinder..."
assetfinder $domain | sort -u > $SUBDOMAINS_FILE
echo "[*] Subdomains saved to $SUBDOMAINS_FILE"

# Step 3: Check live domains with Httpx
ALIVE_FILE="$OUTPUT_DIR/alive.txt"
echo "[*] Checking live domains with Httpx..."
httpx -silent -l $SUBDOMAINS_FILE -o $ALIVE_FILE
echo "[*] Live domains saved to $ALIVE_FILE"

# Step 4: Crawl alive links with Katana
KATANA_FILE="$OUTPUT_DIR/katana.txt"
echo "[*] Crawling alive links with Katana..."
katana -silent -list $ALIVE_FILE -o $KATANA_FILE
echo "[*] Crawled links saved to $KATANA_FILE"

# Step 5: Scan alive links with Nuclei
NUCLEI_TEMPLATES="/home/kali/Custom-Nuclei-Templates"
echo "[*] Scanning alive links with Nuclei using templates in $NUCLEI_TEMPLATES..."
nuclei -l $ALIVE_FILE -t $NUCLEI_TEMPLATES -o "$OUTPUT_DIR/nuclei_scan.txt"
echo "[*] Nuclei scan results saved to $OUTPUT_DIR/nuclei_scan.txt"

# Completion message
echo "[*] Reconnaissance completed. Check the output files in the $OUTPUT_DIR directory:"
echo "    - Subdomains: $SUBDOMAINS_FILE"
echo "    - Alive links: $ALIVE_FILE"
echo "    - Crawled links: $KATANA_FILE"
echo "    - Nuclei results: $OUTPUT_DIR/nuclei_scan.txt"
