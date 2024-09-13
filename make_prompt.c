/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   make_prompt.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jeportie <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/13 10:44:53 by jeportie          #+#    #+#             */
/*   Updated: 2024/09/13 11:07:35 by jeportie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

#define GREEN "\033[0;32m"
#define NC "\033[0m"  // No Color

void remove_newline(char *str)
{
    int len;

    len = 0;
    while (str[len] != '\0')
        len++;
    if (len > 0 && str[len - 1] == '\n')
        str[len - 1] = '\0';
}

void run_make_command(char *target, char **args)
{
    pid_t pid;
    int status;

    pid = fork();
    if (pid == -1)
    {
        write(2, "Fork failed\n", 12);
        return;
    }
    if (pid == 0)
    {
        // In child process, pass the command to make with arguments
        execvp(target, args);
        write(2, "Exec failed\n", 12);
        _exit(1);
    }
    else
    {
        // Wait for the child process to finish
        waitpid(pid, &status, 0);
    }
}

char **split_arguments(char *input, int *argc)
{
    char **args = NULL;
    char *token;
    int count = 0;

    // Use strtok to split the input string by spaces
    token = strtok(input, " ");
    while (token)
    {
        args = realloc(args, sizeof(char *) * (count + 2)); // Dynamic allocation
        args[count] = strdup(token); // Duplicate the token
        count++;
        token = strtok(NULL, " ");
    }
    args[count] = NULL; // NULL-terminate the array
    *argc = count;
    return args;
}

int main(void)
{
    char target[256];
    char **args;
    int argc;

    while (1)
    {
        write(1, GREEN "Make> " NC, sizeof(GREEN "Make> " NC) - 1);
        if (!fgets(target, sizeof(target), stdin))
            break;
        remove_newline(target);
        if (strcmp(target, "exit") == 0 || strcmp(target, "quit") == 0)
            break;
        
        // Split the target into arguments
        args = split_arguments(target, &argc);

        if (argc > 0)
        {
            run_make_command("make", args);
        }
        else
        {
            write(1, "Please enter a valid target.\n", 29);
        }

        // Free the allocated memory for arguments
        for (int i = 0; i < argc; i++)
        {
            free(args[i]);
        }
        free(args);
    }
    write(1, "Exiting Make prompt.\n", 21);
    return 0;
}

