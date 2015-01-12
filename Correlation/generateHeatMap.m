function heatMap = generateHeatMap
% Generate a heat map. The properties to configure the heat map generation
% are located in the beginning of this function.

	size = 512; % The number of rows and columns of the map
	intensity = 40000000; % The initial intensity of the heat before blurring

	diskRadius = 200; % The radius of a disk for first blurring

	motionLen = 150; % The length for the second (motion) blurring
	motionTheta = 30; % The angle for the second (motion) blurring

	map = zeros(size); % Initialize the map

	heatSpot1 = [size/4, size/4]; % The position of the first heat spot
	heatSpot2 = [size/2, 7/8 * size]; % The position of the second heat spot

	map(heatSpot1(1), heatSpot1(2)) = intensity; % Seed the first heat spot
	map(heatSpot2(1), heatSpot2(2)) = 3/4 * intensity; % Seed the second heat spot

	diskFilter = fspecial('disk', diskRadius);
	diskMap = imfilter(map, diskFilter); % Blur the heat spots

	motionFilter = fspecial('motion', motionLen, motionTheta);
	heatMap = imfilter(diskMap, motionFilter, 'replicate'); % Blur the map again

	% figure
	% colormap('hot');
	% imagesc(heatMap);
	% colorbar;
	% title('Heat Map');

end