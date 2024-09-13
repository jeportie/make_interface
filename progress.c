/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   progress.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/12 19:31:14 by jeportie          #+#    #+#             */
/*   Updated: 2024/09/12 19:37:29 by jeportie         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BAR_WIDTH 20
#define MAX_SLEEP_USEC 1000000  // 1 second in microseconds
#define MIN_SLEEP_USEC 10000    // 10 ms in microseconds

void	print_progress(int step, int total)
{
	int	percent;
	int	bar_length;

	// Ensure the percentage does not exceed 100%
	if (step > total)
		step = total;
	percent = (step * 100) / total;
	bar_length = (step * BAR_WIDTH) / total;
	printf("\r\033[32m[%-*.*s] %d%%\033[0m", BAR_WIDTH, bar_length,
		"####################", percent);
	fflush(stdout);
}

void	progressive_sleep(int step, int total)
{
	int	sleep_time;

	sleep_time = MAX_SLEEP_USEC
		- ((MAX_SLEEP_USEC - MIN_SLEEP_USEC) * step / total);
	usleep(sleep_time);
}

int	main(int argc, char **argv)
{
	int		total_steps;
	int		current_step;
	char	*log_file;
	char	line[256];
	FILE	*file;

	if (argc != 3)
	{
		fprintf(stderr, "Usage: %s TOTAL LOG_FILE\n", argv[0]);
		return (1);
	}
	total_steps = atoi(argv[1]);
	log_file = argv[2];
	file = fopen(log_file, "r");
	if (!file)
	{
		perror("Error opening log file");
		return (1);
	}
	current_step = 0;
	while (fgets(line, sizeof(line), file) && current_step < total_steps)
	{
		current_step++;
		print_progress(current_step, total_steps);
		progressive_sleep(current_step, total_steps);
	}
	fclose(file);
	// Ensure we print the final 100% state
	print_progress(total_steps, total_steps);
	printf("\n");
	return (0);
}
