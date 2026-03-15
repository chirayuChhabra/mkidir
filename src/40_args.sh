parse_args() {
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 0
    fi

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                show_usage
                exit 0
                ;;
            --list-templates)
                list_templates
                exit 0
                ;;
            --dry-run)
                DRY_RUN=1
                shift
                ;;
            --template|-t)
                if [[ $# -lt 2 ]]; then
                    log_error "missing template name for $1"
                    exit 1
                fi
                TEMPLATE="$2"
                shift 2
                ;;
            --template=*)
                TEMPLATE="${1#*=}"
                shift
                ;;
            --js)
                TEMPLATE_LANGUAGE="js"
                shift
                ;;
            --ts)
                TEMPLATE_LANGUAGE="ts"
                shift
                ;;
            -*)
                log_error "unknown option: $1"
                exit 1
                ;;
            *)
                if [[ -z "$TARGET_DIR" ]]; then
                    TARGET_DIR="$1"
                else
                    add_package "$1"
                fi
                shift
                ;;
        esac
    done

    if [[ -z "$TARGET_DIR" ]]; then
        log_error "missing target path"
        exit 1
    fi

    if [[ -e "$TARGET_DIR" ]]; then
        log_error "target '$TARGET_DIR' already exists"
        exit 1
    fi

    validate_template
    merge_template_packages
    TARGET_PARENT="$(dirname -- "$TARGET_DIR")"
    TARGET_NAME="$(basename -- "$TARGET_DIR")"
}
