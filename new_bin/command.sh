#! /bin/sh
source "$( cd "$(dirname $0 )/.." && pwd)/lib/main.sh"


function log_async_result() {
    local line
    while read line; do
        echo "Async $@: $line"
    done
} >> "$log"

function async_command() {
    (echo "$("$@" 2>&1; echo "Return code: $?")" | log_async_result "$@" &)
    exit 0
}

function is_a_command() {

    if command -v "$1" >/dev/null; then
        exit 0
    fi
    exit 1

}

action=""
help=""
help+="async_command <log> <command> Run an Async Command$nl"
help+="is_a_command  <binary> Check if a command is valid$nl"
while [ "$#" -gt "0" ]; do
    arg="$1"; shift
    case $arg in
        --help)
        usage "$help"
        ;;
        --is_a_command)
            if [ -z "$1" ]; then
                argument_error "$arg requires an argument"
            fi
            is_a_command "$1"
        ;;
        --async_command)
            if [ -z "$1" ] || [ -z "$2" ]; then
                argument_error "$arg requires two arguments"
            fi
            log="$1"; shift

            async_command "$@"
        ;;
        *)
            argument_error "Invalid Argument $arg"
        ;;
    esac
done

