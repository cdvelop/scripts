#!/bin/bash
filename="$1"
git fetch --all
while read -r old_tag new_tag; do
    git tag "$new_tag" "$old_tag"
    git tag -d "$old_tag"
    git push origin :refs/tags/"$old_tag"
    git push --tags
done < "$filename"
