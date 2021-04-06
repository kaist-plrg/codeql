#!/bin/sh

set -eu

exec "${CODEQL_DIST}/codeql" database index-files \
    --include-extension=.htm \
    --include-extension=.html \
    --include-extension=.xhtm \
    --include-extension=.xhtml \
    --include-extension=.vue \
    --size-limit=5m \
    --language=html \
    "$CODEQL_EXTRACTOR_HTML_WIP_DATABASE"
