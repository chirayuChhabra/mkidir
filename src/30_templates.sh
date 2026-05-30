template_variant_name() {
    case "$TEMPLATE" in
        express)
            printf 'express\n'
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
            if [[ "$PACKAGE_MANAGER" == "bun" ]]; then
                add_package "bun"
            elif [[ "$PACKAGE_MANAGER" == "npm" ]]; then
                add_package "nodejs@24"
            else
                add_package "nodejs@24"
                add_package "pnpm"
            fi
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
            echo "   - README.md"
            echo "   - package.json"
            echo "   - tsconfig.json"
            echo "   - biome.json"
            echo "   - Dockerfile"
            echo "   - .env.template"
            echo "   - src/app.ts"
            echo "   - src/server.ts"
            echo "   - src/api/"
            echo "   - src/config/"
            echo "   - src/database/"
            echo "   - src/errors/"
            echo "   - src/lib/"
            echo "   - src/middleware/"
            echo "   - src/queues/"
            echo "   - src/types/"
            echo "   - src/utils/"
            if [[ $PRISMA -eq 1 ]]; then
                echo "   - prisma.config.ts"
                echo "   - prisma/"
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
    local prefix="express-ts"

    write_asset_file "$prefix/README.md.tpl" "README.md"
    write_asset_file "$prefix/package.json.tpl" "package.json"
    write_asset_file "$prefix/tsconfig.json.tpl" "tsconfig.json"
    write_asset_file "$prefix/biome.json.tpl" "biome.json"
    write_asset_file "$prefix/Dockerfile.tpl" "Dockerfile"
    write_asset_file "$prefix/.env.template.tpl" ".env.template"
    write_asset_file "$prefix/.env.development.local.tpl" ".env.development.local"
    write_asset_file "$prefix/.env.production.local.tpl" ".env.production.local"
    write_asset_file "$prefix/.env.testing.local.tpl" ".env.testing.local"

    write_asset_file "$prefix/src/app.ts.tpl" "src/app.ts"
    write_asset_file "$prefix/src/server.ts.tpl" "src/server.ts"

    # We ensure directories exist by writing at least a .gitkeep or index file if needed,
    # or the bash template engine will create directories when files are written.
    write_asset_file "$prefix/src/api/v1/.gitkeep" "src/api/v1/.gitkeep"
    write_asset_file "$prefix/src/api/v2/.gitkeep" "src/api/v2/.gitkeep"
    write_asset_file "$prefix/src/api/v1/modules/.gitkeep" "src/api/v1/modules/.gitkeep"
    
    write_asset_file "$prefix/src/config/config.schema.ts.tpl" "src/config/config.schema.ts"
    write_asset_file "$prefix/src/config/config.envVar.ts.tpl" "src/config/config.envVar.ts"
    write_asset_file "$prefix/src/config/.gitkeep" "src/config/.gitkeep"
    write_asset_file "$prefix/src/database/.gitkeep" "src/database/.gitkeep"
    write_asset_file "$prefix/src/errors/.gitkeep" "src/errors/.gitkeep"
    write_asset_file "$prefix/src/lib/.gitkeep" "src/lib/.gitkeep"
    write_asset_file "$prefix/src/middleware/.gitkeep" "src/middleware/.gitkeep"
    write_asset_file "$prefix/src/queues/.gitkeep" "src/queues/.gitkeep"
    write_asset_file "$prefix/src/types/express.d.ts.tpl" "src/types/express.d.ts"
    write_asset_file "$prefix/src/utils/.gitkeep" "src/utils/.gitkeep"

    if [[ $PRISMA -eq 1 ]]; then
        write_asset_file "$prefix/prisma.config.ts.tpl" "prisma.config.ts"
        write_asset_file "$prefix/prisma/schema.prisma.tpl" "prisma/schema.prisma"
        write_asset_file "$prefix/prisma/models/.gitkeep" "prisma/models/.gitkeep"
    fi

    append_gitignore_entries "node_modules/" "dist/" ".env.*.local"
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
