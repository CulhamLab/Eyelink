%% Requires directory added to path
if ~exist('EyelinkConnect','file')
    error('The "AddToPath" directory must be added to the MATLAB path. Run "setup.m" or add manually.');
end

%% Parameters
filename_edf = 'example.edf';
filename_figure_overview = 'example_overview';
filename_figure_trials = 'example_trials';
filename_figure_trials_time = 'example_trials_time';
filename_figure_all = 'example_all';

regexp_start = 'Trial \d\d\d: START';
regexp_end = 'Trial \d\d\d: END';

colour_x = [1 0 0];
colour_y = [0 0 1];

%% Demo

%read in data
edf = Edf2Mat(filename_edf);

% display overview
plot(edf);
print(gcf, [filename_figure_overview '.png'], '-dpng', '-r300');

%find start/end messages (not the start/end of recordings)
ind_start = cellfun(@(x) ~isempty(regexp(x, regexp_start)), edf.Events.Messages.info);
ind_end = cellfun(@(x) ~isempty(regexp(x, regexp_end)), edf.Events.Messages.info);

%check that trial numbers match in the start/ends
trial_nums_start = cellfun(@(x) str2num(x(regexp(x,'\d'))), edf.Events.Messages.info(ind_start));
trial_nums_end = cellfun(@(x) str2num(x(regexp(x,'\d'))), edf.Events.Messages.info(ind_end));
if length(trial_nums_start) ~= trial_nums_end
    error('Number of trial starts does not match number of trial ends!')
elseif any(trial_nums_start ~= trial_nums_end)
    error('Trial numbers in starts do not match ends!')
end

%find the start/end message timepoints
timepoint_start = edf.Events.Messages.time(ind_start);
timepoint_end = edf.Events.Messages.time(ind_end);

%check that starts always proceed ends
if any(timepoint_end < timepoint_start)
    error('A trial end message proceeded the trial start!')
end

%get sample index for each start/end timepoint
sample_index_start = arrayfun(@(x) find(edf.Samples.time >= x, 1, 'first'), timepoint_start);
sample_index_end = arrayfun(@(x) find(edf.Samples.time <= x, 1, 'last'), timepoint_end);

%get XY for each trial (and time of each position)
Xs = arrayfun(@(s,e) edf.Samples.posX(s:e), sample_index_start, sample_index_end, 'UniformOutput', false);
Ys = arrayfun(@(s,e) edf.Samples.posY(s:e), sample_index_start, sample_index_end, 'UniformOutput', false);
Times = arrayfun(@(s,e) edf.Samples.time(s:e), sample_index_start, sample_index_end, 'UniformOutput', false);

%get range of Xs and Ys
x_min = min(cellfun(@min, Xs));
x_max = max(cellfun(@max, Xs));
y_min = min(cellfun(@min, Ys));
y_max = max(cellfun(@max, Ys));
xy_min = min([x_min y_min]);
xy_max = max([x_max y_max]);

%plot each trial X-by-Y
num_trial = length(Xs);
num_col = floor(sqrt(num_trial));
num_row = ceil(sqrt(num_trial));
fig_trial = figure('Position', [1 1 (num_row*200) (num_col*200)]);
for trial = 1:num_trial
    subplot(num_col, num_row, trial);
    plot(Xs{trial}, Ys{trial}, '.-', 'MarkerSize', 1)
    axis([x_min x_max y_min y_max])
    axis equal
    set(gca, 'XTick', [], 'YTick', []);
    title(sprintf('Trial %d', trial))
end
print(fig_trial, [filename_figure_trials '.png'], '-dpng', '-r300');

%plot each trial XY-by-time
fig_trial_time = figure('Position', [1 1 (num_row*200) (num_col*200)]);
for trial = 1:num_trial
    subplot(num_col, num_row, trial);
    hold on
    plot(Times{trial}, Xs{trial}, '.', 'Color', colour_x, 'MarkerSize', 1)
    plot(Times{trial}, Ys{trial}, '.', 'Color', colour_y, 'MarkerSize', 1)
    hold off
    axis([Times{trial}([1 end])' xy_min xy_max])
    set(gca, 'XTick', [], 'YTick', []);
    title(sprintf('Trial %d', trial))
end
suptitle(sprintf('X and Y over Time\nX Colour = (%d,%d,%d), Y Colour = (%d,%d,%d)', colour_x, colour_y))
print(fig_trial_time, [filename_figure_trials_time '.png'], '-dpng', '-r300');

%plot all trilas X-by-Y
colours = jet(num_trial);
fig_all = figure('Position', [1 1 1000 1000]);
hold on
for trial = 1:num_trial
    p(trial) = plot(Xs{trial}, Ys{trial}, '.-', 'Color', colours(trial,:), 'MarkerSize', 1);
end
hold off
axis([x_min x_max y_min y_max])
axis equal
legend(p,arrayfun(@(x) sprintf('Trial%03d',x), trial_nums_start, 'UniformOutput', false),'Location','EastOutside')
title('All Trials')
print(fig_all, [filename_figure_all '.png'], '-dpng', '-r300');