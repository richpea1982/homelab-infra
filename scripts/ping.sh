#!/usr/bin/env bash
set -euo pipefail

# --- Repo is already checked out by Semaphore Run tasks ---

# 1) Variables to adjust if you use different names
SSH_KEY_FILENAME="${SSH_KEY_FILENAME:-~/.ssh/id_docker-srv}"   # set this in Semaphore env if you want
INVENTORY="ansible/inventories/production/hosts.yml"          # exact repo path to hosts file
PLAYBOOK="ansible/playbooks/ping.yml"

# 2) Prepare SSH key (secret name: SSH_PRIVATE_KEY)
mkdir -p ~/.ssh
echo "$SSH_PRIVATE_KEY" > "$SSH_KEY_FILENAME"
chmod 600 "$SSH_KEY_FILENAME"

# 3) Known hosts to avoid interactive prompt (adjust hostnames/IPs)
ssh-keyscan -H proxmox-srv docker-srv 2>/dev/null >> ~/.ssh/known_hosts || true

# 4) Vault handling (secret name: VAULT_PASSWORD). If you don't use vault, leave VAULT_PASSWORD unset.
VAULT_ARG=""
if [ -n "${VAULT_PASSWORD:-}" ]; then
  echo "$VAULT_PASSWORD" > ~/.vault_pass
  chmod 600 ~/.vault_pass
  VAULT_ARG="--vault-password-file ~/.vault_pass"
fi

# 5) Run ansible-playbook using the specified key explicitly
ANSIBLE_SSH_EXTRA_ARGS="-o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=~/.ssh/known_hosts -i $SSH_KEY_FILENAME"
ANSIBLE_CMD="ansible-playbook -i \"$INVENTORY\" $PLAYBOOK $VAULT_ARG --ssh-extra-args \"$ANSIBLE_SSH_EXTRA_ARGS\""

# Execute
eval $ANSIBLE_CMD
