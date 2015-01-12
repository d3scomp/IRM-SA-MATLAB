function simulate
% SIMULATE runs the simulation of firefighters moving on the heat map.
% At first there is a heat map being generated. Than there are created 4 firefighter
% components and theirs processes. There are planned movements of these components.
% After this preparation the simulation calendar is initialized with the starting
% events and the simulation runs until maximum of simulation steps is reached.

    animate = true; % Indicates whether the simulation will be animated.
    maxSteps = 30000; % The number of steps in the simulation. After the given number of steps the simulation ends.

    % Configure the simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    rng(12345); % Seed the random number generator
    
	% Create the firefighter components
    f1 = FireFighter('f1');
    f2 = FireFighter('f2');
    f3 = FireFighter('f3');
    f4 = FireFighter('f4');
    
	% Generate heat map
    map = generateHeatMap();
    
    % Create destination points for the firefighters
    d1 = [250, 250];
    d2 = [300, 300];

	% Create an instance of the calendar for simulation
    calendar = EventCalendar();
    
	% The firefighter f1 will start moving towards d1 in the time 1
    f1Move = FireFighterMoveProcess(f1, 1, map, d1);
    f1MoveEvent = Event(f1Move, 1);
    calendar.insert(f1MoveEvent);
    
	% The firefighter f1 will start moving towards d2 in the time 350
    f1Move = FireFighterMoveProcess(f1, 1, map, d2);
    f1MoveEvent = Event(f1Move, 350);
    calendar.insert(f1MoveEvent);
	
    % The firefighter f2 will start moving towards d1 in the time 5
    f2Move = FireFighterMoveProcess(f2, 1, map, d1);
    f2MoveEvent = Event(f2Move, 5);
    calendar.insert(f2MoveEvent);
    
	% The firefighter f3 will start moving towards d2 in the time 10
    f3Move = FireFighterMoveProcess(f3, 1, map, d2);
    f3MoveEvent = Event(f3Move, 10);
    calendar.insert(f3MoveEvent);
    
	% The firefighter f3 will start moving towards d1 in the time 350
    f3Move = FireFighterMoveProcess(f3, 1, map, d1);
    f3MoveEvent = Event(f3Move, 350);
    calendar.insert(f3MoveEvent);
    
	% The firefighter f4 will start moving towards d2 in the time 10
    f4Move = FireFighterMoveProcess(f4, 1, map, d2);
    f4MoveEvent = Event(f4Move, 10);
    calendar.insert(f4MoveEvent);
    
    % The sample process for the firefighter f1
    f1Sample = FireFighterSampleProcess(f1, 0.1, map);
    f1SampleEvent = Event(f1Sample, 0);
    calendar.insert(f1SampleEvent);
    
	% The sample process for the firefighter f2
    f2Sample = FireFighterSampleProcess(f2, 0.1, map);
    f2SampleEvent = Event(f2Sample, 0);
    calendar.insert(f2SampleEvent);
    
	% The sample process for the firefighter f3
    f3Sample = FireFighterSampleProcess(f3, 0.1, map);
    f3SampleEvent = Event(f3Sample, 0);
    calendar.insert(f3SampleEvent);
    
	% The sample process for the firefighter f4
    f4Sample = FireFighterSampleProcess(f4, 0.1, map);
    f4SampleEvent = Event(f4Sample, 0);
    calendar.insert(f4SampleEvent);

    % Simulate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
    step = 0;
    
    if animate
        figure
        colormap('hot');
        imagesc(map);
        colorbar;
        title('Heat Map');
        hold on;
    end
    
    fprintf('Simulation:     ');
    progress = 0;
    
    while(calendar.isNext() && step < maxSteps)
        calendar.executeNext();
        step = step + 1;
        if(floor(progress) ~= floor((step/maxSteps)*100)) % If the progress increases print it
            progress = (step/maxSteps)*100;
            fprintf('\b\b\b\b');
            fprintf('%3.0f%%', progress);
        end
        if(animate && f1.HasMoved > 50) % If the animation is required do it each 50 moves (to improve the simulation speed)
            f1.HasMoved = 1;
            plot(f1.PositionX, f1.PositionY, 'b.', 'MarkerSize', 5);
            plot(f2.PositionX, f2.PositionY, 'g.', 'MarkerSize', 5);
            plot(f3.PositionX, f3.PositionY, 'r.', 'MarkerSize', 5);
            plot(f4.PositionX, f4.PositionY, 'c.', 'MarkerSize', 5);
            drawnow;
        end
    end
    hold off;
    fprintf('\n')
    
	% Process gathered data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
    f = [f1 f2 f3 f4];
    
    % Plot data
    plotData(f);
    
    % Evaluate
%    calculateCorrelation(f);
    calculateProximityDependency(f);
end

function calculateProximityDependency(components)
% CALCULATEPROXIMITYDEPENDENCY computes the percentage of proximity dependencies.
% The calculated percentage expresses how much of data from some monitor is "close"
% after filtering them by data from another monitor. The filtering takes the data
% sampled in time when the data used for the filtering condition were "close" according
% to the related monitor. The result is printed into the output.
    posMonitor = PositionMonitor(5); % The input parameter specifies the boundary of closeness
    tempMonitor = TemperatureMonitor(15);
    
	% The position monitor is used for data filtering and the temperature monitor is used
	% to calculate the percentage (dependency).
    [closePercentage, farPercentage, closeMean, closeStd, farMean, farStd] = ...
        posMonitor.calculateProximityStats(components, tempMonitor);

    fprintf('\nProximity Dependencies: position -> temperature\n');    
    fprintf('Close dependencies: %0.3f\n', closePercentage);
    fprintf('Far dependencies: %0.3f\n', farPercentage);
    fprintf('Close mean: %3f\n', closeMean);
    fprintf('Close standard deviation: %3f\n', closeStd);
    fprintf('Far mean: %3f\n', farMean);
    fprintf('Far standard deviation: %3f\n', farStd);
    
end

function calculateCorrelation(components)
% CALCULATECORRELATION computes the correlation pairwise for the components
% between each of theirs data. The correlation is computed in segments. That
% means the result correlation for one data vector is not a single number, but
% a vector of correlation numbers that relates to the original data splitted
% into segments of fixed length. The result is printed into the output.
    disp('Correlation');
    for labelCell = components(1).getDataFieldLabels() % Compute the correlation for all the data vectors
        label = labelCell{1};
        for i = 1:size(components,2) % Get all the combinations of the component pairs - Component 1
            c1 = components(i);
            for j = (i+1):size(components,2) % Get all the combination of the component pairs - Component 2
                c2 = components(j);
                correlations = CorrelationCalculator.segmentCorrelations( ...
                c1.getDataFieldHistory(label), ...
                c2.getDataFieldHistory(label));
                fprintf('%s x %s - %s:\n', c1.Name, c2.Name, label);
                fprintf('%0.3f  ', correlations);
                fprintf('\n');
            end
        end
    end

end

function plotData(components)
% PLOTDATA creates a figure for each data vector in the given components.
% The input parameter is an array of components of the same type. The labels
% of the data vectors are taken from the first component. Each figure shows
% the data of all the components for one of the labels.
    for labelCell = components(1).getDataFieldLabels() % Get the labels
        label = labelCell{1};
        figure
        title(label);
        hold all;
        for component = components
            plot(component.getDataFieldHistory(label)); % Plot the data of each component
        end
        hold off;
    end     

end













