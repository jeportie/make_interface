/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   make_prompt.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jeportie <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/13 10:44:53 by jeportie          #+#    #+#             */
/*   Updated: 2024/09/13 12:41:14 by jeportie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <readline/readline.h>
#include <readline/history.h>

#define GREEN "\033[0;32m"
#define NC "\033[0m"  // No Color

static void	ft_free_memory(char **tab, size_t i)
{
	while (i > 0)
	{
		i--;
		free(tab[i]);
	}
}

static size_t	ft_substr_len(char *str, char c)
{
	size_t	len;

	len = 0;
	while (str[len] && str[len] != c)
		len++;
	return (len);
}

static size_t	ft_count_words(char *str, char c)
{
	size_t	nb_words;

	nb_words = 0;
	while (*str)
	{
		while (*str && *str == c)
			str++;
		if (*str && *str != c)
		{
			nb_words++;
			while (*str && *str != c)
				str++;
		}
	}
	return (nb_words);
}

size_t	ft_strlcpy(char *dst, const char *src, size_t size)
{
	size_t	i;

	i = 0;
	if (!dst || !src)
		return (0);
	if (size > 0)
	{
		while (src[i] && i < size - 1)
		{
			dst[i] = src[i];
			i++;
		}
		dst[i] = '\0';
	}
	while (src[i])
		i++;
	return (i);
}

static char	*ft_extract(const char **s, char c, char **tab, size_t i)
{
	size_t	word_len;
	char	*word;

	while (**s && **s == c)
		(*s)++;
	word_len = ft_substr_len((char *)*s, c);
	word = (char *)malloc(sizeof(char) * (word_len + 1));
	if (!word)
	{
		ft_free_memory(tab, i);
		return (NULL);
	}
	ft_strlcpy(word, *s, word_len + 1);
	*s += word_len;
	return (word);
}

char	**ft_split(char const *s, char c)
{
	char	**tab;
	size_t	words;
	size_t	i;

	if (!s)
		return (NULL);
	words = ft_count_words((char *)s, c);
	tab = (char **)malloc(sizeof(char *) * (words + 1));
	if (!tab)
		return (NULL);
	i = 0;
	while (i < words)
	{
		tab[i] = ft_extract(&s, c, tab, i);
		if (!tab[i])
		{
			free(tab);
			return (NULL);
		}
		i++;
	}
	if (i != words)
		return (NULL);
	tab[words] = NULL;
	return (tab);
}
void	remove_newline(char *str)
{
	int	len;

	len = 0;
	while (str[len] != '\0')
		len++;
	if (len > 0 && str[len - 1] == '\n')
		str[len - 1] = '\0';
}

void run_make_command(char *target, char *args)
{
    pid_t pid;
    char **split_args;
    char **make_args;
    int i;

    pid = fork();
    if (pid == -1)
    {
        write(2, "Fork failed\n", 12);
        return;
    }
    if (pid == 0)  // Child process
    {
        if (args)
            split_args = ft_split(args, ' ');
        else
            split_args = NULL;
        int split_count = 0;
        if (split_args)
        {
            while (split_args[split_count])
                split_count++;
        }
        make_args = malloc(sizeof(char *) * (3 + split_count + 1));
        if (!make_args)
        {
            write(2, "Memory allocation failed\n", 25);
            _exit(1);
        }
        make_args[0] = "make";
        make_args[1] = "-s";
        make_args[2] = target;  // Target to make
        for (i = 0; i < split_count; i++)
        {
            make_args[3 + i] = split_args[i];
        }
        make_args[3 + i] = NULL;  // NULL-terminate the array
        execvp(make_args[0], make_args);
        write(2, "Exec failed\n", 12);
        _exit(1);
    }
    else  // Parent process
    {
        waitpid(pid, NULL, 0);  // Wait for the child process to finish
    }
}

int	main(void)
{
	char	*target;
	char	*args;

	while (1)
	{
		target = readline("Make> "); // Replaces fgets, supports history
		if (!target)
			break;

		if (strlen(target) > 0)
		{
			add_history(target); // Add command to history

			remove_newline(target);
			args = strchr(target, ' ');  // Find the first space (arguments start here)
			if (args != NULL)
			{
				*args = '\0';  // Split target and args
				args++;  // Move to the first argument after the space
			}
			if (strcmp(target, "exit") == 0 || strcmp(target, "quit") == 0)
				break ;
			run_make_command(target, args);
		}
		else
		{
			printf("Please enter a valid target.\n");
		}
		free(target); // Free memory allocated by readline
	}

	printf("Exiting Make prompt.\n");
	return (0);
}
