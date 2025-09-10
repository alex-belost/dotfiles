#!/bin/bash

##
# @file setup.sh
# @description This script automates the setup of a development environment on macOS.
# It handles the installation of Homebrew, essential command-line tools, and
# GUI applications, and configures Zsh as the default shell. The script is
# designed to be idempotent, meaning it can be run multiple times without
# causing issues.
#
# @section Usage
# To run the script, execute it from your terminal:
#   ./setup.sh
#
# You will be prompted to select your Mac's architecture (Apple Silicon or Intel).
# The script may also ask for your password for 'sudo' commands (e.g., to change
# the default shell).
##

# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error when substituting.
set -u

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Function Definitions ---

##
# Prompts the user to select their chip architecture (Apple Silicon or Intel).
# It validates the input and will loop until a valid choice is made.
#
# @global chip_type - This variable is set to "Apple Silicon" or "Intel".
# @sideeffect Prints prompts and confirmation messages to standard output.
##
prompt_for_chip() {
  while true; do
    echo "Select your chip type:"
    echo "1) Apple Silicon (M1/M2/M3)"
    echo "2) Intel"
    read -p "Enter your choice (1 or 2): " choice
    case $choice in
    1)
      chip_type="Apple Silicon"
      echo -e "${GREEN}Selected chip type: ${YELLOW}${chip_type}${NC}"
      break
      ;;
    2)
      chip_type="Intel"
      echo -e "${GREEN}Selected chip type: ${YELLOW}${chip_type}${NC}"
      break
      ;;
    *)
      echo -e "${RED}Invalid choice. Please enter 1 or 2.${NC}"
      ;;
    esac
  done
}

##
# Checks if Homebrew is installed and installs it if missing.
# If Homebrew is already present, it runs 'brew update' to ensure it's up-to-date.
#
# @sideeffect Installs Homebrew by downloading and executing the official install script.
# @sideeffect Runs 'brew update' which fetches the newest version of Homebrew and all formulae.
# @sideeffect Prints status messages to standard output.
##
install_homebrew() {
  echo -e "${BLUE}Checking for Homebrew...${NC}"
  if ! command -v brew &>/dev/null; then
    echo -e "${YELLOW}Homebrew not found. Installing...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo -e "${GREEN}Homebrew is already installed. Updating...${NC}"
    brew update
  fi
}

##
# Installs a list of specified software packages using Homebrew.
# It handles both command-line tools (formulae) and GUI applications (casks).
# The function is idempotent; it checks if a package is already installed before
# attempting to install it.
#
# @local formulae - An array of Homebrew formulae to be installed.
# @local casks - An array of Homebrew casks to be installed.
# @sideeffect Installs multiple packages via 'brew install'.
# @sideeffect Adds a Homebrew tap if it's not already present.
# @sideeffect Prints status messages for each dependency.
##
install_dependencies() {
  echo -e "${BLUE}Checking and installing dependencies...${NC}"

  local formulae=(
    zsh
    git
    lazygit
    fd
    ripgrep
    fzf
    xplr
    eza
    zoxide
    htop
    neovim
    zellij
    yarn
    python
    nvm
    git-delta
    composer
    nginx
    gnu-sed
    git-flow
    stow
  )

  local casks=(
    "nikitabobko/tap/aerospace"
  )

  # Install formulae
  for formula in "${formulae[@]}"; do
    if brew list "$formula" &>/dev/null; then
      echo -e "${YELLOW}${formula} is already installed.${NC}"
    else
      echo -e "${GREEN}Installing ${formula}...${NC}"
      brew install "$formula"
    fi
  done

  # Tap and install casks
  # First, ensure the tap is present for aerospace
  if ! brew tap | grep -q "nikitabobko/tap"; then
    echo -e "${GREEN}Adding tap nikitabobko/tap...${NC}"
    brew tap "nikitabobko/tap"
  fi

  for cask_name in "${casks[@]}"; do
    # Extract the short name for checking if it's installed
    local short_name=$(basename "$cask_name")
    if brew list --cask "$short_name" &>/dev/null; then
      echo -e "${YELLOW}${short_name} is already installed.${NC}"
    else
      echo -e "${GREEN}Installing cask ${short_name}...${NC}"
      brew install --cask "$cask_name"
    fi
  done
}

##
# Sets the user's default shell to the version of Zsh installed by Homebrew.
# It identifies the correct Zsh path based on the system's architecture,
# adds this path to the system's list of valid shells, and then executes
# the shell change command.
#
# @global chip_type - Reads this variable to determine the correct Homebrew path.
# @sideeffect Modifies '/etc/shells' to add the Homebrew Zsh path. This requires sudo.
# @sideeffect Executes 'chsh -s' to change the user's default shell.
# @sideeffect Prints status and instructional messages.
##
configure_shell() {
  echo -e "${BLUE}Configuring Zsh as default shell...${NC}"

  local zsh_path
  # Determine the path to Homebrew-installed Zsh based on architecture
  if [[ "$chip_type" == "Apple Silicon" ]]; then
    zsh_path="/opt/homebrew/bin/zsh"
  else
    zsh_path="/usr/local/bin/zsh"
  fi

  # Add Homebrew Zsh to allowed shells if not already present
  if ! grep -Fxq "$zsh_path" /etc/shells; then
    echo -e "${YELLOW}Adding ${zsh_path} to /etc/shells. This may require your password.${NC}"
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi

  # Change shell if it's not already Homebrew Zsh
  if [[ "$SHELL" != "$zsh_path" ]]; then
    echo -e "${GREEN}Changing default shell to ${zsh_path}...${NC}"
    chsh -s "$zsh_path"
    echo -e "${GREEN}Shell change successful. Please restart your terminal for it to take effect.${NC}"
  else
    echo -e "${YELLOW}Default shell is already set to ${zsh_path}.${NC}"
  fi
}

##
# The main function of the script.
# It orchestrates the entire setup process by calling the other functions
# in the correct sequence.
#
# @flow
#   1. Prompts for chip type.
#   2. Installs/updates Homebrew.
#   3. Installs all dependencies.
#   4. Configures the default shell.
#   5. Prints a final success message.
##
main() {
  prompt_for_chip
  install_homebrew
  install_dependencies
  configure_shell

  echo -e "${GREEN}Setup complete! 🎉${NC}"
  echo -e "${YELLOW}Please restart your terminal for all changes to take effect.${NC}"
}

# Run the main function
main

