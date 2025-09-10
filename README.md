# Dotfiles

## Automated Setup

This repository includes a `setup.sh` script to automate the setup of a new macOS development environment.

### What it does:

- Installs [Homebrew](https://brew.sh/) if it's not already present.
- Installs a list of essential command-line tools and applications (e.g., `git`, `neovim`, `zsh`).
- Configures Zsh as the default shell.

### How to run it:

1.  Make the script executable:
    ```bash
    chmod +x setup.sh
    ```

2.  Run the script:
    ```bash
    ./setup.sh
    ```

You will be prompted to select your system's architecture (Apple Silicon or Intel) and may be asked for your password for some commands.

## Managed with GNU Stow.

## Usage

1.  **Clone the repository:**
    ```bash
    git clone <your-repo-url> ~/dotfiles
    ```

2.  **Navigate to the directory:**
    ```bash
    cd ~/dotfiles
    ```

3.  **Create symlinks:**
    This command will symlink the contents of the `core` directory into your home directory (`~`).
    ```bash
    stow core
    ```

## Useful Flags

| Flag        | Description                                     |
| ----------- | ----------------------------------------------- |
| `-D`        | Delete symlinks (`--delete`)                    |
| `-R`        | Restow: remove then re-link (`--restow`)        |
| `-t <path>` | Target directory (default is `..`)              |
| `--adopt`   | Move existing files into stow-managed structure |
| `-v`        | Verbose mode (for debugging)                    |
