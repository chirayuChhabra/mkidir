# mkidir

Atomic devbox environment bootstrapper.

`mkidir` creates a development environment in an isolated sandbox
on the destination filesystem and commits it atomically to the target path.

## Features

- Atomic environment creation
- Automatic devbox initialization
- Batch package installation
- Built-in project templates
- Express API template with TypeScript default and JavaScript flag
- Automatic git initialization if `git` package is detected
- Dry run mode
- Safe rollback on failure
- Modular source with single-file CLI output

## Installation

### Step 1: Install devbox

**On Linux/macOS:**
```bash
curl -fsSL https://get.jetify.com/devbox | bash
source ~/.bashrc  # or ~/.zshrc for zsh
```

### Step 2: Install direnv

**On Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install direnv
```

**On macOS:**
```bash
brew install direnv
```

**Hook direnv into your shell:**
```bash
# For bash
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
source ~/.bashrc

# For zsh
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
source ~/.zshrc
```

### Step 3: Install mkidir

```bash
# Clone the repository
git clone https://github.com/chirayuChhabra/mkidir.git
cd mkidir

# Create local bin directory
mkdir -p ~/.local/bin

# Build the standalone CLI
bash scripts/build.sh

# Copy mkidir to PATH
cp mkidir ~/.local/bin/mkidir

# Make it executable
chmod +x ~/.local/bin/mkidir

# Add ~/.local/bin to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# For zsh users, use ~/.zshrc instead:
# echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
# source ~/.zshrc
```

### Step 4: Verify Installation

```bash
mkidir --help
```

You should see the usage message.

## Usage

```bash
mkidir <target_path> [packages...] [--template NAME] [--js|--ts] [--dry-run]
mkidir --list-templates
```

### Examples

**Create a Node.js project with Git:**
```bash
mkidir backend nodejs@24 git
cd backend
```

**Create a Node.js starter from a template:**
```bash
mkidir backend --template node
cd backend
```

**Create a Python project:**
```bash
mkidir ml-project python@3.12 git
cd ml-project
```

**Create a Python starter from a template:**
```bash
mkidir ml-project --template python
cd ml-project
```

**Create a full-stack project:**
```bash
mkidir myapp nodejs@24 python@3.12 bun git
cd myapp
```

**Create a full-stack starter from a template:**
```bash
mkidir myapp --template fullstack
cd myapp
```

**Create an Express API with TypeScript:**
```bash
mkidir api --template express
cd api
```

**Create an Express API with JavaScript instead:**
```bash
mkidir api --template express --js
cd api
```

**Test what would be created (dry run):**
```bash
mkidir test-env --template node --dry-run
```

**List available templates:**
```bash
mkidir --list-templates
```

## How It Works

1. **Isolated Sandbox**: Creates the sandbox as a hidden sibling of the target so the final rename stays on the same filesystem
2. **Direnv Generation**: Creates `.envrc` file for automatic environment activation
3. **Package Installation**: Installs specified packages via devbox
4. **Template Scaffolding**: Optionally writes starter files from the built-in template assets
5. **Git Setup**: If `git` is in package list, runs `git init` and updates `.gitignore`
6. **Atomic Commit**: Renames the completed sandbox into place (rolls back on failure)

When you `cd` into the created directory, direnv automatically activates the devbox environment with all specified packages available.

## Why mkidir?

**Problem**: You ask an AI to scaffold a project, and 15 minutes later realize you're in the wrong environment—npm/python commands fail or pollute your global system.

**Solution**: Run `mkidir` first to create an isolated environment with all dependencies, then let AI work inside it.

### Benefits

- **No Global Conflicts**: Node 24 in one project, Node 18 in another—no interference
- **Atomic Creation**: The final rename happens on the destination filesystem, so you do not get a half-written target directory
- **AI-Friendly**: Create the environment once, then AI can safely run npm/pip/etc commands
- **Instant Activation**: With direnv, just `cd` into the project and everything works

## Development

The repository is split by concern:

- `src/`: shell modules for CLI, parsing, workflow, and template orchestration
- `templates/`: scaffold assets for each template
- `scripts/build.sh`: generates the standalone `mkidir` file

Run this after changing `src/` or `templates/`:

```bash
bash scripts/build.sh
```

## License

MIT
