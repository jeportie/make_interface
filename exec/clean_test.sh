# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    clean_test.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/10/02 15:52:29 by jeportie          #+#    #+#              #
#    Updated: 2024/10/02 15:52:32 by jeportie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# Debug: Print current working directory
echo "Current working directory: $(pwd)"

# First, check if ./test_src exists in the current directory
if [ -d "./test_src" ]; then
    test_src_dir="./test_src"
    echo "Found test_src directory at: $test_src_dir (in current directory)"
else
    # If not, find the test_src directory but exclude unwanted paths like lib/libft
    test_src_dir=$(find "$(pwd)" -type d -name "test_src" ! -path "*/lib/libft/*" -print -quit)
    echo "Found directory: '$test_src_dir'"
fi

# Check if the test_src directory exists and is not empty
if [ -n "$test_src_dir" ] && [ -d "$test_src_dir" ]; then
    echo "Found test_src directory at: $test_src_dir"
    
    # Navigate to the test_src directory
    cd "$test_src_dir" || exit

    # Remove the specified files and directories
    echo "Removing specified files and directories..."
    rm -rf CMakeCache.txt Makefile cmake_install.cmake CMakeFiles CTestTestfile.cmake Testing

    # Remove all compiled executables (files with no extension)
    find . -type f -executable -exec rm -f {} +

    echo "Cleanup complete."
else
    echo "test_src directory not found."
fi
