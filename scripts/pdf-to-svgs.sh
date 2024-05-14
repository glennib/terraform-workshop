#!/usr/bin/env bash

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
