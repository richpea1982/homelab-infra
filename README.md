# Homelab Infrastructure

Infrastructure-as-code for my homelab.  
This repository contains everything required to deploy, configure, and maintain my environment using Ansible, Docker, Traefik, Cloudflare Tunnel, and Proxmox.

## Objectives
- Automate all infrastructure tasks.
- Maintain reproducible server builds.
- Use Docker for edge services (Traefik, Cloudflare Tunnel).
- Use Proxmox for internal services and virtualization.
- Prepare for future VLAN segmentation and OPNsense firewall.

## Structure
- ansible/ : Playbooks, roles, inventories.
- docker/ : Compose stacks, Traefik, Cloudflare Tunnel.
- network/ : VLAN plan, IP schema, diagrams.
- proxmox/ : Templates and automation.

## Status
Initial setup in progress.
