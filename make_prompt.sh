# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    make_prompt.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/12 18:44:00 by jeportie          #+#    #+#              #
#    Updated: 2024/09/12 18:48:16 by jeportie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color

while true; do
    echo -n "${GREEN}Make>${NC} "
    read target

    if [ "$target" = "exit" ] || [ "$target" = "quit" ]; then
        echo "Exiting Make prompt."
        break
    fi

    if [ -n "$target" ]; then
        make $target
    else
        echo "Please enter a valid make target or type 'exit' to quit."
    fi
done
