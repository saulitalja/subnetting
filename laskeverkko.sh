#!/bin/bash

read -p "Anna IP/CIDR (esim. 172.10.10.73/29): " ip

echo "Annoit osoitteen: $ip"

# Tarkista että ipcalc on asennettu
if ! command -v ipcalc &> /dev/null; then
    echo "ipcalc ei ole asennettu. Asenna se komennolla: sudo apt install ipcalc"
    exit 1
fi

# Näytä tiedot
ipcalc "$ip"
