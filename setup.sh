#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Prompt user for chip type selection
echo "Select your chip type:"
echo "1) M1 (Apple Silicon)"
echo "2) Intel"
echo "Enter your choice (1 or 2): "
read choice

# Process selection
case $choice in
1)
	chip_type="M1"
	echo "${GREEN}Selected chip type: ${YELLOW}Apple Silicon (M1)${NC}"
	;;
2)
	chip_type="Intel"
	echo "${GREEN}Selected chip type: ${YELLOW}Intel${NC}"
	;;
*)
	echo "${RED}Invalid choice. Exiting...${NC}"
	exit 1
	;;
esac

# List of dependencies to install through Homebrew
dependencies=(
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
  --cask nikitabobko/tap/aerospace
	gnu-sed
	git-flow
  stow
)

# Ensure Homebrew is installed
which -s brew
if [[ $? != 0 ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	brew update
fi

# Function to install a dependency using Homebrew if it's not already installed
install_dependency() {
	if brew list $1 &>/dev/null; then
		echo "${YELLOW}$1 is already installed.${NC}"
	else
		echo "${GREEN}Installing $1...${NC}"
		brew install $1
	fi
}

# Iterate over the dependencies and install them if necessary
for dep in "${dependencies[@]}"; do
	install_dependency $dep
done

# Install tpm for tmux
if [ ! -d "$HOME/.tmux" ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "${GREEN}All specified dependencies have been checked and installed if necessary.{NC}"

# Assuming the chip_type variable is set based on earlier user input
if [[ "$chip_type" == "M1" ]]; then
	# Add any M1-specific commands here
	chsh -s $(which zsh)

	echo "${GREEN}Configuration complete for M1.${NC}"
else
	# Add any Intel-specific commands here
	if [[ "$SHEL" != "bin/zsh" ]]; then
		chsh -s /usr/local/bin/zsh
	fi

	echo "${GREEN}Configuration complete for Intel.${NC}"
fi
