%% Flow5 4D Asymmetric Aerodynamic Database Script Generator
clear; clc;

% --- Define the Independent Simulink Digital Twin Grid ---
aoa_range = -5:2:15;       % Angle of Attack grid (11 steps)
f1_range  = -10:5:10;      % Left Outer Flap 1 (5 steps: -10, -5, 0, 5, 10)
f2_range  = -10:5:10;      % Left Inner Flap 2 (5 steps)
f5_range  = -10:5:10;      % Right Inner Flap 5 (5 steps)
f6_range  = -10:5:10;      % Right Outer Flap 6 (5 steps)

total_points = length(aoa_range) * length(f1_range) * length(f2_range) * length(f5_range) * length(f6_range);
fprintf('Generating XML script with %d permutations...\n', total_points);

xml_filename = 'flow5_batch_run.xml';
fid = fopen(xml_filename, 'w');

% --- Write Standardized Flow5 XML Script Format ---
fprintf(fid, '<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fid, '<xflr5_polar version="1.0">\n');
fprintf(fid, '  <polar>\n');
fprintf(fid, '    <name>Simulink_4Flap_Twin</name>\n');
fprintf(fid, '    <plane_name>Joe Biden</plane_name>\n'); % Must match your plane name exactly
fprintf(fid, '    <type>1</type>\n'); % Type 1 Polar
fprintf(fid, '    <op_list>\n');

% --- Deep Asymmetric Nested Traversal ---
for a = 1:length(aoa_range)
    current_aoa = aoa_range(a);
    for i = 1:length(f1_range)
        current_f1 = f1_range(i);
        for j = 1:length(f2_range)
            current_f2 = f2_range(j);
            for k = 1:length(f5_range)
                current_f5 = f5_range(k);
                for l = 1:length(f6_range)
                    current_f6 = f6_range(l);
                    
                    % Format structured exactly for Flow5 Operating Points
                    fprintf(fid, '      <operating_point>\n');
                    fprintf(fid, '        <alpha unit="deg">%.2f</alpha>\n', current_aoa);
                    fprintf(fid, '        <beta unit="deg">0.00</beta>\n');
                    fprintf(fid, '        <control_deflection name="Harris_flap_1" value="%.2f"/>\n', current_f1);
                    fprintf(fid, '        <control_deflection name="Harris_flap_2" value="%.2f"/>\n', current_f2);
                    fprintf(fid, '        <control_deflection name="Harris_flap_5" value="%.2f"/>\n', current_f5);
                    fprintf(fid, '        <control_deflection name="Harris_flap_6" value="%.2f"/>\n', current_f6);
                    fprintf(fid, '      </operating_point>\n');
                end
            end
        end
    end
end

fprintf(fid, '    </op_list>\n');
fprintf(fid, '  </polar>\n');
fprintf(fid, '</xflr5_polar>\n');
fclose(fid);

fprintf('Complete! "%s" generated successfully.\n', xml_filename);