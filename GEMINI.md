# GEMINI.md: Dotfiles Project

## Directory Overview

This directory contains personal configuration files (dotfiles) for a macOS development environment. It uses `stow` to manage symlinks, `brew` for package installation, and includes configurations for `zsh`, `git`, `tmux`, `neovim`, and other command-line tools.

## Key Files

*   **`setup.sh`**: An interactive script that sets up the environment by installing dependencies using Homebrew and configuring the shell. It differentiates between Apple Silicon (M1) and Intel-based Macs.
*   **`core/.zshrc`**: The main configuration file for the Zsh shell. It sets up the prompt (Powerlevel10k), plugins (using `zinit`), aliases, and shell history.
*   **`core/.gitconfig`**: The global Git configuration. It defines the user's name, email, signing key, and sets up `delta` for diffing, `nvim` as the editor, and various aliases.
*   **`core/.tmux.conf`**: The configuration file for the `tmux` terminal multiplexer. It sets up keybindings, plugins (using `tpm`), and the Catppuccin theme.
*   **`core/.config/`**: This directory contains configuration files for various applications, including:
    *   **`aerospace/aerospace.toml`**: Configuration for the `aerospace` tiling window manager for macOS.
    *   **`alacritty/alacritty.toml`**: Configuration for the `alacritty` terminal emulator.
    *   **`lazygit/config.yml`**: Configuration for `lazygit`, a terminal UI for Git.

## Usage

To set up the dotfiles on a new machine:

1.  Clone the repository.
2.  Run the `setup.sh` script:

    ```bash
    ./setup.sh
    ```

3.  Follow the prompts to select your chip type (Apple Silicon or Intel).
4.  Use `stow` to create the necessary symlinks, as described in the `README.md`:

    ```bash
    stow core
    ```

## Project Conventions

### Git Commit Process

#### Message Format
- Extract the task key from the current branch name (e.g., `feature/MAIN-1234` → `MAIN-1234`). If the key cannot be found, ask the user for it.
- The commit message MUST begin with the task key.
- Do not use prefixes like 'feat:', 'refactor:', etc.
- List changes on new lines, starting with a dash (`-`).
- Use the past tense for change descriptions (e.g., 'Added a new feature' instead of 'Add a new feature').
- Example:

  ```
  MAIN-1111
  - Implemented the login form.
  - Added validation for the input fields.
  - Fixed the component styling.
  ```

#### Pre-Commit Checklist
1. Run `git status && git diff HEAD && git log -n 3` to gather full context of the changes and recent commit history.
2. Analyze the changes for any debug code, console logs, or obvious typos that should be removed before committing.
3. Propose a draft commit message to the user for approval.

#### Commit Types
*   `feat`: A new feature
*   `fix`: A bug fix
*   `docs`: Documentation only changes
*   `style`: Changes that do not affect the meaning of the code (white-space, formatting, missing semicolons, etc.)
    *   `refactor`: A code change that neither fixes a bug nor adds a feature
    *   `perf`: A code change that improves performance
    *   `test`: Adding missing tests or correcting existing tests
    *   `build`: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
    *   `ci`: Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
    *   `chore`: Other changes that don't modify src or test files
    *   `revert`: Reverts a previous commit

### Code Conventions & Best Practices
*   **Package Management**: Homebrew is used for installing and managing packages. The list of dependencies is in the `setup.sh` script.
*   **Shell**: Zsh is the default shell, with plugins managed by `zinit`.
*   **Editor**: Neovim is the primary text editor, with configurations for LazyVim, NvChad, and AstroNvim.
*   **Terminal**: Alacritty is the preferred terminal emulator, used with `tmux`.
*   **Window Management**: Aerospace is used as a tiling window manager.

### Documentation Generation
(Details about documentation generation will go here)
