require_cmd() {
    command -v "$1" >/dev/null 2>&1 || {
        log_error "required command not found: $1"
        exit 1
    }
}

run_step() {
    local label="$1"
    shift

    local log_file
    log_file="$(mktemp)"

    if ! "$@" >"$log_file" 2>&1; then
        log_error "${label} failed."
        sed 's/^/   /' "$log_file" >&2
        rm -f "$log_file"
        exit 1
    fi

    rm -f "$log_file"
}

package_base() {
    printf '%s\n' "${1%%@*}"
}

package_exists() {
    local wanted_base
    local package

    wanted_base="$(package_base "$1")"
    for package in "${PACKAGES[@]}"; do
        if [[ "$(package_base "$package")" == "$wanted_base" ]]; then
            return 0
        fi
    done

    return 1
}

add_package() {
    local package="$1"

    if package_exists "$package"; then
        return
    fi

    PACKAGES+=("$package")
    if [[ "$(package_base "$package")" == "git" ]]; then
        HAS_GIT=1
    fi
}

append_gitignore_entries() {
    local entry

    touch .gitignore
    for entry in "$@"; do
        if ! grep -Fqx "$entry" .gitignore 2>/dev/null; then
            printf '%s\n' "$entry" >>.gitignore
        fi
    done
}

slugify_name() {
    local raw="$1"
    local slug

    slug="$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]' | tr -cs '[:alnum:]' '-')"
    slug="${slug#-}"
    slug="${slug%-}"

    if [[ -z "$slug" ]]; then
        slug="app"
    fi

    printf '%s\n' "$slug"
}

write_asset_file() {
    local asset_key="$1"
    local destination="$2"
    local content

    content="$(render_asset "$asset_key")"
    content="${content//__PROJECT_TITLE__/$PROJECT_TITLE}"
    content="${content//__PROJECT_SLUG__/$PROJECT_SLUG}"
    mkdir -p "$(dirname "$destination")"
    printf '%s\n' "$content" >"$destination"
}

cleanup() {
    if [[ $SUCCESS -eq 0 && -n "$TMP_DIR" && -d "$TMP_DIR" && "$TMP_DIR" != "/" && "$TMP_DIR" != "$ORIGINAL_DIR" ]]; then
        printf '\n'
        log_info "Setup aborted. Purging isolated sandbox..."
        rm -rf "$TMP_DIR"
    fi

    if [[ $SUCCESS -eq 0 && $PARENT_CREATED -eq 1 && -n "$TARGET_PARENT" && -d "$TARGET_PARENT" ]]; then
        rmdir "$TARGET_PARENT" 2>/dev/null || true
    fi
}

trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
