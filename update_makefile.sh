#!/bin/bash

# Define the root directory
SRC_DIR="src"

# Function to generate the list of .c files recursively in src/ and subdirectories
generate_src_list() {
    find $1 -name "*.c"
}

# Scan for all .c files in the src directory recursively
SRC_FILES=$(generate_src_list "$SRC_DIR")

# Define the start and end markers for the C file list in your Makefile
START_MARKER="### BEGIN AUTO GENERATED FILES ###"
END_MARKER="### END AUTO GENERATED FILES ###"

# Prepare the format of the file list for the Makefile
FILE_LIST=""
for FILE in $SRC_FILES; do
  FILE_LIST="$FILE_LIST \\\n  $FILE"
done

# Check if the Makefile exists and contains the marker for auto-generated files
if grep -q "$START_MARKER" Makefile; then
  # If markers exist, replace the existing list between markers
  sed -i.bak "/$START_MARKER/,/$END_MARKER/{//!d;}; /$START_MARKER/r /dev/stdin" Makefile <<<"\
# List of source files:
SRC = $FILE_LIST"
else
  # If markers don't exist, append the source file list at the end
  echo -e "\n$START_MARKER\n# List of source files:\nSRC = $FILE_LIST\n$END_MARKER" >> Makefile
fi

echo "Makefile updated with new .c files."
