#!/bin/zsh

echo "[*] Starting Lua malware development environment..."

# === GLOBAL VARIABLES ===
GENERIC_ERROR="[GENERIC-ERROR] An unexpected error happened. Figure it out."
ENV_DIR="ambience"
LUA_FILE="file.lua"
GC_SOURCE_DIR="cpp"
GC_OUTPUT_DIR="bin"
GC_BINARY="gccompiled"
LOG_DIR="$ENV_DIR/logs"
DATE=$(date "+%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/setup_$DATE.log"

# === LOG FUNCTION ===
log_msg() {
    echo "$1" | tee -a "$LOG_FILE"
}

# === CREATE DIRECTORIES ===
log_msg "[*] Creating base folders..."

mkdir -p "$ENV_DIR/modules" "$ENV_DIR/payloads" "$LOG_DIR" "$GC_SOURCE_DIR" "$GC_OUTPUT_DIR" || {
    log_msg "[!] Failed to create folders. $GENERIC_ERROR"
    exit 1
}

# === CREATE EMPTY LUA FILE ===
log_msg "[*] Creating base Lua file: $ENV_DIR/$LUA_FILE"
touch "$ENV_DIR/$LUA_FILE" || {
    log_msg "[!] Failed to create Lua file. $GENERIC_ERROR"
    exit 2
}

# === COMPILE EXISTING C++ MODULES ===
log_msg "[*] Looking for C++ files in '$GC_SOURCE_DIR/'..."

compiled_any=false

for file in "$GC_SOURCE_DIR"/*.cpp; do
    if [[ -f "$file" ]]; then
        filename=$(basename "$file" .cpp)
        output_path="$GC_OUTPUT_DIR/$filename"

        log_msg "[*] Compiling '$file' -> '$output_path'..."
        g++ "$file" -o "$output_path"
        if [[ $? -ne 0 ]]; then
            log_msg "[!] Compilation failed for '$file'. Check the code."
        else
            chmod +x "$output_path"
            log_msg "[+] '$file' compiled successfully."

            # Run the compiled binary
            log_msg "[*] Running '$output_path'..."
            "$output_path" >> "$LOG_FILE" 2>&1
            compiled_any=true
        fi
    fi
done

if [[ "$compiled_any" == false ]]; then
    log_msg "[!] No C++ files were compiled. You put nothing in '$GC_SOURCE_DIR'."
fi

# === END ===
log_msg "[+] Environment setup done. Logs saved in '$LOG_FILE'."
log_msg "[!] Now make your Lua scripts, trash. The world won’t infect itself."