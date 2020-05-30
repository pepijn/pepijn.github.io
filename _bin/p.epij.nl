#!/usr/bin/env bash

set -euxo pipefail

dir="$1"

cd "$dir"

make publish

/usr/local/bin/rbenv exec bundle exec jekyll serve --drafts --livereload --port 1337 --open-url
