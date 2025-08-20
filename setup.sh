#!/usr/bin/env bash
# Hyprland Minimal Setup Manager
# Author: NRN Nerd

set -e

info() { echo -e "\e[34m[INFO]\e[0m $1"; }
success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }
warn() { echo -e "\e[33m[WARN]\e[0m $1"; }
error() { echo -e "\e[31m[ERROR]\e[0m $1"; }

backup_dir="$HOME/.config-backup-$(date +%Y%m%d%H%M%S)"
config_repo="$(dirname "$0")/config"
declare -a packages=(hyprland waybar kitty wofi)

# --- Package Installation ---
install_packages() {
  info "Checking packages..."
  for pkg in "${packages[@]}"; do
    if pacman -Q "$pkg" &>/dev/null; then
      warn "$pkg is already installed."
    else
      read -p "Install $pkg? [Y/n]: " ans
      [[ -z "$ans" || "$ans" == [Yy] ]] && sudo pacman -S --needed --noconfirm "$pkg" \
        && success "Installed $pkg" || warn "Skipped $pkg"
    fi
  done
}

# --- Config Installation ---
install_configs() {
  mkdir -p "$backup_dir"
  for cfg in "${packages[@]}"; do
    if [ -d "$HOME/.config/$cfg" ]; then
      warn "$cfg config exists. Backing up..."
      mv "$HOME/.config/$cfg" "$backup_dir/" && success "Backup: $backup_dir/$cfg"
    fi
    if [ -d "$config_repo/$cfg" ]; then
      cp -r "$config_repo/$cfg" "$HOME/.config/$cfg"
      success "Installed config for $cfg"
    else
      warn "No config found for $cfg in repo."
    fi
  done
}

# --- Uninstallation ---
uninstall_setup() {
  read -p "Remove installed configs only? [Y/n]: " ans
  if [[ -z "$ans" || "$ans" == [Yy] ]]; then
    for cfg in "${packages[@]}"; do
      rm -rf "$HOME/.config/$cfg" && success "Removed config: $cfg"
    done
  else
    for pkg in "${packages[@]}"; do
      sudo pacman -Rns --noconfirm "$pkg" && success "Removed package: $pkg"
    done
  fi
}

# --- Restore Backup ---
restore_backup() {
  read -p "Enter backup directory path (default: $backup_dir): " user_backup
  user_backup=${user_backup:-$backup_dir}
  if [ -d "$user_backup" ]; then
    cp -r "$user_backup"/* "$HOME/.config/"
    success "Backup restored from $user_backup"
  else
    error "Backup directory not found!"
  fi
}

# --- Main Menu ---
while true; do
  clear
  echo "===== Hyprland Minimal Setup Manager ====="
  echo "1) Install Setup"
  echo "2) Uninstall Setup"
  echo "3) Restore Backup"
  echo "4) Exit"
  read -p "Choose an option [1-4]: " opt
  case $opt in
    1) install_packages; install_configs; read -p "Press Enter to continue..." ;;
    2) uninstall_setup; read -p "Press Enter to continue..." ;;
    3) restore_backup; read -p "Press Enter to continue..." ;;
    4) exit 0 ;;
    *) warn "Invalid option!" ;;
  esac
done
