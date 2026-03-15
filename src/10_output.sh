show_usage() {
    cat <<'EOF'
Usage: mkidir <target_path> [packages...] [--template NAME] [--js|--ts] [--dry-run]
       mkidir --list-templates

Options:
  --template, -t     Apply a starter template before finalizing the environment
  --js               Use JavaScript when the template supports it
  --ts               Use TypeScript when the template supports it
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
  express    Express API starter with TypeScript by default and --js support
EOF
}

log_info() {
    printf '%s\n' "$*"
}

log_error() {
    printf 'Error: %s\n' "$*" >&2
}
