#!/usr/bin/env bash

set -e

typ="$1"
[[ -z "$typ" ]] && { echo "Input is empty" ; exit 1; }

prefix=$(echo $typ | sed 's/\.[^.]*$//')
handout_typ="$prefix-handout.typ"

echo "Creating handout-version of $typ at $handout_typ..." >&2

sed 's/#enable-handout-mode(false)/#enable-handout-mode(true)/' "$typ" > "$handout_typ"

echo "$handout_typ"
