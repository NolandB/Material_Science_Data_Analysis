%Material Evaluation by Beau Noland

%Manual Adjust Values
area = 0.000005;  
length = 0.03;  
threshold1 = 5; %Increment of jump in force
threshold2 = 0.0001; %Search for stalls
threshold3 = 20000000; %Search for Youngs values

%Load table
data = HT0test2{:,:}; 
extensometer = data(:, 2);         
force = str2double(data(:, 3));      
global_disp = str2double(data(:, 4));
global_disp = global_disp./1000;
disp('Data loaded successfully.');

% Cropping Data
start_index = find(force > 0 & [0; diff(force)] >= threshold1, 1, 'first');
if isempty(start_index)
    error('No starting point found where force becomes positive and increases by 5.');
end
cropped_data = [extensometer(start_index:end), force(start_index:end), global_disp(start_index:end)];
disp(['First crop completed. Starting from row: ', num2str(start_index)]);
cropped_data_numeric = str2double(cropped_data);
stall_indices = find(abs(diff(cropped_data_numeric(:, 3))) < threshold2);
if ~isempty(stall_indices)
    stall_indices = stall_indices + 1; 
    cropped_data_numeric(stall_indices, :) = [];
    disp(['Second crop completed. Stalling detected at rows: ', num2str(stall_indices')]);
else
    disp('No stalling detected in global displacement.');
end


force_diff = diff(cropped_data_numeric(:, 2)); % Column 2: Force differences
drop_index = find(force_diff < -max(force_diff) * 0.8, 1, 'first'); % Dramatic drop threshold
if ~isempty(drop_index)
    cropped_data_numeric = cropped_data_numeric(1:drop_index, :);
    disp(['Third crop completed. Dramatic force drop detected at row: ', num2str(drop_index)]);
else
    disp('No dramatic force drop detected.');
end

%Data analysis
stress = cropped_data_numeric(:, 2) / area;  
strain = cropped_data_numeric(:, 3) / length; 
strain_ext = cropped_data_numeric(:, 1)/length;

stress_diff = diff(stress);
elastic_indices = find(stress_diff > threshold3);
elastic_indices = unique([elastic_indices, elastic_indices + 1]);

stress_elastic = stress(elastic_indices);
strain_elastic = strain(elastic_indices);
strain_elastic_ext = strain_ext(elastic_indices);

ym1 = polyfit(strain_elastic, stress_elastic, 1);
ym2 = polyfit(strain_elastic_ext, stress_elastic, 1);
ym = ym1(1);
ym_ext = ym2(1);
disp(['Youngs Modulus using Global Displacement: ', num2str(ym)])
disp(['Youngs Modulus using Extensometer Data: ', num2str(ym_ext)])

ymx = strain.*1.02; 
ymy = ym1(1) * ymx + ym1(2);
minys = find(strain==strain_elastic(end));
diffym = abs(abs(stress(minys:end))-abs(ymy(minys:end)));
liney = linspace(min(stress), max(stress) ,100);
linex = (1/ym1(1))*(liney-ym1(2));

indy = min(diffym);
indys = find(diffym==indy);
disp(['Yeild strength: ', num2str(ymy(indys+minys))])
disp(['Max Tensile Strength: ', num2str(max(stress))])

% Plot the filtered data
figure;
hold on;
plot(strain, stress, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Original Data');
plot(strain_elastic, stress_elastic, 'rs-', 'LineWidth', 3, 'DisplayName', 'Elastic Region');
plot(linex, liney, 'r-', 'LineWidth', 2, 'DisplayName', 'Elastic Region');

xlabel('Strain');
ylabel('Stress (Pa)');
title('Elastic Portion of Stress-Strain Global Displacement Data');
legend('Location', 'Best');
hold off

figure;
hold on
plot(strain_ext(1:stall_indices(2)), stress(1:stall_indices(2)), '-o', 'LineWidth', 2, 'MarkerSize', 6);
xlabel('Strain');
ylabel('Stress (Pa)');
title('Stress vs. Strain on Extensometer');
grid on;
