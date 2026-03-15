prepare_target_parent() {
    if [[ ! -d "$TARGET_PARENT" ]]; then
        mkdir -p "$TARGET_PARENT"
        PARENT_CREATED=1
    fi

    TARGET_PARENT="$(cd "$TARGET_PARENT" && pwd)"
    TARGET_DIR="$TARGET_PARENT/$TARGET_NAME"
}

create_sandbox() {
    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "Dry run: would create isolated sandbox next to $TARGET_DIR"
        return
    fi

    prepare_target_parent

    log_info "Creating environment: $TARGET_DIR"
    log_info "Packages: ${PACKAGES[*]:-(none)}"
    if [[ -n "$TEMPLATE" ]]; then
        log_info "Template: $(template_variant_name)"
    fi
    log_info "Building in isolated sandbox on destination filesystem..."

    TMP_DIR="$(mktemp -d "$TARGET_PARENT/.mkidir.${TARGET_NAME}.XXXXXX")"
    cd "$TMP_DIR" || exit 1

    run_step "devbox init" devbox init

    log_info "Generating direnv..."
    run_step "devbox generate direnv" devbox generate direnv
}

install_packages() {
    if [[ ${#PACKAGES[@]} -eq 0 ]]; then
        return
    fi

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "Dry run: would batch install: ${PACKAGES[*]}"
        return
    fi

    log_info "Installing packages..."
    run_step "devbox add" devbox add "${PACKAGES[@]}"
}

setup_git() {
    if [[ $HAS_GIT -eq 0 ]]; then
        return
    fi

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "Dry run: would initialize git and update .gitignore"
        return
    fi

    log_info "Initializing git..."
    run_step "devbox run -- git init" devbox run -- git init
    append_gitignore_entries ".devbox/" ".direnv/"
}

commit_environment() {
    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "Dry run: would atomically rename sandbox to $TARGET_DIR"
        exit 0
    fi

    cd "$ORIGINAL_DIR" || exit 1

    if [[ -e "$TARGET_DIR" ]]; then
        log_error "target '$TARGET_DIR' already exists"
        exit 1
    fi

    mv "$TMP_DIR" "$TARGET_DIR"

    if command -v direnv >/dev/null 2>&1; then
        if direnv allow "$TARGET_DIR" >/dev/null 2>&1; then
            log_info "Auto-approved direnv environment."
        else
            log_error "direnv auto-allow failed for $TARGET_DIR"
        fi
    fi

    SUCCESS=1
    printf '\n'
    log_info "Done. Environment materialized at: $TARGET_DIR"
}

main() {
    parse_args "$@"

    if [[ $DRY_RUN -eq 0 ]]; then
        require_cmd devbox
        require_cmd mktemp
        require_cmd mv
    fi

    create_sandbox
    install_packages
    apply_template
    setup_git
    commit_environment
}
