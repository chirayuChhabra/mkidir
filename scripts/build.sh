#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_FILE="$ROOT_DIR/mkidir"

{
    cat "$ROOT_DIR/src/00_header.sh"
    printf '\n'
    cat "$ROOT_DIR/src/10_output.sh"
    printf '\n'
    cat "$ROOT_DIR/src/20_helpers.sh"
    printf '\n'
    printf 'render_asset() {\n'
    printf '    case "$1" in\n'

    while IFS= read -r asset_file; do
        asset_key="${asset_file#"$ROOT_DIR/templates/"}"
        printf "        '%s')\n" "$asset_key"
        printf "            cat <<'MKIDIR_ASSET_EOF'\n"
        cat "$asset_file"
        printf '\nMKIDIR_ASSET_EOF\n'
        printf '            ;;\n'
    done < <(find "$ROOT_DIR/templates" -type f | sort)

    cat <<'EOF'
        *)
            log_error "unknown asset: $1"
            exit 1
            ;;
    esac
}

EOF
    cat "$ROOT_DIR/src/30_templates.sh"
    printf '\n'
    cat "$ROOT_DIR/src/40_args.sh"
    printf '\n'
    cat "$ROOT_DIR/src/50_workflow.sh"
    printf '\n'
    cat "$ROOT_DIR/src/60_main.sh"
    printf '\n'
} >"$OUTPUT_FILE"

chmod +x "$OUTPUT_FILE"
