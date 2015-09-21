#!/bin/bash
set -e

case "$1" in
'build' | "env" | "fmt" | "generate" | "install" | "list" | "run" | "test" | "tool" | "version")
    exec "/usr/bin/go" $@
    ;;
*)
    exec "$@"
    ;;
esac