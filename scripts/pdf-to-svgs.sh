#!/usr/bin/env bash

# Convert a PDF to SVGs, one per page, suffixed by -1.svg, -2.svg, etc.

set -e

pdf=$1
prefix=$(echo $pdf | sed 's/\.[^.]*$//')
n_pages=$(pdfinfo "$pdf" | awk '/^Pages:/ {print $2}')

echo "Converting $pdf to $n_pages SVGs..." >&2

for (( page=1; page<=$n_pages; page++ ));
do
  destination="$prefix-$page.svg"
  pdf2svg "$pdf" "$destination" "$page"
  echo "$destination"
done

echo "Done." >&2
