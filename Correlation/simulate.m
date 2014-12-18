function simulate

    animate = true;

    calendar = EventCalendar();

    % Configure the simulation
    
    rng(12345); % Seed the random number generator
    
    f1 = FireFighter('f1');
    f2 = FireFighter('f2');
    f3 = FireFighter('f3');
    f4 = FireFighter('f4');
    
    map = generateHeatMap();
    
    % Motion
    d1 = [250, 250];
    d2 = [300, 300];
    
    f1Move = FireFighterMoveProcess(f1, 1, map, d1);
    f1MoveEvent = Event(f1Move, 1);
    calendar.insert(f1MoveEvent);
    
    f1Move = FireFighterMoveProcess(f1, 1, map, d2);
    f1MoveEvent = Event(f1Move, 350);
    calendar.insert(f1MoveEvent);
    
    f2Move = FireFighterMoveProcess(f2, 1, map, d1);
    f2MoveEvent = Event(f2Move, 5);
    calendar.insert(f2MoveEvent);
    
    f3Move = FireFighterMoveProcess(f3, 1, map, d2);
    f3MoveEvent = Event(f3Move, 10);
    calendar.insert(f3MoveEvent);
    
    f3Move = FireFighterMoveProcess(f3, 1, map, d1);
    f3MoveEvent = Event(f3Move, 350);
    calendar.insert(f3MoveEvent);
    
    f4Move = FireFighterMoveProcess(f4, 1, map, d2);
    f4MoveEvent = Event(f4Move, 10);
    calendar.insert(f4MoveEvent);
    
    % Sampling
    f1Sample = FireFighterSampleProcess(f1, 0.1, map);
    f1SampleEvent = Event(f1Sample, 0);
    calendar.insert(f1SampleEvent);
    
    f2Sample = FireFighterSampleProcess(f2, 0.1, map);
    f2SampleEvent = Event(f2Sample, 0);
    calendar.insert(f2SampleEvent);
    
    f3Sample = FireFighterSampleProcess(f3, 0.1, map);
    f3SampleEvent = Event(f3Sample, 0);
    calendar.insert(f3SampleEvent);
    
    f4Sample = FireFighterSampleProcess(f4, 0.1, map);
    f4SampleEvent = Event(f4Sample, 0);
    calendar.insert(f4SampleEvent);

    % Simulate
    maxSteps = 30000;
    step = 0;
    
%    fprintf('Calendar: %d\n', size(calendar.Events,2));
    
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
        if(floor(progress) ~= floor((step/maxSteps)*100))
            progress = (step/maxSteps)*100;
            fprintf('\b\b\b\b');
            fprintf('%3.0f%%', progress);
        end
        if(animate && f1.HasMoved > 50)
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
    
    f = [f1 f2 f3 f4];
    
    % Plot data
    plotData(f);
    
    % Evaluate
    calculateCorrelation(f);
    calculateProximityDependency(f);
    
end

function calculateProximityDependency(components)

    posMonitor = PositionMonitor(5); % The input parameter specifies the boundary of closeness
    tempMonitor = TemperatureMonitor(15);
    
    [closePercentage, farPercentage, closeMean, closeStd, farMean, farStd] = ...
        posMonitor.calculateProximityStats(components, tempMonitor);

    fprintf('\nProximity Dependencies: positon -> temperature\n');    
    fprintf('Close dependencies: %0.3f\n', closePercentage);
    fprintf('Far dependencies: %0.3f\n', farPercentage);
    fprintf('Close mean: %3f\n', closeMean);
    fprintf('Close standard deviation: %3f\n', closeStd);
    fprintf('Far mean: %3f\n', farMean);
    fprintf('Far standard deviation: %3f\n', farStd);
    
end

function calculateCorrelation(components)

    disp('Correlation');
    for labelCell = components(1).getDataFieldLabels()
        label = labelCell{1};
        for i = 1:size(components,2)
            c1 = components(i);
            for j = (i+1):size(components,2)
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

    for labelCell = components(1).getDataFieldLabels()
        label = labelCell{1};
        figure
        title(label);
        hold all;
        for component = components
            plot(component.getDataFieldHistory(label));
        end
        hold off;
    end     

end













