#!/bin/bash

# Color definitions
RED='\033[0;31m'
LRED='\033[1;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
GREY='\033[1;30m'
NC='\033[0m'

# Check for the -y parameter
execute_mv=false
if [[ "$1" == "-y" ]]; then
  execute_mv=true
fi

# Loop through all MP4 files in the current directory and subdirectories
find . -type f -name "G???????.MP4" | while read -r file; do
  # Extract the encoding type (H or X), file number, and chapter number
  filename=$(basename "$file")
  encoding_type=$(echo "$filename" | cut -c2)
  chapter_number=$(echo "$filename" | cut -c3-4)
  file_number=$(echo "$filename" | cut -c5-8)

  # Print current filename
  echo -e $filename:

  # Check if
  # - the encoding type is H or X
  # - chapter_number is a number
  # - file_number is a number
  if  [[ "$encoding_type" =~ [HX] ]] && \
      [[ "$chapter_number" =~ ^[0-9]{2}$ ]] && \
      [[ "$file_number" =~ ^[0-9]{4}$ ]]; then

    # Construct the new filename
    new_filename="G-${file_number}-${encoding_type}-${chapter_number}.MP4"

    # Get the directory path
    dir_path=$(dirname "$file")

    # Check if the new filename already exists
    if [[ -e "${dir_path}/${new_filename}" ]]; then
      echo -e "${YELLOW}  Cannot rename $file to ${dir_path}/${new_filename} because the target file already exists.${NC}"
    else
      # Print the rename action
      echo -e   "${RED}  From: ${NC} $file"
      echo -e "${GREEN}  To:   ${NC} ${dir_path}/${new_filename}"

      # Rename the file if -y is passed
      if $execute_mv; then
        mv -i "$file" "${dir_path}/${new_filename}"
      fi
    fi
  else
    echo -e "${GREY}  File $filename does not match the required pattern.${NC}"
  fi
done

# Inform the user if no files were moved
if ! $execute_mv; then
echo -e "${ORANGE}No files were moved. Use the -y parameter to execute the move operation.${NC}"
fi
