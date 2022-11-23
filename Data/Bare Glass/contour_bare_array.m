% Analyzes the results from a several FDTD simulations
% filename = [filenamePrefix, variableArray, variableStringArray,
% variableUnitsArray, filenameSuffix];
% Change the filename in order to obtain different results
% 
% Copyright 2011
% Paul W. Leu 
% LAMP, University of Pittsburgh
clear;

%numThetaQuery = 91;
%load('InputVariables');

thetaValues = 0:2:80;
%phiValues = 0;

variableValues = {thetaValues};

%valueCombinations = VariableArray.value_combinations(variableValues)

variableNames = {'Theta'};
variableUnits = {'Deg'};

va1 = VariableArray(variableNames, variableUnits, thetaValues);
va2 = VariableArray(variableNames, variableUnits, thetaValues);
va1.create_filenames('Glass', 'TE');
va2.create_filenames('Glass', 'TM');

percent = 1;
cd('TE')
sra1 = FDTDSimulationResultsArray.create(va1, 'wavelength', percent);

cd('../TM/')
sra2 = FDTDSimulationResultsArray.create(va2, 'wavelength', percent);
cd('../')
sra1 = sra1.add_simulation_at_theta_90;
sra2 = sra2.add_simulation_at_theta_90;


ss = SolarSpectrum.direct_AM1p5;
ss = ss.truncate_spectrum_wavelength(280, 1200);
%idTE = IntegratedData(ss, sra1AvgPhi);
%idTM = IntegratedData(ss, sra2AvgPhi);

sraAvg = average_simulation_array(sra1, sra2);

id = IntegratedData.create_array(ss, sra1.Simulations);


figure(1);
clf;
%sraAvgPhi = sra.average_simulation_array_over_variable('Phi');
sra1 = sra1.mirror;
sra1.contour('Wavelength', 'Theta', 'Reflection',200,0, 'polar');
caxis([0 50]);
colorbar;
%caxis([0 100]);

figure(2);
clf;
%sraAvgPhi = sra.average_simulation_array_over_variable('Phi');
%sraAvgPhi = sraAvgPhi.mirror;
sra2 = sra2.mirror;
sra2.contour('Wavelength', 'Theta', 'Reflection',200,0, 'polar');
caxis([0 50]);
colorbar;
%caxis([0 100]);

figure(3);
clf;
sraAvgMirror = sraAvg.mirror;
sraAvgMirror.contour('Wavelength', 'Theta', 'Reflection',200,0, 'polar');
caxis([0 10]);
colorbar;


figure(4);
clf;
plot([thetaValues 90], [id.ReflectionIntegrated], 'g:');
hold on;
%load('NCRreflectionIntegrated.mat');

%plot(data(1,:), data(2,:), 'b--');


xlabel('Theta (deg)');
ylabel('R_{solar} (%)');

legend('Thin Film', 'Nanocone Array', 'Location', 'NorthWest');
legend boxoff;

axis([0 80 0 20]);

data = [thetaValues 90; id.ReflectionIntegrated]
save('GlassReflectionIntegrated', 'data');


figure(5);
clf;
sraAvg = average_simulation_array(sra1, sra2);

sraAvgWithPhi = sraAvg.symmetry360; % this should be corrected 
% varIndex = sraAvgWithPhi.VariableArray.get_variable_ind('Phi')
% sraAvgWithPhi = sraAvgWithPhi.symmetry45(varIndex); % this should be corrected 
% 
%id2 = IntegratedData.create_array(ss, sraAvgWithPhi.Simulations);

material = MaterialType.create('Si')
[scArrayWithPhi] = SolarCellArray.create(ss,...
      sraAvgWithPhi.Simulations, sraAvgWithPhi.VariableArray, material);
scArrayWithPhi.contour_solarCellArray('Theta', 'Phi', 'Reflection', 200, 0,...
  'polar', 'RadialTickSpacing', [30 60 90], 'PolarDirection', '180', 'RadLabels', 4, ...
  'radlabelcolor', 'white');

colorbar;
caxis([0 10]);

% 
% 
% material = MaterialType.create('Si')
% [scArrayWithPhi] = SolarCellArray.create(ss,...
%       sraAvgWithPhi.Simulations, sraAvgWithPhi.VariableArray, material);
% scArrayWithPhi.contour_solarCellArray('Theta', 'Phi', 'Reflection', 200, 0, 'polar', 'RadialTickSpacing', [30 60 90]);
% 
% colorbar;
% caxis([0 10]);
% 
%sra1.contour('Theta', 'Phi', 'Reflection',200,0, 'polar');




