# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    clean_test.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/30 09:19:51 by jeportie          #+#    #+#              #
#    Updated: 2024/09/30 09:20:13 by jeportie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# Find the test_src directory
test_src_dir=$(find . -type d -name "test_src")

# Check if the test_src directory exists
if [ -d "$test_src_dir" ]; then
    echo "Found test_src directory at: $test_src_dir"
    
    # Navigate to the test_src directory
    cd "$test_src_dir"

    # Remove the specified files and directories
    echo "Removing specified files and directories..."
    rm -rf CMakeCache.txt Makefile cmake_install.cmake CMakeFiles CTestTestfile.cmake Testing

    # Remove all compiled executables (files with no extension)
    find . -type f -executable -exec rm -f {} +

    echo "Cleanup complete."
else
    echo "test_src directory not found."
fi
