#!/bin/bash

echo "Alvorecer Framework LUA - Malware Maker"

# Variables
version="1.0"
datatemp=$(date)
echo "$datatemp"

int="Welcome to Shellrun - configuring the shell for Alvorecer"
end="Environment configured successfully!"
log="\nShellrun started at: $datatemp | version: $version\n"

# Commands
pwd
ls *.lua

# Logs
touch logshellrun-alvorecer.txt
echo -e "$log" >> logshellrun-alvorecer.txt
echo "======================================================================"
echo "$int"
echo "$end"
echo -e "$log"
echo "======================================================================"

# Permission Check
# ///////////////////////////////////////////////////////////////
if [ -f "main.lua" ]; then
    [ "$(stat -c %a main.lua)" -ne 777 ] && chmod 777 main.lua && echo "Permission 777 applied to main.lua."
else
    echo "main.lua not found."
fi
# ///////////////////////////////////////////////////////////////