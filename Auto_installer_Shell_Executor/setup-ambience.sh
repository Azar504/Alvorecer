#!/bin/zsh

echo "[*] Inicializando ambiente de desenvolvimento para malware em Lua..."

# === VARIÁVEIS GLOBAIS ===
GENERIC_ERROR="[GENERIC-ERROR] Um erro inesperado ocorreu. Se vira."
ENV_DIR="ambience"
LUA_FILE="file.lua"
GC_SOURCE_DIR="cpp"
GC_OUTPUT_DIR="bin"
GC_BINARY="gccompiled"
LOG_DIR="$ENV_DIR/logs"
DATE=$(date "+%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/setup_$DATE.log"

# === FUNÇÃO DE LOG ===
log_msg() {
    echo "$1" | tee -a "$LOG_FILE"
}

# === CRIA DIRETÓRIOS ===
log_msg "[*] Criando diretórios base..."

mkdir -p "$ENV_DIR/modules" "$ENV_DIR/payloads" "$LOG_DIR" "$GC_SOURCE_DIR" "$GC_OUTPUT_DIR" || {
    log_msg "[!] Falha ao criar diretórios. $GENERIC_ERROR"
    exit 1
}

# === CRIA ARQUIVO LUA VAZIO ===
log_msg "[*] Criando arquivo Lua base: $ENV_DIR/$LUA_FILE"
touch "$ENV_DIR/$LUA_FILE" || {
    log_msg "[!] Falha ao criar o arquivo Lua. $GENERIC_ERROR"
    exit 2
}

# === COMPILA MÓDULOS C++ EXISTENTES ===
log_msg "[*] Procurando arquivos C++ em '$GC_SOURCE_DIR/'..."

compiled_any=false

for file in "$GC_SOURCE_DIR"/*.cpp; do
    if [[ -f "$file" ]]; then
        filename=$(basename "$file" .cpp)
        output_path="$GC_OUTPUT_DIR/$filename"

        log_msg "[*] Compilando '$file' -> '$output_path'..."
        g++ "$file" -o "$output_path"
        if [[ $? -ne 0 ]]; then
            log_msg "[!] Falha na compilação de '$file'. Verifique o código."
        else
            chmod +x "$output_path"
            log_msg "[+] Compilação de '$file' concluída com sucesso."

            # Executa o binário recém-compilado
            log_msg "[*] Executando '$output_path'..."
            "$output_path" >> "$LOG_FILE" 2>&1
            compiled_any=true
        fi
    fi
done

if [[ "$compiled_any" == false ]]; then
    log_msg "[!] Nenhum arquivo C++ foi compilado. Você não colocou nada no diretório '$GC_SOURCE_DIR'."
fi

# === FINAL ===
log_msg "[+] Ambiente configurado com sucesso. Logs salvos em '$LOG_FILE'."
log_msg "[!] Agora cria seus scripts Lua, lixo. O mundo não vai se infectar sozinho."
