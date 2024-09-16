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
DEFAULT_NAME="philo"
DEFAULT_CC="cc"
DEFAULT_CFLAGS="-Wall -Wextra -Werror"
DEFAULT_LIBS="-lft"
DEFAULT_DIRLIBS="-L/usr/local/lib -L./lib"
DEFAULT_INCLUDES="-I./include -I/usr/local/include"

MAKEFILE="Makefile"
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

# Function to update the Makefile
update_makefile() {
    local placeholder=$1
    local value=$2
    sed -i.bak "s/{{$placeholder}}/$value/g" "$MAKEFILE"
}

# Prompt the user for inputs or use default values and update the Makefile immediately
read -p "Enter project name (default: $DEFAULT_NAME): " NAME
NAME=${NAME:-$DEFAULT_NAME}
update_makefile "NAME" "$NAME"

read -p "Enter compiler (default: $DEFAULT_CC): " CC
CC=${CC:-$DEFAULT_CC}
update_makefile "CC" "$CC"

read -p "Enter CFLAGS (default: $DEFAULT_CFLAGS): " CFLAGS
CFLAGS=${CFLAGS:-$DEFAULT_CFLAGS}
update_makefile "CFLAGS" "$CFLAGS"

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

echo "Makefile updated successfully! Backup is located in .bak/Makefile.bak"
