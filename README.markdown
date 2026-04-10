# NixOS and Home Manager Configuration Backup Cheat Sheet

This repository (`nixos-configs`) stores my NixOS and Home Manager configurations for reproducible system setups. Both NixOS system configs and Home Manager user configs are stored in `/etc/nixos` (in `configuration.nix` and `home-manager/` respectively) and backed up to a single Git repository in `~/nix-configs`. Home Manager updates automatically with `nixos-rebuild switch`. Below are instructions for setting up on a new computer, updating the repository, and retrieving files.

## Prerequisites
- **NixOS**: A working NixOS installation.
- **Git**: Installed via `environment.systemPackages` in `/etc/nixos/configuration.nix`.
- **GitHub Account**: Access to this repository (`git@github.com:<username>/nixos-configs.git`).
- **SSH Key**: For secure GitHub access (recommended).
- **Home Manager**: Integrated into NixOS via `home-manager.users.stary` in `/etc/nixos/configuration.nix`.

## 1. Initial Setup on a New Computer
To set up your NixOS and Home Manager configs from this repository on a new computer:

### Step 1: Install Git
Ensure Git is available in `/etc/nixos/configuration.nix`:
```nix
environment.systemPackages = with pkgs; [ git ];
```
Apply: `sudo nixos-rebuild switch`

### Step 2: Set Up SSH for GitHub
Generate and add an SSH key (skip if already set up):
```bash
ssh-keygen -t ed25519 -C "your.email@example.com" -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub  # Copy this output
```
- Add the public key to GitHub: Settings → SSH and GPG keys → New SSH key.
- Test: `ssh -T git@github.com` (should say "Hi <username>!").

### Step 3: Clone the Repository
Clone to your home directory:
```bash
cd ~
git clone git@github.com:<username>/nixos-configs.git
cd nix-configs
```

### Step 4: Copy Configs to /etc/nixos
Copy the configs to `/etc/nixos` (requires root):
```bash
sudo mv /etc/nixos /etc/nixos.bak  # Backup existing configs
sudo cp -r nixos /etc/nixos
```

### Step 5: Configure Home Manager in NixOS
Ensure `/etc/nixos/configuration.nix` includes Home Manager:
```nix
{ config, pkgs, ... }:
{
  imports = [
    ./home-manager/stary.nix  # Path to your Home Manager config
    <home-manager/nixos>
  ];
  environment.systemPackages = with pkgs; [ git ];
  users.users.stary = {
    isNormalUser = true;
    home = "/home/stary";
    description = "Your Name";
  };
  home-manager.users.stary = import ./home-manager/stary.nix;
}
```
- Ensure `home-manager/stary.nix` exists in `/etc/nixos/home-manager/` (copied from the repo).
- Example `stary.nix`:
```nix
{ pkgs, ... }:
{
  home.username = "stary";
  home.homeDirectory = "/home/stary";
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
```

### Step 6: Apply Configuration
Rebuild the system to apply both NixOS and Home Manager configs:
```bash
sudo nixos-rebuild switch
```

### Step 7: Verify
- Check Git config: `git config --list --show-origin`.
- Verify NixOS: `nixos-version`.
- Verify Home Manager: `home-manager generations`.

## 2. Updating the Repository
To back up changes to your configs:

### Step 1: Copy Updated Configs
Copy changes from `/etc/nixos` to `~/nix-configs`:
```bash
cd ~/nix-configs
sudo cp -r /etc/nixos/* nixos/
```

### Step 2: Stage and Commit Changes
```bash
git add .
git commit -m "Update Nix configs $(date '+%Y-%m-%d %H:%M:%S')"
```

### Step 3: Push to GitHub
```bash
git push origin main
```

### Optional: Automate Updates
Create a backup script in `~/backup-nix-configs.sh`:
```bash
#!/bin/sh
cd ~/nix-configs
sudo cp -r /etc/nixos/* nixos/
git add .
git commit -m "Backup Nix configs $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main
```
Make executable: `chmod +x ~/backup-nix-configs.sh`
Add to Home Manager in `/etc/nixos/home-manager/stary.nix`:
```nix
home.packages = [ (pkgs.writeShellScriptBin "backup-nix-configs" ./backup-nix-configs.sh) ];
```
Apply: `sudo nixos-rebuild switch`

## 3. Retrieving Files
To restore or access configs from the repository:

### Step 1: Clone or Pull
If not already cloned:
```bash
cd ~
git clone git@github.com:<username>/nixos-configs.git
```
If already cloned, update:
```bash
cd ~/nix-configs
git pull origin main
```

### Step 2: Apply Configs
Copy configs to `/etc/nixos`:
```bash
sudo mv /etc/nixos /etc/nixos.bak  # Backup existing configs
sudo cp -r nixos /etc/nixos
```
Rebuild: `sudo nixos-rebuild switch`

## Troubleshooting
- **Permission Issues**: Ensure ownership of `/home/stary` (`sudo chown -R stary:users /home/stary`). Use `sudo` for `/etc/nixos` operations.
- **Home Manager Fails**: Check for conflicting packages: `nix-env -q`. Remove: `nix-env -e '.*'`. Check logs: `journalctl -u home-manager-stary`.
- **Git Push Fails**: Verify SSH (`ssh -T git@github.com`) and remote (`git remote -v`).
- **Sensitive Data**: Use `sops-nix` or `agenix` for secrets, or keep this repo private.

## Notes
- **Copy Approach**: Configs are copied to avoid permission issues with `/etc/nixos`. Ensure `sudo cp` is used when updating.
- **Home Manager Integration**: Configs in `/etc/nixos/home-manager/` update automatically with `nixos-rebuild switch`.
- **Security**: Exclude sensitive data in `.gitignore` (e.g., secrets, backups) or encrypt with `sops-nix`.
- **Regular Backups**: Run the backup script or manual `cp/git add/commit/push` after config changes.