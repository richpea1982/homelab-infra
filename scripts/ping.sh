# 1. Checkout is automatic in Semaphore run tasks, but keep explicit for clarity
checkout

# 2. Prepare SSH key from secret and permissions
mkdir -p ~/.ssh
echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# 3. Prevent host key verification prompts (safe for homelab)
# Replace hostnames with the ones in your inventory if different
ssh-keyscan -H proxmox-srv docker-srv 2>/dev/null >> ~/.ssh/known_hosts || true

# 4. Optional: export vault password if you use ansible-vault
# Uncomment if you stored VAULT_PASSWORD as a secret
# export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass
# echo "$VAULT_PASSWORD" > ~/.vault_pass
# chmod 600 ~/.vault_pass

# 5. Run ansible-playbook using inventories from the repo
# Use -i multiple times or point to an inventory directory as needed
ansible-playbook \
  -i ansible/inventories/production \
  -i ansible/inventories/lab \
  ansible/playbooks/ping.yml
