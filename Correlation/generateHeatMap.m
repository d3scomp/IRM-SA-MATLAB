function heatMap = generateHeatMap

size = 512;
intensity = 40000000;

diskRadius = 200;

motionLen = 150;
motionTheta = 30;

map = zeros(size);

heatSpot1 = [size/4, size/4];
heatSpot2 = [size/2, 7/8 * size];

map(heatSpot1(1), heatSpot1(2)) = intensity;
map(heatSpot2(1), heatSpot2(2)) = 3/4 * intensity;

diskFilter = fspecial('disk', diskRadius);
diskMap = imfilter(map, diskFilter);

motionFilter = fspecial('motion', motionLen, motionTheta);
heatMap = imfilter(diskMap, motionFilter, 'replicate');

% figure
% colormap('hot');
% imagesc(heatMap);
% colorbar;
% title('Heat Map');

end