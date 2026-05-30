show_usage() {
    cat <<'EOF'
Usage: mkidir <target_path> [packages...] [--template NAME] [--npm|--pnpm|--bun] [--prisma] [--init] [--dry-run]
       mkidir --list-templates

Options:
  --template, -t     Apply a starter template before finalizing the environment
  --npm, --pnpm, --bun  Choose package manager (default depends on template)
  --prisma           Include Prisma configuration for express template
  --init             Forces mkidir environment without template
  --dry-run          Print what would be created without touching the filesystem
  --list-templates   Show available built-in templates
  --help, -h         Show this help message
EOF
}

list_templates() {
    cat <<'EOF'
Available templates:
  node       Node.js app starter with package.json, README, and src/index.js
  python     Python app starter with pyproject.toml, README, and src/main.py
  fullstack  Polyglot starter with apps/web and apps/api skeletons
  express    Express API starter with TypeScript
EOF
}

log_info() {
    printf '%s\n' "$*"
}

log_error() {
    printf 'Error: %s\n' "$*" >&2
}
