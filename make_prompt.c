/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   make_prompt.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jeportie <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/13 10:44:53 by jeportie          #+#    #+#             */
/*   Updated: 2024/09/13 10:46:03 by jeportie         ###   ########.fr       */
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

void	run_make_command(char *target)
{
	pid_t	pid;
	char	*args[4];

	pid = fork();
	if (pid == -1)
	{
		write(2, "Fork failed\n", 12);
		return ;
	}
	if (pid == 0)
	{
		args[0] = "make";
		args[1] = "-s";
		args[2] = target;
		args[3] = NULL;
		execvp(args[0], args);
		write(2, "Exec failed\n", 12);
		_exit(1);
	}
	else
		waitpid(pid, NULL, 0);
}

int	main(void)
{
	char	target[256];

	while (1)
	{
		write(1, GREEN "Make> " NC, sizeof(GREEN "Make> " NC) - 1);
		if (!fgets(target, sizeof(target), stdin))
			break ;
		remove_newline(target);
		if (strcmp(target, "exit") == 0 || strcmp(target, "quit") == 0)
			break ;
		if (strlen(target) > 0)
			run_make_command(target);
		else
			write(1, "Please enter a valid target.\n", 29);
	}
	write(1, "Exiting Make prompt.\n", 21);
	return (0);
}
