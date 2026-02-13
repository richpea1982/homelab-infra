#!/usr/bin/env bash
set -euo pipefail

# --- repo is already checked out by Semaphore Run tasks ---

# Ensure ~/.ssh exists and write the private key from the secret
mkdir -p ~/.ssh
echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Add target hosts to known_hosts to avoid interactive prompt (adjust hostnames/IPs)
ssh-keyscan -H proxmox-srv docker-srv 2>/dev/null >> ~/.ssh/known_hosts || true

# If you use Ansible Vault, write the vault password from secret and point Ansible to it
# (attach VAULT_PASSWORD as a secret in Semaphore and name it VAULT_PASSWORD)
if [ -n "${VAULT_PASSWORD:-}" ]; then
  echo "$VAULT_PASSWORD" > ~/.vault_pass
  chmod 600 ~/.vault_pass
  VAULT_ARG="--vault-password-file ~/.vault_pass"
else
  VAULT_ARG=""
fi

# Choose inventory: file or directory. Use exact file path if you have hosts.yml
INVENTORY="ansible/inventories/production/hosts.yml"

# Run ansible-playbook (adjust playbook path if needed)
ansible-playbook -i "$INVENTORY" ansible/playbooks/ping.yml $VAULT_ARG
