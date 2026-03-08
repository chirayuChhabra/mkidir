# mkidir

Atomic devbox environment bootstrapper.

`mkidir` creates a development environment in an isolated sandbox
and commits it atomically to the filesystem.

## Features

- Atomic environment creation
- Automatic devbox initialization
- Batch package installation
- Automatic git initialization if `git` package is detected
- Dry run mode
- Safe rollback on failure

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
mkidir <target_path> [packages...] [--dry-run]
```

### Examples

**Create a Node.js project with Git:**
```bash
mkidir backend nodejs@24 git
cd backend
```

**Create a Python project:**
```bash
mkidir ml-project python@3.12 git
cd ml-project
```

**Create a full-stack project:**
```bash
mkidir myapp nodejs@24 python@3.12 bun git
cd myapp
```

**Test what would be created (dry run):**
```bash
mkidir test-env nodejs@20 --dry-run
```

## How It Works

1. **Isolated Sandbox**: Creates environment in a temporary directory using `mktemp`
2. **Package Installation**: Installs specified packages via devbox
3. **Direnv Generation**: Creates `.envrc` file for automatic environment activation
4. **Git Setup**: If `git` is in package list, runs `git init` and creates `.gitignore`
5. **Atomic Commit**: Moves completed environment to target path (rolls back on failure)

When you `cd` into the created directory, direnv automatically activates the devbox environment with all specified packages available.

## Why mkidir?

**Problem**: You ask an AI to scaffold a project, and 15 minutes later realize you're in the wrong environment—npm/python commands fail or pollute your global system.

**Solution**: Run `mkidir` first to create an isolated environment with all dependencies, then let AI work inside it.

### Benefits

- **No Global Conflicts**: Node 24 in one project, Node 18 in another—no interference
- **Atomic Creation**: If setup fails, your filesystem stays clean (no half-created directories)
- **AI-Friendly**: Create the environment once, then AI can safely run npm/pip/etc commands
- **Instant Activation**: With direnv, just `cd` into the project and everything works

## License

MIT
