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

#define GREEN "\033[0;32m"
#define NC "\033[0m"  // No Color

void	remove_newline(char *str)
{
	int	len;

	len = 0;
	while (str[len] != '\0')
		len++;
	if (len > 0 && str[len - 1] == '\n')
		str[len - 1] = '\0';
}

void	run_make_command(char *target, char *args)
{
	pid_t	pid;
	char	*make_args[6];

	pid = fork();
	if (pid == -1)
	{
		write(2, "Fork failed\n", 12);
		return ;
	}
	if (pid == 0)
	{
		make_args[0] = "make";
		make_args[1] = "-s";
		make_args[2] = target;
		if (args)
		{
			make_args[3] = args;  // Pass arguments to make
			make_args[4] = NULL;
		}
		else
			make_args[3] = NULL;
		execvp(make_args[0], make_args);
		write(2, "Exec failed\n", 12);
		_exit(1);
	}
	else
		waitpid(pid, NULL, 0);
}

int	main(void)
{
	char	target[256];
	char	*args;

	while (1)
	{
		write(1, GREEN "Make> " NC, sizeof(GREEN "Make> " NC) - 1);
		if (!fgets(target, sizeof(target), stdin))
			break ;
		remove_newline(target);
		args = strchr(target, ' ');  // Find the first space (arguments start here)
		if (args != NULL)
		{
			*args = '\0';  // Split target and args
			args++;  // Move to the first argument after the space
		}
		if (strcmp(target, "exit") == 0 || strcmp(target, "quit") == 0)
			break ;
		if (strlen(target) > 0)
			run_make_command(target, args);
		else
			write(1, "Please enter a valid target.\n", 29);
	}
	write(1, "Exiting Make prompt.\n", 21);
	return (0);
}
