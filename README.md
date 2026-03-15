# mkidir

`mkidir` creates a development environment with `devbox`, scaffolds a project if you want, and atomically moves it into place.

## Why use it

- Isolated project environments
- Atomic directory creation
- Built-in templates
- Git setup when `git` is included

## Install

`mkidir` depends on `devbox` and works best with `direnv`.

### 1. Install prerequisites

**macOS**

```bash
brew install jetify-com/devbox/devbox direnv
```

**Linux**

```bash
curl -fsSL https://get.jetify.com/devbox | bash
```

Install `direnv` with your package manager after that.

### 2. Enable `direnv`

If you use `zsh`:

```bash
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
source ~/.zshrc
```

If you use `bash`, replace `~/.zshrc` with `~/.bashrc`.

### 3. Install `mkidir`

```bash
git clone https://github.com/chirayuChhabra/mkidir.git
cd mkidir
bash scripts/build.sh
mkdir -p ~/.local/bin
cp mkidir ~/.local/bin/mkidir
chmod +x ~/.local/bin/mkidir
```

If `~/.local/bin` is not already in your `PATH`, add it:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

If you use `bash`, replace `~/.zshrc` with `~/.bashrc`.

### 4. Verify

```bash
mkidir --help
```

## Usage

```bash
mkidir <target_path> [packages...] [--template NAME] [--js|--ts] [--dry-run]
mkidir --list-templates
```

## Examples

Create a Node starter:

```bash
mkidir backend --template node
cd backend
```

Create an Express API in TypeScript:

```bash
mkidir api --template express
cd api
```

Create an Express API in JavaScript:

```bash
mkidir api --template express --js
cd api
```

Preview what would be created:

```bash
mkidir sandbox --template express --dry-run
```

See all built-in templates:

```bash
mkidir --list-templates
```

## Notes

- `express` uses TypeScript by default
- `--js` is currently supported only for the `express` template
- if `git` is part of the environment, `mkidir` initializes a repository and writes `.gitignore`

## For contributors

The repo is modular, but the installed CLI is still one file.

```bash
bash scripts/build.sh
```

That rebuilds the top-level `mkidir` command from `src/` and `templates/`.

## License

MIT
