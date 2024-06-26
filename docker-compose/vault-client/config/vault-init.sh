#!/usr/bin/env sh

# set -ex

unseal () {
vault operator unseal $(grep 'Key 1:' /vault/_key-token/keys | awk '{print $NF}') >> /vault/file/status
vault operator unseal $(grep 'Key 2:' /vault/_key-token/keys | awk '{print $NF}') >> /vault/file/status
vault operator unseal $(grep 'Key 3:' /vault/_key-token/keys | awk '{print $NF}') >> /vault/file/status
}

init () {
vault operator init > /vault/_key-token/keys
}

log_in () {
   vault login $ROOT_TOKEN
}

log_logout () {
   vault logout
}

create_token () {
   vault token create -id $MY_VAULT_TOKEN
}

if [ -s /vault/_key-token/keys ]; then
   unseal
   log_in
else
   init
   unseal
   log_in
   log_logout
fi

vault status >> /vault/file/status
