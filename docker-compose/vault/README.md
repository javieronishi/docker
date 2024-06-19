docker exec -it vault vault kv put secret/javier username=javi password=hola123


```bash
# Inicializar Vault
docker exec -it -e VAULT_ADDR="http://localhost:8200" vault vault operator init

# Desbloquear Vault
docker exec -it -e VAULT_ADDR="http://localhost:8200" vault vault operator unseal <key>

# Iniciar Sesión en Vault
docker exec -it -e VAULT_ADDR="http://localhost:8200" vault vault login <root_token>

# Habilitar el Motor de Almacenamiento de Claves KV
docker exec -it -e VAULT_ADDR="http://localhost:8200" vault vault secrets enable -path=secret kv

# Almacenar un Secreto
docker exec -it -e VAULT_ADDR="http://localhost:8200" vault vault kv put secret/javier username=javi password=hola123


