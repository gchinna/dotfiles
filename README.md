# dotfiles

Personal shell and editor configuration files for customizing your Unix/Linux development environment. This repository allows you to maintain consistent settings across multiple machines and keep your configurations under version control.

## What's Included

- **Shell configurations**: bash, zsh, csh startup scripts
- **Aliases**: Custom command shortcuts and aliases
- **Vim configuration**: Editor settings and customizations
- **Git configuration**: Global gitignore patterns
- **Ctags**: Code navigation configuration

## Installation

### Quick Start

1. Clone the repository to your home directory:
   ```bash
   cd ~
   git clone <your-repo-url> dotfiles
   ```

2. Preview what will be installed (recommended):
   ```bash
   ./dotfiles/install.sh --dryrun
   ```

3. Install all configurations:
   ```bash
   ./dotfiles/install.sh
   ```

### Selective Installation

Install only specific configurations:

```bash
# Install everything except vim
./dotfiles/install.sh --novimrc

# Install only bash and vim
./dotfiles/install.sh --nozshrc --nocshrc --nogitignore --noctags

# Force overwrite existing files
./dotfiles/install.sh --force
```

### Available Options

Run `./dotfiles/install.sh --help` to see all options:

## How It Works

The installation script creates **symbolic links** from `~/dotfiles/` to your home directory (`~/`). This means:

- Your actual config files live in `~/dotfiles/` (version controlled)
- Files in `~/` (like `.bashrc`) are symlinks pointing to the dotfiles directory
- Any edits you make in `~/dotfiles/` are immediately active
- You can commit and push changes to keep configurations in sync across machines

## Workflow

### Making Changes

```bash
# Edit files in the dotfiles directory
vim ~/dotfiles/gchinna.bashrc

# Changes are immediately active (files are symlinked)
# Reload your shell to apply changes
source ~/.bashrc
```

### Syncing Across Machines

```bash
# On machine A: commit your changes
cd ~/dotfiles
git add .
git commit -m "Updated bash aliases"
git push

# On machine B: pull the latest changes
cd ~/dotfiles
git pull
# Changes are automatically active due to symlinks
```

## Customization

### Adding Work-Specific Configurations

The bashrc is set up to optionally source a `~/work.bashrc` file, allowing you to keep work-specific configurations separate from your personal dotfiles:

```bash
# Create a work-specific config (not tracked in this repo)
echo 'export WORK_VAR="value"' > ~/work.bashrc
```

### Key Files

- `gchinna.bashrc` - Main bash/zsh configuration (PATH, prompt, auto-reload)
- `gchinna.aliases` - Custom command aliases
- `gchinna.vimrc` - Vim editor settings
- `.bashrc`, `.zshrc`, `.cshrc` - Shell startup scripts that source the main configs
