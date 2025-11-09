# Troubleshooting plan — web service

## Quick verification

```bash
sudo systemctl status nginx.service

sudo systemctl restart nginx.service
```

What to look for:

- Active: line (active/failed/activating)
- Loaded: shows unit file path and drop-in files
- If unit not found → maybe wrong unit name or service not installed


## Read the logs (journalctl)

```bash
sudo journalctl -u nginx.service -b --no-pager

sudo journalctl -u nginx.service -f
```

What to look for:

- Stack traces, permission denied, file not found, port already in use, invalid config, failed to bind, etc.
- Timestamps to correlate start attempts
- ExecStart failures, exit-code, signal

## Validate configuration files & permissions

Common failures: syntax errors, missing files, wrong permissions, wrong owner.

```bash
ls -l /etc/nginx/conf.d

cat /etc/nginx/conf.d/nginx.conf
```

# Linux Server Security Hardening

This document outlines two essential security hardening measures implemented on a Linux server:

1. SSH Hardening (secure remote access)
2. Firewall Configuration (restrict network exposure)

## SSH Hardening 

Step 1: Create a Non-Root User in Remote server

```bash
sudo adduser devops
sudo usermod -aG sudo devops
```

Step 2: Configure SSH Key-Based Authentication

- On local system, generate an SSH key

```bash
ssh-keygen -t rsa -b 2048 -C "devops@server"
```

- Copy the public key to the server:

```bash
sudo echo "public-key" >> /home/devops/.ssh/authorized_keys
```

Step 3: Edit SSH Configuration File

```bash
sudo vim /etc/ssh/sshd_config
<<<
# Disable root login via SSH
PermitRootLogin no

# Disable password-based authentication
PasswordAuthentication no

# Allow only public key authentication
PubkeyAuthentication yes
>>>

sudo systemctl restart sshd
sudo systemctl status sshd
```

## Firewall Configuration

Step 1: Install UFW

```bash
sudo apt update
sudo apt install ufw -y
sudo ufw enable
```

Step 2: Allow Required Ports

```bash
sudo ufw allow 80/tcp comment 'Allow HTTP traffic'
sudo ufw allow 443/tcp comment 'Allow HTTPS traffic'

sudo ufw allow from <TRUSTED_IP> to any port 22 proto tcp

sudo ufw status verbose
```