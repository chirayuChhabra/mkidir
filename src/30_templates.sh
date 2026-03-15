template_variant_name() {
    case "$TEMPLATE" in
        express)
            if [[ "$TEMPLATE_LANGUAGE" == "js" ]]; then
                printf 'express (javascript)\n'
            else
                printf 'express (typescript)\n'
            fi
            ;;
        *)
            printf '%s\n' "$TEMPLATE"
            ;;
    esac
}

validate_template() {
    case "$TEMPLATE" in
        ""|node|python|fullstack|express)
            ;;
        *)
            log_error "unknown template: $TEMPLATE"
            log_info "Run 'mkidir --list-templates' to see the available options."
            exit 1
            ;;
    esac

    if [[ "$TEMPLATE" == "express" ]]; then
        if [[ -z "$TEMPLATE_LANGUAGE" ]]; then
            TEMPLATE_LANGUAGE="ts"
        fi
        return
    fi

    if [[ -n "$TEMPLATE_LANGUAGE" ]]; then
        log_error "--js/--ts is only supported with the express template"
        exit 1
    fi
}

merge_template_packages() {
    case "$TEMPLATE" in
        node)
            add_package "nodejs@24"
            add_package "git"
            ;;
        python)
            add_package "python@3.12"
            add_package "git"
            ;;
        fullstack)
            add_package "nodejs@24"
            add_package "python@3.12"
            add_package "git"
            ;;
        express)
            add_package "nodejs@24"
            add_package "git"
            ;;
    esac
}

print_template_plan() {
    case "$TEMPLATE" in
        node)
            echo "   - README.md"
            echo "   - package.json"
            echo "   - src/index.js"
            ;;
        python)
            echo "   - README.md"
            echo "   - pyproject.toml"
            echo "   - src/main.py"
            ;;
        fullstack)
            echo "   - README.md"
            echo "   - apps/web/package.json"
            echo "   - apps/web/src/index.js"
            echo "   - apps/api/main.py"
            ;;
        express)
            if [[ "$TEMPLATE_LANGUAGE" == "js" ]]; then
                echo "   - README.md"
                echo "   - package.json"
                echo "   - .env.example"
                echo "   - src/app.js"
                echo "   - src/server.js"
                echo "   - src/config/"
                echo "   - src/modules/health/"
                echo "   - src/routes/index.js"
            else
                echo "   - README.md"
                echo "   - package.json"
                echo "   - tsconfig.json"
                echo "   - .env.example"
                echo "   - src/app.ts"
                echo "   - src/server.ts"
                echo "   - src/config/"
                echo "   - src/modules/health/"
                echo "   - src/routes/index.ts"
            fi
            ;;
    esac
}

apply_node_template() {
    write_asset_file "node/README.md.tpl" "README.md"
    write_asset_file "node/package.json.tpl" "package.json"
    write_asset_file "node/src/index.js.tpl" "src/index.js"
    append_gitignore_entries "node_modules/"
}

apply_python_template() {
    write_asset_file "python/README.md.tpl" "README.md"
    write_asset_file "python/pyproject.toml.tpl" "pyproject.toml"
    write_asset_file "python/src/main.py.tpl" "src/main.py"
    append_gitignore_entries "__pycache__/" "*.pyc"
}

apply_fullstack_template() {
    write_asset_file "fullstack/README.md.tpl" "README.md"
    write_asset_file "fullstack/apps/web/package.json.tpl" "apps/web/package.json"
    write_asset_file "fullstack/apps/web/src/index.js.tpl" "apps/web/src/index.js"
    write_asset_file "fullstack/apps/api/main.py.tpl" "apps/api/main.py"
    append_gitignore_entries "node_modules/" "__pycache__/" "*.pyc"
}

apply_express_template() {
    local prefix

    prefix="express-$TEMPLATE_LANGUAGE"
    write_asset_file "$prefix/README.md.tpl" "README.md"
    write_asset_file "$prefix/package.json.tpl" "package.json"
    write_asset_file "$prefix/.env.example.tpl" ".env.example"
    write_asset_file "$prefix/src/app.$TEMPLATE_LANGUAGE.tpl" "src/app.$TEMPLATE_LANGUAGE"
    write_asset_file "$prefix/src/server.$TEMPLATE_LANGUAGE.tpl" "src/server.$TEMPLATE_LANGUAGE"
    write_asset_file "$prefix/src/config/env.$TEMPLATE_LANGUAGE.tpl" "src/config/env.$TEMPLATE_LANGUAGE"
    write_asset_file "$prefix/src/config/logger.$TEMPLATE_LANGUAGE.tpl" "src/config/logger.$TEMPLATE_LANGUAGE"
    write_asset_file "$prefix/src/middleware/error-handler.$TEMPLATE_LANGUAGE.tpl" "src/middleware/error-handler.$TEMPLATE_LANGUAGE"
    write_asset_file "$prefix/src/middleware/not-found.$TEMPLATE_LANGUAGE.tpl" "src/middleware/not-found.$TEMPLATE_LANGUAGE"
    write_asset_file "$prefix/src/routes/index.$TEMPLATE_LANGUAGE.tpl" "src/routes/index.$TEMPLATE_LANGUAGE"
    write_asset_file "$prefix/src/modules/health/health.controller.$TEMPLATE_LANGUAGE.tpl" "src/modules/health/health.controller.$TEMPLATE_LANGUAGE"
    write_asset_file "$prefix/src/modules/health/health.route.$TEMPLATE_LANGUAGE.tpl" "src/modules/health/health.route.$TEMPLATE_LANGUAGE"
    write_asset_file "$prefix/src/modules/health/health.service.$TEMPLATE_LANGUAGE.tpl" "src/modules/health/health.service.$TEMPLATE_LANGUAGE"
    append_gitignore_entries "node_modules/" "dist/" ".env"

    if [[ "$TEMPLATE_LANGUAGE" == "ts" ]]; then
        write_asset_file "$prefix/tsconfig.json.tpl" "tsconfig.json"
    fi
}

apply_template() {
    if [[ -z "$TEMPLATE" ]]; then
        return
    fi

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "Dry run: would scaffold template '$(template_variant_name)' with:"
        print_template_plan
        return
    fi

    PROJECT_TITLE="$TARGET_NAME"
    PROJECT_SLUG="$(slugify_name "$TARGET_NAME")"

    log_info "Applying template..."

    case "$TEMPLATE" in
        node)
            apply_node_template
            ;;
        python)
            apply_python_template
            ;;
        fullstack)
            apply_fullstack_template
            ;;
        express)
            apply_express_template
            ;;
    esac
}
