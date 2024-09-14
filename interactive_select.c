/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   interactive_select.c                               :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jeportie <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/14 18:20:00 by jeportie          #+#    #+#             */
/*   Updated: 2024/09/14 18:45:07 by jeportie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <ncurses.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_FILES 100

void	display_menu(WINDOW *menu_win, char *choices[], int n_choices, int hl);
void	get_uml_files(char *directory, char *file_list[], int *count);

int	main(void)
{
	char	*file_list[MAX_FILES];
	int		file_count;
	int		highlight;
	int		choice;
	int		c;
	WINDOW	*menu_win;

	file_count = 0;
	get_uml_files(".uml", file_list, &file_count);
	if (file_count == 0)
	{
		printf("No UML files found in the .uml directory\n");
		return (1);
	}
	initscr();
	clear();
	noecho();
	cbreak();
	curs_set(0);
	highlight = 0;
	choice = 0;
	menu_win = newwin(10, 40, 4, 4);
	keypad(menu_win, TRUE);
	mvprintw(0, 0, "Select a UML file to edit:");
	refresh();
	while (1)
	{
		display_menu(menu_win, file_list, file_count, highlight);
		c = wgetch(menu_win);
		if (c == KEY_UP && highlight > 0)
			highlight--;
		else if (c == KEY_DOWN && highlight < file_count - 1)
			highlight++;
		else if (c == 10)
			choice = highlight;
		if (c == 10)
			break ;
	}
	endwin();
	{
		char command[256];

		snprintf(command, sizeof(command), "vim .uml/%s -c 'sleep 2' -c 'PlantumlSave' -c 'q'", file_list[choice]);
		system(command);
	}
	for (int i = 0; i < file_count; i++)
		free(file_list[i]);
	return (0);
}

void	get_uml_files(char *directory, char *file_list[], int *count)
{
	struct dirent	*entry;
	DIR				*dp;

	dp = opendir(directory);
	if (dp == NULL)
	{
		perror("opendir");
		exit(1);
	}
	while ((entry = readdir(dp)) != NULL)
	{
		if (strstr((const char *)entry->d_name, ".uml") != NULL)
		{
			file_list[*count] = strdup(entry->d_name);
			(*count)++;
		}
	}
	closedir(dp);
}

void	display_menu(WINDOW *menu_win, char *choices[], int n_choices, int hl)
{
	int	x;
	int	y;
	int	i;

	x = 2;
	y = 2;
	i = 0;
	box(menu_win, 0, 0);
	while (i < n_choices)
	{
		if (hl == i)
			wattron(menu_win, A_REVERSE);
		mvwprintw(menu_win, y, x, "%s", choices[i]);
		wattroff(menu_win, A_REVERSE);
		y++;
		i++;
	}
	wrefresh(menu_win);
}
