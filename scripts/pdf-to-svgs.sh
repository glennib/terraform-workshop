#!/usr/bin/env bash

# Convert a PDF to SVGs, one per page, suffixed by -1.svg, -2.svg, etc.

pdf=$1
prefix=$(echo $pdf | sed 's/\.[^.]*$//')
pages=$(pdfinfo "$pdf" | awk '/^Pages:/ {print $2}')

echo "Converting $pdf to $pages SVGs..." >&2

for (( page=1; page<=$pages; page++ ));
do
  destination="$prefix-$page.svg"
  pdf2svg "$pdf" "$destination" "$page"
  echo "$destination"
done

echo "Done." >&2
