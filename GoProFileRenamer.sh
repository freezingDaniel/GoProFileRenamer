#!/bin/bash

# Color definitions
RED='\033[0;31m'
LRED='\033[1;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
GREY='\033[1;30m'
NC='\033[0m'

# Loop through all MP4 files in the current directory and subdirectories
find . -type f \( -name "G???????.MP4" -o -name "G???????.LRV" -o -name "G???????.THM" \) | while read -r file;
do
  # Extract the encoding type (H or X), file number, and chapter number
  filename=$(basename "$file")
  encoding_type=$(echo "$filename" | cut -c2)
  chapter_number=$(echo "$filename" | cut -c3-4)
  file_number=$(echo "$filename" | cut -c5-8)
  file_ending=$(echo "$filename" | cut -c10-12)

  # Print current filename
  echo -e $filename:

  # Check if 
  # - the encoding type is H or X 
  # - chapter_number is a number
  # - file_number is a number
  if  [[ "$encoding_type" =~ [HXL] ]] && \
      [[ "$chapter_number" =~ ^[0-9]{2}$ ]] && \
      [[ "$file_number" =~ ^[0-9]{4}$ ]]; then

    # Construct the new filename
    new_filename="G-${file_number}-${chapter_number}-${encoding_type}.${file_ending}"

    # Get the directory path
    dir_path=$(dirname "$file")

    # Check if the new filename already exists
    if [[ -e "${dir_path}/${new_filename}" ]]; then
      echo -e "${YELLOW}  Cannot rename $file to ${dir_path}/${new_filename} because the target file already exists.${NC}"
    else
      # Rename the file
      echo -e   "${RED}  From: ${NC} $file"
      echo -e "${GREEN}  To:   ${NC} ${dir_path}/${new_filename}"
      mv -i "$file" "${dir_path}/${new_filename}"
    fi
  else
    echo -e "${GREY}  File $filename does not match the required pattern.${NC}"
  fi
done
