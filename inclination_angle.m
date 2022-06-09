function IA = inclination_angle(name, path, coordination)

    %% store COP datat
    FP1_data = name.Force(1).COP;
    FP2_data = name.Force(2).COP;
    FP3_data = name.Force(3).COP;
    FP4_data = name.Force(4).COP;
    FP5_data = name.Force(5).COP;
    FP6_data = name.Force(6).COP;
    FP7_data = name.Force(7).COP;


    % store force data
    FP1_data_Force = name.Force(1).Force;
    FP2_data_Force = name.Force(2).Force;
    FP3_data_Force = name.Force(3).Force;
    FP4_data_Force = name.Force(4).Force;
    FP5_data_Force = name.Force(5).Force;
    FP6_data_Force = name.Force(6).Force;
    FP7_data_Force = name.Force(7).Force;

    data_len = length(FP1_data);
    FP = zeros(6, data_len);

    % corresponding time
    frq = length(FP1_data) / length(name.Trajectories.Labeled.Data(26,1,:));
    time = data_len / frq;

    % form the COP matrix for 6 force plate

    FP1_xyz = FP1_data(:,(1:frq:length(FP1_data)));
    FP2_xyz = FP2_data(:,(1:frq:length(FP2_data)));
    FP3_xyz = FP3_data(:,(1:frq:length(FP3_data)));
    FP4_xyz = FP4_data(:,(1:frq:length(FP4_data)));
    FP5_xyz = FP5_data(:,(1:frq:length(FP5_data)));
    FP6_xyz = FP6_data(:,(1:frq:length(FP6_data)));
    FP7_xyz = FP7_data(:,(1:frq:length(FP7_data)));



    % form the force matrix for 6 force plate
    FP1_xyz_Force = FP1_data_Force(:,(1:frq:length(FP1_data)));
    FP2_xyz_Force = FP2_data_Force(:,(1:frq:length(FP2_data)));
    FP3_xyz_Force = FP3_data_Force(:,(1:frq:length(FP3_data)));
    FP4_xyz_Force = FP4_data_Force(:,(1:frq:length(FP4_data)));
    FP5_xyz_Force = FP5_data_Force(:,(1:frq:length(FP5_data)));
    FP6_xyz_Force = FP6_data_Force(:,(1:frq:length(FP6_data)));
    FP7_xyz_Force = FP7_data_Force(:,(1:frq:length(FP7_data)));

    %% Calculate the COM
    %%%find the marker
    LPSI_position = find(strcmp( path, 'LPSI'));
    RPSI_position = find(strcmp( path, 'RPSI'));
    LASI_position = find(strcmp( path, 'LASI'));
    RASI_position = find(strcmp( path, 'RASI'));
    LSHO_position = find(strcmp( path, 'LSHO'));
    RSHO_position = find(strcmp( path, 'RSHO'));
    LELL_position = find(strcmp( path, 'LELL'));
    RELL_position = find(strcmp( path, 'RELL'));
    LWRR_position = find(strcmp( path, 'LWRR'));
    RWRR_position = find(strcmp( path, 'RWRR'));
    LFLE_position = find(strcmp( path, 'LFLE'));
    RFLE_position = find(strcmp( path, 'RFLE'));
    LLMAL_position = find(strcmp( path, 'LLMAL'));
    RLMAL_position = find(strcmp( path, 'RLMAL'));


    %%
    % 1: anterior-posterior, 2: medial-lateral, 3: up and down
    LPSI_data = name.Trajectories.Labeled.Data(LPSI_position,1:3,:);
    RPSI_data = name.Trajectories.Labeled.Data(RPSI_position,1:3,:);
    LASI_data = name.Trajectories.Labeled.Data(LASI_position,1:3,:);
    RASI_data = name.Trajectories.Labeled.Data(RASI_position,1:3,:);
    LSHO_data = name.Trajectories.Labeled.Data(LSHO_position,1:3,:);
    RSHO_data = name.Trajectories.Labeled.Data(RSHO_position,1:3,:);
    LELL_data = name.Trajectories.Labeled.Data(LELL_position,1:3,:);
    RELL_data = name.Trajectories.Labeled.Data(RELL_position,1:3,:);
    %LWRR_data = name.Trajectories.Labeled.Data(LWRR_position,1:3,:);
    %RWRR_data = name.Trajectories.Labeled.Data(RWRR_position,1:3,:);
    LFLE_data = name.Trajectories.Labeled.Data(LFLE_position,1:3,:);
    RFLE_data = name.Trajectories.Labeled.Data(RFLE_position,1:3,:);
    LLMAL_data = name.Trajectories.Labeled.Data(LLMAL_position,1:3,:);
    RLMAL_data = name.Trajectories.Labeled.Data(RLMAL_position,1:3,:);

    %%
    LPSI_data = reshape(LPSI_data, [3, time]);
    RPSI_data = reshape(RPSI_data, [3,time]);
    LASI_data = reshape(LASI_data, [3,time]);
    RASI_data = reshape(RASI_data, [3,time]);
    LSHO_data = reshape(LSHO_data, [3,time]);
    RSHO_data = reshape(RSHO_data, [3,time]);
    LELL_data = reshape(LELL_data, [3,time]);
    RELL_data = reshape(RELL_data, [3,time]);
    %LWRR_data = reshape(LWRR_data, [3,time]);
    %RWRR_data = reshape(RWRR_data, [3,time]);
    LFLE_data = reshape(LFLE_data, [3,time]);
    RFLE_data = reshape(RFLE_data, [3,time]);
    LLMAL_data = reshape(LLMAL_data, [3,time]);
    RLMAL_data = reshape(RLMAL_data, [3,time]);


    %%
    LASI = LASI_data;
    LPSI = LPSI_data;
    RASI = RASI_data;
    RPSI = RPSI_data;

    % calculate the hip marker position
    [hip_center, L_hip_center, R_hip_center] = hip_markers(LASI, LPSI, RASI, RPSI);

    % store the position data from each marker
    L_shoulder  = LSHO_data;
    R_shoulder  = RSHO_data;
    L_elbow     = LELL_data;
    R_elbow     = RELL_data;
    L_hand      = "missing_marker";
    R_hand	    = "missing_marker";
    L_knee	    = LFLE_data;
    R_knee      = RFLE_data;
    L_ankle	    = LLMAL_data;
    R_ankle     = RLMAL_data;
    hip_center = hip_center;
    L_hip_center = L_hip_center;
    R_hip_center = R_hip_center;


    New_COM = COM_function(time, L_shoulder, R_shoulder, L_elbow, R_elbow, L_hand, R_hand, L_knee, R_knee, L_ankle, R_ankle,hip_center, L_hip_center, R_hip_center, 1);
    %%%%%%%%%%%%%%%  filter stepping force platform  %%%%%%%%%%%%%%%
    force_plat_data = zeros(7, length(FP4_xyz(1,:)));
    force_plat_data(1,:) = FP1_xyz(coordination,:);
    force_plat_data(2,:) = FP2_xyz(coordination,:);
    force_plat_data(3,:) = FP3_xyz(coordination,:);
    force_plat_data(4,:) = FP4_xyz(coordination,:);
    force_plat_data(5,:) = FP5_xyz(coordination,:);
    force_plat_data(6,:) = FP6_xyz(coordination,:);
    force_plat_data(7,:) = FP7_xyz(coordination,:);

    force_plat_forcedata = zeros(7, length(FP4_xyz(1,:)));
    force_plat_forcedata(1,:) = FP1_xyz_Force(3,:);
    force_plat_forcedata(2,:) = FP2_xyz_Force(3,:);
    force_plat_forcedata(3,:) = FP3_xyz_Force(3,:);
    force_plat_forcedata(4,:) = FP4_xyz_Force(3,:);
    force_plat_forcedata(5,:) = FP5_xyz_Force(3,:);
    force_plat_forcedata(6,:) = FP6_xyz_Force(3,:);
    force_plat_forcedata(7,:) = FP7_xyz_Force(3,:);


    force_plat_identification = zeros(7, length(FP4_xyz(1,:)));
    force_plat_identification(1,:) = FP1_xyz(1,:);
    force_plat_identification(2,:) = FP2_xyz(1,:);
    force_plat_identification(3,:) = FP3_xyz(1,:);
    force_plat_identification(4,:) = FP4_xyz(1,:);
    force_plat_identification(5,:) = FP5_xyz(1,:);
    force_plat_identification(6,:) = FP6_xyz(1,:);
    force_plat_identification(7,:) = FP7_xyz(1,:);

    force_plat_valid_signal = zeros(1,length(FP4_xyz(1,:)));
    force_data = zeros(1,length(FP4_xyz(1,:)));
    count = 1;
    for i = 1:7
        if std(force_plat_identification(i,:)) > 100
            force_plat_valid_signal(count, :) = force_plat_data(i,:);
            force_data(count, :) = force_plat_forcedata(i, :);
            count = count + 1;
        end
    end
    %% COP Processing
    for i = 1:size(force_plat_valid_signal,1)

        for ii = 1:size(force_plat_valid_signal,2)
            if abs(force_data(i,ii)) > 10 %(10~50)
                x = force_plat_valid_signal(i,ii);     
            else
                x = 0;
            end
            y(i, ii) = x;
        end
    end



    if size(force_plat_valid_signal, 1) == 3
        for i = 1:size(y,2)
            if y(1,i) ~= 0 && y(2,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(2,i)*force_data(2,i)) / (force_data(1,i) + force_data(2,i));
            elseif y(1,i) ~= 0 && y(3,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(3,i)*force_data(3,i)) / (force_data(1,i) + force_data(3,i));
            elseif y(2,i) ~= 0 && y(3,i) ~= 0
                value = (y(2,i)*force_data(2,i) + y(3,i)*force_data(3,i)) / (force_data(2,i) + force_data(3,i));
            elseif y(1,i) ~= 0 && y(2,i) == 0 && y(3,i) == 0
                value = y(1,i);
            elseif y(1,i) == 0 && y(2,i) ~= 0 && y(3,i) == 0
                value = y(2,i);
            elseif y(1,i) == 0 && y(2,i) == 0 && y(3,i) ~= 0
                value = y(3,i);
            else
                value = 0;
            end
            final_cop(i) = value;
        end

    elseif size(force_plat_valid_signal, 1) == 2
        for i = 1:size(y,2)
            if y(1,i) ~= 0 && y(2,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(2,i)*force_data(2,i)) / (force_data(1,i) + force_data(2,i));
            elseif y(1,i) ~= 0 && y(2,i) == 0 
                value = y(1,i);
            elseif y(1,i) == 0 && y(2,i) ~= 0 
                value = y(2,i);
            else
                value = 0;
            end
            final_cop(i) = value;

        end 


    elseif size(force_plat_valid_signal, 1) == 4
        for i = 1:size(y,2)
            if y(1,i) ~= 0 && y(2,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(2,i)*force_data(2,i)) / (force_data(1,i) + force_data(2,i));
            elseif y(1,i) ~= 0 && y(3,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(3,i)*force_data(3,i)) / (force_data(1,i) + force_data(3,i));
            elseif y(2,i) ~= 0 && y(3,i) ~= 0
                value = (y(2,i)*force_data(2,i) + y(3,i)*force_data(3,i)) / (force_data(2,i) + force_data(3,i));
            elseif y(1,i) ~= 0 && y(4,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(4,i)*force_data(4,i)) / (force_data(1,i) + force_data(4,i));
            elseif y(2,i) ~= 0 && y(4,i) ~= 0
                value = (y(2,i)*force_data(2,i) + y(4,i)*force_data(4,i)) / (force_data(2,i) + force_data(4,i));
            elseif y(3,i) ~= 0 && y(4,i) ~= 0
                value = (y(3,i)*force_data(3,i) + y(4,i)*force_data(4,i)) / (force_data(3,i) + force_data(4,i));    

            elseif y(1,i) ~= 0 && y(2,i) == 0 && y(3,i) == 0 && y(4,i) == 0
                value = y(1,i);
            elseif y(1,i) == 0 && y(2,i) ~= 0 && y(3,i) == 0 && y(4,i) == 0
                value = y(2,i);
            elseif y(1,i) == 0 && y(2,i) == 0 && y(3,i) ~= 0 && y(4,i) == 0
                value = y(3,i);
            elseif y(1,i) == 0 && y(2,i) == 0 && y(3,i) == 0 && y(4,i) ~= 0
                value = y(4,i);
            else
                value = 0;
            end
            final_cop(i) = value;
        end

    elseif size(force_plat_valid_signal, 1) == 5
        for i = 1:size(y,2)
            if y(1,i) ~= 0 && y(2,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(2,i)*force_data(2,i)) / (force_data(1,i) + force_data(2,i));
            elseif y(1,i) ~= 0 && y(3,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(3,i)*force_data(3,i)) / (force_data(1,i) + force_data(3,i));
            elseif y(1,i) ~= 0 && y(4,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(4,i)*force_data(4,i)) / (force_data(1,i) + force_data(4,i));
            elseif y(1,i) ~= 0 && y(5,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(5,i)*force_data(5,i)) / (force_data(1,i) + force_data(5,i));

            elseif y(2,i) ~= 0 && y(3,i) ~= 0
                value = (y(2,i)*force_data(2,i) + y(3,i)*force_data(3,i)) / (force_data(2,i) + force_data(3,i));
            elseif y(2,i) ~= 0 && y(4,i) ~= 0
                value = (y(2,i)*force_data(2,i) + y(4,i)*force_data(4,i)) / (force_data(2,i) + force_data(4,i));
            elseif y(2,i) ~= 0 && y(5,i) ~= 0
                value = (y(2,i)*force_data(2,i) + y(5,i)*force_data(4,i)) / (force_data(2,i) + force_data(5,i));

            elseif y(3,i) ~= 0 && y(4,i) ~= 0
                value = (y(3,i)*force_data(3,i) + y(4,i)*force_data(4,i)) / (force_data(3,i) + force_data(4,i));
            elseif y(3,i) ~= 0 && y(5,i) ~= 0
                value = (y(3,i)*force_data(3,i) + y(5,i)*force_data(5,i)) / (force_data(3,i) + force_data(5,i)); 

            elseif y(4,i) ~= 0 && y(5,i) ~= 0
                value = (y(4,i)*force_data(4,i) + y(5,i)*force_data(5,i)) / (force_data(4,i) + force_data(5,i)); 

            elseif y(1,i) ~= 0 && y(2,i) == 0 && y(3,i) == 0 && y(4,i) == 0
                value = y(1,i);
            elseif y(1,i) == 0 && y(2,i) ~= 0 && y(3,i) == 0 && y(4,i) == 0
                value = y(2,i);
            elseif y(1,i) == 0 && y(2,i) == 0 && y(3,i) ~= 0 && y(4,i) == 0
                value = y(3,i);
            elseif y(1,i) == 0 && y(2,i) == 0 && y(3,i) == 0 && y(4,i) ~= 0
                value = y(4,i);

            elseif y(1,i) ~= 0 && y(2,i) == 0 && y(3,i) == 0 && y(4,i) == 0 && y(5,i) == 0
                value = y(1,i);
            elseif y(1,i) == 0 && y(2,i) ~= 0 && y(3,i) == 0 && y(4,i) == 0 && y(5,i) == 0
                value = y(2,i);
            elseif y(1,i) == 0 && y(2,i) == 0 && y(3,i) ~= 0 && y(4,i) == 0 && y(5,i) == 0
                value = y(3,i);
            elseif y(1,i) == 0 && y(2,i) == 0 && y(3,i) == 0 && y(4,i) ~= 0 && y(5,i) == 0
                value = y(4,i);
            elseif y(1,i) == 0 && y(2,i) == 0 && y(3,i) == 0 && y(4,i) ~= 0 && y(5,i) == 0
                value = y(5,i);


            else
                value = 0;
            end
            final_cop(i) = value;
        end
    elseif size(force_plat_valid_signal, 1) == 6
        for i = 1:size(y,2)
            if y(1,i) ~= 0 && y(2,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(2,i)*force_data(2,i)) / (force_data(1,i) + force_data(2,i));
            elseif y(1,i) ~= 0 && y(3,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(3,i)*force_data(3,i)) / (force_data(1,i) + force_data(3,i));
            elseif y(1,i) ~= 0 && y(4,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(4,i)*force_data(4,i)) / (force_data(1,i) + force_data(4,i));
            elseif y(1,i) ~= 0 && y(5,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(5,i)*force_data(5,i)) / (force_data(1,i) + force_data(5,i));
            elseif y(1,i) ~= 0 && y(6,i) ~= 0
                value = (y(1,i)*force_data(1,i) + y(6,i)*force_data(6,i)) / (force_data(1,i) + force_data(6,i));

            elseif y(2,i) ~= 0 && y(3,i) ~= 0
                value = (y(2,i)*force_data(2,i) + y(3,i)*force_data(3,i)) / (force_data(2,i) + force_data(3,i));
            elseif y(2,i) ~= 0 && y(4,i) ~= 0
                value = (y(2,i)*force_data(2,i) + y(4,i)*force_data(4,i)) / (force_data(2,i) + force_data(4,i));
            elseif y(2,i) ~= 0 && y(5,i) ~= 0
                value = (y(2,i)*force_data(2,i) + y(5,i)*force_data(5,i)) / (force_data(2,i) + force_data(5,i));
            elseif y(2,i) ~= 0 && y(6,i) ~= 0
                value = (y(2,i)*force_data(2,i) + y(6,i)*force_data(6,i)) / (force_data(2,i) + force_data(6,i));

            elseif y(3,i) ~= 0 && y(4,i) ~= 0
                value = (y(3,i)*force_data(3,i) + y(4,i)*force_data(4,i)) / (force_data(3,i) + force_data(4,i));
            elseif y(3,i) ~= 0 && y(5,i) ~= 0
                value = (y(3,i)*force_data(3,i) + y(5,i)*force_data(5,i)) / (force_data(3,i) + force_data(5,i)); 
            elseif y(3,i) ~= 0 && y(6,i) ~= 0
                value = (y(3,i)*force_data(3,i) + y(6,i)*force_data(6,i)) / (force_data(3,i) + force_data(6,i)); 

            elseif y(4,i) ~= 0 && y(5,i) ~= 0
                value = (y(4,i)*force_data(4,i) + y(5,i)*force_data(5,i)) / (force_data(4,i) + force_data(5,i)); 
            elseif y(4,i) ~= 0 && y(6,i) ~= 0
                value = (y(4,i)*force_data(4,i) + y(6,i)*force_data(6,i)) / (force_data(4,i) + force_data(6,i)); 

            elseif y(5,i) ~= 0 && y(6,i) ~= 0
                value = (y(5,i)*force_data(5,i) + y(6,i)*force_data(6,i)) / (force_data(5,i) + force_data(6,i)); 


            elseif y(1,i) ~= 0 && y(2,i) == 0 && y(3,i) == 0 && y(4,i) == 0 && y(5,i) == 0 && y(6,i) == 0
                value = y(1,i);
            elseif y(1,i) == 0 && y(2,i) ~= 0 && y(3,i) == 0 && y(4,i) == 0 && y(5,i) == 0 && y(6,i) == 0
                value = y(2,i);
            elseif y(1,i) == 0 && y(2,i) == 0 && y(3,i) ~= 0 && y(4,i) == 0 && y(5,i) == 0 && y(6,i) == 0
                value = y(3,i);
            elseif y(1,i) == 0 && y(2,i) == 0 && y(3,i) == 0 && y(4,i) ~= 0 && y(5,i) == 0 && y(6,i) == 0
                value = y(4,i);
            elseif y(1,i) == 0 && y(2,i) == 0 && y(3,i) == 0 && y(4,i) == 0 && y(5,i) ~= 0 && y(6,i) == 0
                value = y(5,i);
            elseif y(1,i) == 0 && y(2,i) == 0 && y(3,i) == 0 && y(4,i) == 0 && y(5,i) == 0 && y(6,i) ~= 0
                value = y(6,i);


            else
                value = 0;
            end
            final_cop(i) = value;
        end


    end



    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%  IA calculation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    IA = nan(size(force_plat_valid_signal, 1), length(force_plat_valid_signal));

    for i = 1:length(final_cop)
        if abs(final_cop(i)) > 0
            ia(i) =  (final_cop(i)-New_COM(coordination,i))/New_COM(3,i);
        else
            ia(i) =  nan;
        end
    end
    IA = atand(ia);
end