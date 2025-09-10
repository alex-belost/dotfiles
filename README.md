# GNU Stow Dotfiles Setup

GNU Stow is a symlink manager, perfect for managing dotfiles across different systems.

---

## Installation

**Linux (Debian/Ubuntu):**

```bash
sudo apt install stow
```

**macOS (Homebrew):**

```bash
brew install stow
```

---

## Project Structure

Each folder inside `dotfiles/` should replicate the target filesystem structure:

```
~/dotfiles/
├── core/
│   └── .config/
├── nvim/
│   └── .config/
│       └── nvim/
│           └── init.lua
```

Example: `dotfiles/core/.config/...` → `~/.config/...`

---

## Usage

### 1. Navigate to your dotfiles directory:

```bash
cd ~/dotfiles
```

### 2. Create symlinks:

```bash
stow core
stow nvim
```

By default, symlinks are created in the parent directory (`..`, usually your `~` home directory).

---

## Remove symlinks

```bash
stow -D core
```

---

## Restow (remove and recreate)

```bash
stow -R core
```

---

## Specify a custom target directory

```bash
stow -t ~ bash
stow -t ~/.config nvim
```

Use `-t` to manually specify the destination path.

---

## Useful Flags

| Flag        | Description                                     |
| ----------- | ----------------------------------------------- |
| `-D`        | Delete symlinks (`--delete`)                    |
| `-R`        | Restow: remove then re-link (`--restow`)        |
| `-t <path>` | Target directory (default is `..`)              |
| `--adopt`   | Move existing files into stow-managed structure |
| `-v`        | Verbose mode (for debugging)                    |

---

## Example

```bash
git clone git@github.com:username/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow core
stow nvim
```

---

## Tips

- Always run `stow` from the root of the dotfiles repository.
- Folder structure must exactly match the desired target paths.
- If a file already exists, remove it first or use `--adopt`:

```bash
stow --adopt bash
```

