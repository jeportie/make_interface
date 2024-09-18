# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    update_makefile.sh                                 :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/15 19:28:59 by jeportie          #+#    #+#              #
#    Updated: 2024/09/15 20:08:30 by jeportie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# Define the root directory
SRC_DIR="src"
BAK_DIR=".bak"

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
  FILE_LIST="$FILE_LIST  $FILE \\\\\n"
done

# Remove the trailing '\' from the last file
FILE_LIST=$(printf "$FILE_LIST" | sed '$ s/\\\\//')

# Ensure the .bak folder exists
mkdir -p $BAK_DIR

# Temporary file to hold the new file list content
TEMP_FILE=$(mktemp)

# Write the new SRC content to the temp file without leading \n
printf "# List of source files:\nSRC = \\" > $TEMP_FILE
printf "\n%s" "$FILE_LIST" >> $TEMP_FILE

# Check if the Makefile exists and contains the marker for auto-generated files
if grep -q "$START_MARKER" Makefile; then
  # If markers exist, replace the existing list between markers using the temp file
  sed -i.bak "/$START_MARKER/,/$END_MARKER/{//!d;}" Makefile
  # Ensure the END marker is correctly placed after the file list
  printf "%s\n" "$END_MARKER" >> $TEMP_FILE
  sed -i "/$START_MARKER/r $TEMP_FILE" Makefile
else
  # If markers don't exist, append the source file list at the end
  printf "\n%s\n# List of source files:\nSRC = \\\n%s\n%s\n" "$START_MARKER" "$FILE_LIST" "$END_MARKER" >> Makefile
fi

sed -i 's/\\###.*//g' Makefile

# Ensure there is only one instance of '### END AUTO GENERATED FILES ###' in a row, but only if the marker exists
if grep -q "^### END AUTO GENERATED FILES ###" Makefile; then
    # Only proceed with checking for consecutive duplicates of the END marker
    sed -i '/^### END AUTO GENERATED FILES ###$/N;/\n### END AUTO GENERATED FILES ###$/d' Makefile
fi

# Move the backup Makefile to the .bak folder
mv Makefile.bak $BAK_DIR/

# Remove the temporary file
rm -f $TEMP_FILE

echo "Makefile updated with new .c files. Backup stored in .bak/"
