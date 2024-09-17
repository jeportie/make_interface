# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    build.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jeportie <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/16 15:26:11 by jeportie          #+#    #+#              #
#    Updated: 2024/09/16 16:02:28 by jeportie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# Default values for the variables
DEFAULT_CC="cc"
DEFAULT_CFLAGS="-Wall -Wextra -Werror"
DEFAULT_LIBS="-lft"
DEFAULT_DIRLIBS="-L/usr/local/lib -L./lib"
DEFAULT_INCLUDES="-I./include -I/usr/local/include"
DEFAULT_STD="-std=c99"  # Default C standard

MAKEFILE="Makefile"
YCM_EXTRA_CONF="ycm_extra_conf.py"
BACKUP_DIR=".bak"

# Ensure the Makefile exists
if [ ! -f "$MAKEFILE" ]; then
    echo "Error: $MAKEFILE does not exist!"
    exit 1
fi

# Create .bak directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir "$BACKUP_DIR"
fi

# Function to update the Makefile with placeholders
update_makefile() {
    local placeholder=$1
    local value=$2
    if [ "$value" == "0" ]; then
        # If user enters 0, erase the marker but leave the line intact
        sed -i.bak "s/{{$placeholder}}//g" "$MAKEFILE"
    elif [ -n "$value" ]; then
        # If value is not empty, replace the placeholder with the value
        sed -i.bak "s/{{$placeholder}}/$value/g" "$MAKEFILE"
    else
        # If value is empty, erase the placeholder (and leave the line intact)
        sed -i.bak "s/{{$placeholder}}//g" "$MAKEFILE"
    fi
}

# Function to create ycm_extra_conf.py from scratch
create_ycm_extra_conf() {
    echo "Creating $YCM_EXTRA_CONF file..."
    cat <<EOF > "$YCM_EXTRA_CONF"
import os
import ycm_core

# Flags based on your project requirements
flags = [
    '$CFLAGS',
    '-std=c99',           # C standard provided by the user
    '$INCLUDES',          # Project include directories
    '-I/include',
    '-I/usr/local/include',
]

compilation_database_folder = ''

def DirectoryOfThisScript():
    return os.path.dirname(os.path.abspath(__file__))

def MakeRelativePathsAbsolute(flags, working_directory):
    if not working_directory:
        return list(flags)
    new_flags = []
    for flag in flags:
        new_flag = flag
        if flag.startswith('-I'):
            path = flag[2:]
            if not os.path.isabs(path):
                new_flag = '-I' + os.path.join(working_directory, path)
        new_flags.append(new_flag)
    return new_flags

def FlagsForFile(filename):
    return {
        'flags': MakeRelativePathsAbsolute(flags, DirectoryOfThisScript()),
        'do_cache': True
    }
EOF
}

# Prompt for project name (no default allowed, must not be empty)
read -p "Enter project name: " NAME
if [ -z "$NAME" ]; then
    echo "Error: Project name cannot be empty."
    exit 1
fi
update_makefile "NAME" "$NAME"

# Prompt the user for other inputs or use default values
read -p "Enter compiler (default: $DEFAULT_CC): " CC
CC=${CC:-$DEFAULT_CC}
update_makefile "CC" "$CC"

read -p "Enter CFLAGS (default: $DEFAULT_CFLAGS): " CFLAGS
CFLAGS=${CFLAGS:-$DEFAULT_CFLAGS}
update_makefile "CFLAGS" "$CFLAGS"

read -p "Enter C standard (default: $DEFAULT_STD): " STD
STD=${STD:-$DEFAULT_STD}

read -p "Enter libraries (default: $DEFAULT_LIBS): " LIBS
LIBS=${LIBS:-$DEFAULT_LIBS}
update_makefile "LIBS" "$LIBS"

read -p "Enter libraries directory (default: $DEFAULT_DIRLIBS): " DIRLIBS
DIRLIBS=${DIRLIBS:-$DEFAULT_DIRLIBS}
update_makefile "DIRLIBS" "$DIRLIBS"

read -p "Enter includes (default: $DEFAULT_INCLUDES): " INCLUDES
INCLUDES=${INCLUDES:-$DEFAULT_INCLUDES}
update_makefile "INCLUDES" "$INCLUDES"

# Move Makefile.bak to .bak directory
mv Makefile.bak "$BACKUP_DIR/Makefile.bak"

# Create ycm_extra_conf.py file from scratch using the provided values
create_ycm_extra_conf

# Backup the newly created ycm_extra_conf.py
cp "$YCM_EXTRA_CONF" "$BACKUP_DIR/ycm_extra_conf.py.bak"

# Remove any remaining placeholders in the Makefile
sed -i.bak 's/{{[^}]*}}//g' "$MAKEFILE"

echo "Makefile updated successfully! Backup is located in .bak/Makefile.bak"
echo "ycm_extra_conf.py created successfully! Backup is located in .bak/ycm_extra_conf.py.bak"
