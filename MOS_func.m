function [AP_MoS_all, AP_MoS_DS, AP_MoS_SS, ML_MoS_all, ML_MoS_DS, ML_MoS_SS] = MOS_func(name, path, time)
    %% COM calculation
    %%% Calculate the COM
    %%%find the marker

    LPSI_position = find(strcmp( path, 'LPSI'));
    RPSI_position = find(strcmp( path, 'RPSI'));
    LASI_position = find(strcmp( path, 'LASI'));
    RASI_position = find(strcmp( path, 'RASI'));
    LSHO_position = find(strcmp( path, 'LSHO'));
    RSHO_position = find(strcmp( path, 'RSHO'));
    LELL_position = find(strcmp( path, 'LELL'));
    RELL_position = find(strcmp( path, 'RELL'));
    %LWRR_position = find(strcmp( path, 'LWRR'));
    %RWRR_position = find(strcmp( path, 'RWRR'));
    LFLE_position = find(strcmp( path, 'LFLE'));
    RFLE_position = find(strcmp( path, 'RFLE'));
    LLMAL_position = find(strcmp( path, 'LLMAL'));
    RLMAL_position = find(strcmp( path, 'RLMAL'));


    %%%
    %coordination = 2 ;% 1: anterior-posterior, 2: medial-lateral, 3: up and down
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


    %%%
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


    %%%
    LASI = LASI_data;
    LPSI = LPSI_data;
    RASI = RASI_data;
    RPSI = RPSI_data;

    [hip_center, L_hip_center, R_hip_center] = hip_markers(LASI, LPSI, RASI, RPSI);

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
    %% XCOM
    % w0 = sqrt(g / l)
    % xCOM = COM + Vcom / w0
    % l = pendulum length, leg length
    COM = New_COM ./ 1000;
    dt = 1 / 200;


    %%% the code below is to form the velocity data in different axis for different marker
    % SHO = axis_v_data(1,:), ELL = axis_v_data(2,:), ELM = axis_v_data(3,:), WRR = axis_v_data(4,:), WRU = axis_v_data(5,:)


    x_v_data = zeros(1, time );
    for i = 1:(time-1)
        x_v_data(1,i) = ((COM(1, i+1) - COM(1, i)) / dt);
    end


    y_v_data = zeros(1, time );
    for i = 1:(time-1)
        y_v_data(1,i) = ((COM(2, i+1) - COM(2, i)) / dt);
    end

    z_v_data = zeros(1, time );
    for i = 1:(time-1)
        z_v_data(1,i) = ((COM(3, i+1) - COM(3, i)) / dt);
    end

    total = zeros(3,time);
    for i = 1:(time-1)
        total(1,i) = x_v_data(1,i);
        total(2,i) = y_v_data(1,i);
        total(3,i) = z_v_data(1,i);
    end

    % plot the velocity
    %plot(total(1,:))
    %hold on 
    % plot the trajectory
    %plot(WRR(3,:))


    duration = 10;
    g = 9.81;
    l = (nanmean(COM(3,:)));
    w0 = sqrt( g / l);
    Vcom = x_v_data(1,:);
    XCOM = (COM) + (total/ w0);

    %% Marker information (position and velocity
    RCAL1_position = find(strcmp( path, 'RCAL1'));
    RCAL1_data = name.Trajectories.Labeled.Data(RCAL1_position,1,:);
    RCAL1_data = reshape(RCAL1_data, [1, time]);
    RCAL1_height = name.Trajectories.Labeled.Data(RCAL1_position,3,:);
    RCAL1_height = reshape(RCAL1_height, [1, time]);

    LCAL1_position = find(strcmp( path, 'LCAL1'));
    LCAL1_data = name.Trajectories.Labeled.Data(LCAL1_position,1,:);
    LCAL1_data = reshape(LCAL1_data, [1, time]);
    LCAL1_height = name.Trajectories.Labeled.Data(LCAL1_position,3,:);
    LCAL1_height = reshape(LCAL1_height, [1, time]);

    RDM2_position = find(strcmp( path, 'RDM2'));
    RDM2_data = name.Trajectories.Labeled.Data(RDM2_position,1,:);
    RDM2_data = reshape(RDM2_data, [1, time]);
    RDM2_height = name.Trajectories.Labeled.Data(RDM2_position,3,:);
    RDM2_height = reshape(RDM2_height, [1, time]);

    LDM2_position = find(strcmp( path, 'LDM2'));
    LDM2_data = name.Trajectories.Labeled.Data(LDM2_position,1,:);
    LDM2_data = reshape(LDM2_data, [1, time]);
    LDM2_height = name.Trajectories.Labeled.Data(LDM2_position,3,:);
    LDM2_height = reshape(LDM2_height, [1, time]);

    marker_trajectory = RCAL1_data;
    RCAL1_data_velocity_result = abs(velocity_func(marker_trajectory))/10;
    marker_trajectory = LCAL1_data;
    LCAL1_data_velocity_result = abs(velocity_func(marker_trajectory))/10;
    marker_trajectory = RDM2_data;
    RDM2_data_velocity_result = abs(velocity_func(marker_trajectory))/10;
    marker_trajectory = LDM2_data;
    LDM2_data_velocity_result = abs(velocity_func(marker_trajectory))/10;

    %% Identification of the event
    velocity_threshold = 100;
    CAL1_position_threshold = 30;
    DM2_position_threshold = 40;
    %%% Heel Strike to before foot flat (HS_BFF) %%%
    %%% velocity of L(R)CAL1 below velocity_threshold  
    %%% velocity of R(L)CAL1 above velocity_threshold  
    %%% velocity of R(L)DM2 below velocity_threshold   
    %%% velocity of L(R)DM2 above velocity_threshold   
    %%% L(R)CAL1 below CAL1_position_threshold                 
    %%% R(L)CAL1 above CAL1_position_threshold                 
    %%% R(L)DM2 below DM2_position_threshold                  
    %%% L(R)DM2 above DM2_position_threshold                  

    %Velocity rules
    %RCAL1_data_velocity_result(i,1) < velocity_threshold && LCAL1_data_velocity_result(i,1) > velocity_threshold && RDM2_data_velocity_result(i,1) < velocity_threshold && LDM2_data_velocity_result(i,1) > velocity_threshold 
    %LCAL1_data_velocity_result(i,1) < velocity_threshold && RCAL1_data_velocity_result(i,1) > velocity_threshold && LDM2_data_velocity_result(i,1) < velocity_threshold && RDM2_data_velocity_result(i,1) > velocity_threshold

    %Position rules
    %LCAL1_height(1, i) < CAL1_position_threshold && RCAL1_height(1, i) > CAL1_position_threshold && RDM2_height(1, i) < DM2_position_threshold && LDM2_height(1, i) > DM2_position_threshold
    %RCAL1_height(1, i) < CAL1_position_threshold && LCAL1_height(1, i) > CAL1_position_threshold && LDM2_height(1, i) < DM2_position_threshold && RDM2_height(1, i) > DM2_position_threshold


    for i = 1:time
        if LCAL1_height(1, i) < CAL1_position_threshold && RCAL1_height(1, i) > CAL1_position_threshold && RDM2_height(1, i) < DM2_position_threshold && LDM2_height(1, i) > DM2_position_threshold
            HS_BFF(i) = 1;
        elseif  RCAL1_height(1, i) < CAL1_position_threshold && LCAL1_height(1, i) > CAL1_position_threshold && LDM2_height(1, i) < DM2_position_threshold && RDM2_height(1, i) > DM2_position_threshold
            HS_BFF(i) = 1;
        else 
            HS_BFF(i) = 0;
        end
    end

    %%% Foot flat to before heel off (FF_BHO) %%%
    %%% velocity of L(R)CAL1 above 150 mm/s  LCAL1_data_velocity_result(i,1) > 150
    %%% velocity of R(L)CAL1 below 150 mm/s  RCAL1_data_velocity_result(i,1) < 150
    %%% velocity of R(L)DM2 below 150 mm/s   RDM2_data_velocity_result(i,1) < 150 
    %%% velocity of L(R)DM2 above 150 mm/s   LDM2_data_velocity_result(i,1) > 150 
    %%% L(R)CAL1 above 35 mm                 LCAL1_height(1, i) > 35 
    %%% R(L)CAL1 below 35 mm                 RCAL1_height(1, i) < 35
    %%% R(L)DM2 below 35 mm                  RDM2_height(1, i) < 35
    %%% L(R)DM2 above 35 mm                  LDM2_height(1, i) > 35

    %Velocity rules
    %LCAL1_data_velocity_result(i,1) > velocity_threshold && RCAL1_data_velocity_result(i,1) < velocity_threshold && RDM2_data_velocity_result(i,1) < velocity_threshold && LDM2_data_velocity_result(i,1) > velocity_threshold
    %RCAL1_data_velocity_result(i,1) > velocity_threshold && LCAL1_data_velocity_result(i,1) < velocity_threshold && LDM2_data_velocity_result(i,1) < velocity_threshold && RDM2_data_velocity_result(i,1) > velocity_threshold

    %Position rules
    %LCAL1_height(1, i) > CAL1_position_threshold && RCAL1_height(1, i) < CAL1_position_threshold && RDM2_height(1, i) < DM2_position_threshold && LDM2_height(1, i) > DM2_position_threshold 
    %RCAL1_height(1, i) > CAL1_position_threshold && LCAL1_height(1, i) < CAL1_position_threshold && LDM2_height(1, i) < DM2_position_threshold && RDM2_height(1, i) > DM2_position_threshold


    for i = 1:time
        if  LCAL1_data_velocity_result(1,i) > velocity_threshold && RCAL1_data_velocity_result(1,i) < velocity_threshold && RDM2_data_velocity_result(1,i) < velocity_threshold && LDM2_data_velocity_result(1,i) > velocity_threshold && LCAL1_height(1, i) > CAL1_position_threshold && RCAL1_height(1, i) < CAL1_position_threshold && RDM2_height(1, i) < DM2_position_threshold && LDM2_height(1, i) > DM2_position_threshold
            FF_BHO(i) = 1;
        elseif  RCAL1_data_velocity_result(1,i) > velocity_threshold && LCAL1_data_velocity_result(1,i) < velocity_threshold && LDM2_data_velocity_result(1,i) < velocity_threshold && RDM2_data_velocity_result(1,i) > velocity_threshold && RCAL1_height(1, i) > CAL1_position_threshold && LCAL1_height(1, i) < CAL1_position_threshold && LDM2_height(1, i) < DM2_position_threshold && RDM2_height(1, i) > DM2_position_threshold
            FF_BHO(i) = 1;
        else
            FF_BHO(i) = 0;
        end
    end

    %%% Heel off to before toe off  (HO_BTO) %%%
    %%% velocity of L(R)CAL1 above 150 mm/s  LCAL1_data_velocity_result(i,1) > 150
    %%% velocity of R(L)CAL1 above 150 mm/s  RCAL1_data_velocity_result(i,1) > 150
    %%% velocity of R(L)DM2 below 150 mm/s   RDM2_data_velocity_result(i,1) < 150 
    %%% velocity of L(R)DM2 above 150 mm/s   LDM2_data_velocity_result(i,1) > 150 
    %%% L(R)CAL1 above 35 mm                 LCAL1_height(1, i) > 35 
    %%% R(L)CAL1 above 35 mm                 RCAL1_height(1, i) > 35
    %%% R(L)DM2 below 35 mm                  RDM2_height(1, i) < 35
    %%% L(R)DM2 above 35 mm                  LDM2_height(1, i) > 35

    %Velocity rules
    %LCAL1_data_velocity_result(i,1) > velocity_threshold && RCAL1_data_velocity_result(i,1) > velocity_threshold && RDM2_data_velocity_result(i,1) < velocity_threshold && LDM2_data_velocity_result(i,1) > velocity_threshold
    %RCAL1_data_velocity_result(i,1) > velocity_threshold && LCAL1_data_velocity_result(i,1) > velocity_threshold && LDM2_data_velocity_result(i,1) < velocity_threshold && RDM2_data_velocity_result(i,1) > velocity_threshold

    %Position rules
    %LCAL1_height(1, i) > CAL1_position_threshold && RCAL1_height(1, i) > CAL1_position_threshold && RDM2_height(1, i) < DM2_position_threshold && LDM2_height(1, i) > DM2_position_threshold 
    %RCAL1_height(1, i) > CAL1_position_threshold && LCAL1_height(1, i) > CAL1_position_threshold && LDM2_height(1, i) < DM2_position_threshold && RDM2_height(1, i) > DM2_position_threshold 

    for i = 1:time
        if LCAL1_height(1, i) > CAL1_position_threshold && RCAL1_height(1, i) > CAL1_position_threshold && RDM2_height(1, i) < DM2_position_threshold && LDM2_height(1, i) > DM2_position_threshold
            HO_BTO(i) = 1;
        elseif RCAL1_height(1, i) > CAL1_position_threshold && LCAL1_height(1, i) > CAL1_position_threshold && LDM2_height(1, i) < DM2_position_threshold && RDM2_height(1, i) > DM2_position_threshold
            HO_BTO(i) = 1;
        else
            HO_BTO(i) = 0;
        end
    end

    SS_per = num2str((sum(FF_BHO)+ sum(HO_BTO))/(sum(HS_BFF) + sum(FF_BHO)+ sum(HO_BTO)));
    DS_per = num2str((sum(HS_BFF))/(sum(HS_BFF) + sum(FF_BHO)+ sum(HO_BTO)));

 

    %%% HS_BFF phase, involving markers => R(L)LMAL, R(L)MMAL, L(R)DH, L(R)DM1, L(R)DM5
    RLMAL_position = find(strcmp( path, 'RLMAL'));
    RLMAL_xy_traj = name.Trajectories.Labeled.Data(RLMAL_position,1:2,:);
    RLMAL_xy_traj = reshape(RLMAL_xy_traj, [2, time]);

    RMMAL_position = find(strcmp( path, 'RMMAL'));
    RMMAL_xy_traj = name.Trajectories.Labeled.Data(RMMAL_position,1:2,:);
    RMMAL_xy_traj = reshape(RMMAL_xy_traj, [2, time]);

    LLMAL_position = find(strcmp( path, 'LLMAL'));
    LLMAL_xy_traj = name.Trajectories.Labeled.Data(LLMAL_position,1:2,:);
    LLMAL_xy_traj = reshape(LLMAL_xy_traj, [2, time]);

    LMMAL_position = find(strcmp( path, 'LMMAL'));
    LMMAL_xy_traj = name.Trajectories.Labeled.Data(LMMAL_position,1:2,:);
    LMMAL_xy_traj = reshape(LMMAL_xy_traj, [2, time]);

    RDH_position = find(strcmp( path, 'RDH'));
    RDH_xy_traj = name.Trajectories.Labeled.Data(RDH_position,1:2,:);
    RDH_xy_traj = reshape(RDH_xy_traj, [2, time]);

    LDH_position = find(strcmp( path, 'LDH'));
    LDH_xy_traj = name.Trajectories.Labeled.Data(LDH_position,1:2,:);
    LDH_xy_traj = reshape(LDH_xy_traj, [2, time]);

    RDM1_position = find(strcmp( path, 'RDM1'));
    RDM1_xy_traj = name.Trajectories.Labeled.Data(RDM1_position,1:2,:);
    RDM1_xy_traj = reshape(RDM1_xy_traj, [2, time]);

    LDM1_position = find(strcmp( path, 'LDM1'));
    LDM1_xy_traj = name.Trajectories.Labeled.Data(LDM1_position,1:2,:);
    LDM1_xy_traj = reshape(LDM1_xy_traj, [2, time]);

    RDM5_position = find(strcmp( path, 'RDM5'));
    RDM5_xy_traj = name.Trajectories.Labeled.Data(RDM5_position,1:2,:);
    RDM5_xy_traj = reshape(RDM5_xy_traj, [2, time]);

    LDM5_position = find(strcmp( path, 'LDM5'));
    LDM5_xy_traj = name.Trajectories.Labeled.Data(LDM5_position,1:2,:);
    LDM5_xy_traj = reshape(LDM5_xy_traj, [2, time]);







    %% final step of the calculation of MoS
    %%%% decision of the phase => compare the distance => decide the value

    %%%%%%%%%%%  HS_BFF  %%%%%%%%%%%%%

    for i = 1:time
        %%%%% Left limb forward during HS_BFF
        if LCAL1_height(1, i) < CAL1_position_threshold && RCAL1_height(1, i) > CAL1_position_threshold && RDM2_height(1, i) < DM2_position_threshold && LDM2_height(1, i) > DM2_position_threshold
            Mid_MAL = (LMMAL_xy_traj + LLMAL_xy_traj)/2;
            Mid_DM = (RDM5_xy_traj + RDM1_xy_traj)/2;
            xcom = XCOM*1000;
            AP_d_1 = abs(xcom(1,i) - Mid_MAL(1,i));
            AP_d_2 = abs(xcom(1,i) - Mid_DM(1,i));
            AP_d_3 = abs(Mid_MAL(1,i) - Mid_DM(1,i));
            if (AP_d_1 + AP_d_2) == AP_d_3
                AP_MoS = min([AP_d_1, AP_d_2]);
                AP_MoS_HS_BFF(i) = AP_MoS;
            else
                AP_MoS = min([AP_d_1, AP_d_2]);
                AP_MoS_HS_BFF(i) = 0-AP_MoS;
            end

            ML_d_1 = abs(xcom(2,i) - LLMAL_xy_traj(2,i));
            ML_d_2 = abs(xcom(2,i) - RDM5_xy_traj(2,i));
            ML_d_3 = abs(LLMAL_xy_traj(2,i) - RDM5_xy_traj(2,i));
            if (ML_d_1 + ML_d_2) == ML_d_3
                ML_MoS = min([ML_d_1, ML_d_2]);
                ML_MoS_HS_BFF(i) = ML_MoS;
            else
                ML_MoS = min([ML_d_1, ML_d_2]);
                ML_MoS_HS_BFF(i) = 0-ML_MoS;
            end
        %%%%% right limb forward during HS_BFF
        elseif  RCAL1_height(1, i) < CAL1_position_threshold && LCAL1_height(1, i) > CAL1_position_threshold && LDM2_height(1, i) < DM2_position_threshold && RDM2_height(1, i) > DM2_position_threshold
            Mid_MAL = (RMMAL_xy_traj + RLMAL_xy_traj)/2;
            Mid_DM = (LDM5_xy_traj + LDM1_xy_traj)/2;
            xcom = XCOM*1000;
            AP_d_1 = abs(xcom(1,i) - Mid_MAL(1,i));
            AP_d_2 = abs(xcom(1,i) - Mid_DM(1,i));
            AP_d_3 = abs(Mid_MAL(1,i) - Mid_DM(1,i));
            if (AP_d_1 + AP_d_2) == AP_d_3
                AP_MoS = min([AP_d_1, AP_d_2]);
                AP_MoS_HS_BFF(i) = AP_MoS;
            else
                AP_MoS = min([AP_d_1, AP_d_2]);
                AP_MoS_HS_BFF(i) = 0-AP_MoS;
            end
            ML_d_1 = abs(xcom(2,i) - RLMAL_xy_traj(2,i));
            ML_d_2 = abs(xcom(2,i) - LDM5_xy_traj(2,i));
            ML_d_3 = abs(RLMAL_xy_traj(2,i) - LDM5_xy_traj(2,i));
            if (ML_d_1 + ML_d_2) == ML_d_3
                ML_MoS = min([ML_d_1, ML_d_2]);
                ML_MoS_HS_BFF(i) = ML_MoS;
            else
                ML_MoS = min([ML_d_1, ML_d_2]);
                ML_MoS_HS_BFF(i) = 0-ML_MoS;
            end
        else 
            AP_MoS_HS_BFF(i) = 0;
            ML_MoS_HS_BFF(i) = 0;
        end
    end

    %%%%%%%%%%%  FF_BHO  %%%%%%%%%%%%%

    for i = 1:time
        %%%%% Right foot on the ground
        if  LCAL1_data_velocity_result(1,i) > velocity_threshold && RCAL1_data_velocity_result(1,i) < velocity_threshold && RDM2_data_velocity_result(1,i) < velocity_threshold && LDM2_data_velocity_result(1,i) > velocity_threshold && LCAL1_height(1, i) > CAL1_position_threshold && RCAL1_height(1, i) < CAL1_position_threshold && RDM2_height(1, i) < DM2_position_threshold && LDM2_height(1, i) > DM2_position_threshold
            Mid_MAL = (RMMAL_xy_traj + RLMAL_xy_traj)/2;
            forefoot_edge = RDH_xy_traj;
            xcom = XCOM*1000;
            AP_d_1 = abs(xcom(1,i) - Mid_MAL(1,i));
            AP_d_2 = abs(xcom(1,i) - forefoot_edge(1,i));
            AP_d_3 = abs(Mid_MAL(1,i) - forefoot_edge(1,i));
            if (AP_d_1 + AP_d_2) == AP_d_3
                AP_MoS = min([AP_d_1, AP_d_2]);
                AP_MoS_FF_BHO(i) = AP_MoS;
            else
                AP_MoS = min([AP_d_1, AP_d_2]);
                AP_MoS_FF_BHO(i) = 0-AP_MoS;
            end
            ML_d_1 = abs(xcom(2,i) - RDM1_xy_traj(2,i));
            ML_d_2 = abs(xcom(2,i) - RDM5_xy_traj(2,i));
            ML_d_3 = abs(RDM1_xy_traj(2,i) - RDM5_xy_traj(2,i));
            if (ML_d_1 + ML_d_2) == ML_d_3
                ML_MoS = min([ML_d_1, ML_d_2]);
                ML_MoS_FF_BHO(i) = ML_MoS;
            else
                ML_MoS = min([ML_d_1, ML_d_2]);
                ML_MoS_FF_BHO(i) = 0-ML_MoS;
            end
        %%%%% left foot on the ground
        elseif  RCAL1_data_velocity_result(1,i) > velocity_threshold && LCAL1_data_velocity_result(1,i) < velocity_threshold && LDM2_data_velocity_result(1,i) < velocity_threshold && RDM2_data_velocity_result(1,i) > velocity_threshold && RCAL1_height(1, i) > CAL1_position_threshold && LCAL1_height(1, i) < CAL1_position_threshold && LDM2_height(1, i) < DM2_position_threshold && RDM2_height(1, i) > DM2_position_threshold
            Mid_MAL = (LMMAL_xy_traj + LLMAL_xy_traj)/2;
            forefoot_edge = LDH_xy_traj;
            xcom = XCOM*1000;
            AP_d_1 = abs(xcom(1,i) - Mid_MAL(1,i));
            AP_d_2 = abs(xcom(1,i) - forefoot_edge(1,i));
            AP_d_3 = abs(Mid_MAL(2,i) - forefoot_edge(1,i));
            if (AP_d_1 + AP_d_2) == AP_d_3
                AP_MoS = min([AP_d_1, AP_d_2]);
                AP_MoS_FF_BHO(i) = AP_MoS;
            else
                AP_MoS = min([AP_d_1, AP_d_2]);
                AP_MoS_FF_BHO(i) = 0-AP_MoS;
            end
            ML_d_1 = abs(xcom(2,i) - LDM1_xy_traj(2,i));
            ML_d_2 = abs(xcom(2,i) - LDM5_xy_traj(2,i));
            ML_d_3 = abs(LDM1_xy_traj(2,i) - LDM5_xy_traj(2,i));
            if (ML_d_1 + ML_d_2) == ML_d_3
                ML_MoS = min([ML_d_1, ML_d_2]);
                ML_MoS_FF_BHO(i) = ML_MoS;
            else
                ML_MoS = min([ML_d_1, ML_d_2]);
                ML_MoS_FF_BHO(i) = 0-ML_MoS;
            end
        else
            AP_MoS_FF_BHO(i) = 0;
            ML_MoS_FF_BHO(i) = 0;
        end
    end

    %%%%%%%%%%%  HO_BTO  %%%%%%%%%%%%%

    for i = 1:time
        %%%%% right foot on the ground
        if LCAL1_height(1, i) > CAL1_position_threshold && RCAL1_height(1, i) > CAL1_position_threshold && RDM2_height(1, i) < DM2_position_threshold && LDM2_height(1, i) > DM2_position_threshold
            forefoot_edge = RDH_xy_traj;
            midfoot_edge = (RDM1_xy_traj + RDM5_xy_traj)/2;
            xcom = XCOM*1000;
            AP_d_1 = abs(xcom(1,i) - forefoot_edge(1,i));
            AP_d_2 = abs(xcom(1,i) - midfoot_edge(1,i));
            AP_d_3 = abs(forefoot_edge(1,i) - midfoot_edge(1,i));
            if (AP_d_1 + AP_d_2) == AP_d_3
                AP_MoS = min([AP_d_1, AP_d_2]);
                AP_MoS_HO_BTO(i) = AP_MoS;
            else
                AP_MoS = min([AP_d_1, AP_d_2]);
                AP_MoS_HO_BTO(i) = 0-AP_MoS;
            end
            ML_d_1 = abs(xcom(2,i) - RDM1_xy_traj(2,i));
            ML_d_2 = abs(xcom(2,i) - RDM5_xy_traj(2,i));
            ML_d_3 = abs(RDM1_xy_traj(2,i) - RDM5_xy_traj(2,i));
            if (ML_d_1 + ML_d_2) == ML_d_3
                ML_MoS = min([ML_d_1, ML_d_2]);
                ML_MoS_HO_BTO(i) = ML_MoS;
            else
                ML_MoS = min([ML_d_1, ML_d_2]);
                ML_MoS_HO_BTO(i) = 0-ML_MoS;
            end
        %%%%% left foot on the ground    
        elseif RCAL1_height(1, i) > CAL1_position_threshold && LCAL1_height(1, i) > CAL1_position_threshold && LDM2_height(1, i) < DM2_position_threshold && RDM2_height(1, i) > DM2_position_threshold
            forefoot_edge = LDH_xy_traj;
            midfoot_edge = (LDM1_xy_traj + LDM5_xy_traj)/2;
            xcom = XCOM*1000;
            AP_d_1 = abs(xcom(1,i) - forefoot_edge(1,i));
            AP_d_2 = abs(xcom(1,i) - midfoot_edge(1,i));
            AP_d_3 = abs(forefoot_edge(1,i) - midfoot_edge(1,i));
            if (AP_d_1 + AP_d_2) == AP_d_3
                AP_MoS = min([AP_d_1, AP_d_2]);
                AP_MoS_HO_BTO(i) = AP_MoS;
            else
                AP_MoS = min([AP_d_1, AP_d_2]);
                AP_MoS_HO_BTO(i) = 0-AP_MoS;
            end
            ML_d_1 = abs(xcom(2,i) - LDM1_xy_traj(2,i));
            ML_d_2 = abs(xcom(2,i) - LDM5_xy_traj(2,i));
            ML_d_3 = abs(LDM1_xy_traj(2,i) - LDM5_xy_traj(2,i));
            if (ML_d_1 + ML_d_2) == ML_d_3
                ML_MoS = min([ML_d_1, ML_d_2]);
                ML_MoS_HO_BTO(i) = ML_MoS;
            else
                ML_MoS = min([ML_d_1, ML_d_2]);
                ML_MoS_HO_BTO(i) = 0-ML_MoS;
            end
        else
            AP_MoS_HO_BTO(i) = 0;
            ML_MoS_HO_BTO(i) = 0;
        end
    end


    AP_MoS_DS = NaN(1,time);
    AP_MoS_SS = NaN(1,time);
    for i = 1:time
        if AP_MoS_HS_BFF(1,i) ~= 0
            AP_MoS_all(i) = AP_MoS_HS_BFF(1,i);
            AP_MoS_DS(1, i) = AP_MoS_HS_BFF(1,i);
        elseif AP_MoS_FF_BHO(1,i) ~= 0
            AP_MoS_all(i) = AP_MoS_FF_BHO(1,i);
            AP_MoS_SS(1, i) = AP_MoS_FF_BHO(1,i);
        elseif AP_MoS_HO_BTO(1,i) ~= 0
            AP_MoS_all(i) = AP_MoS_HO_BTO(1,i);
            AP_MoS_SS(1, i) = AP_MoS_HO_BTO(1,i);
        end
    end



    ML_MoS_DS = NaN(1,time);
    ML_MoS_SS = NaN(1,time);
    for i = 1:time
        if ML_MoS_HS_BFF(1,i) ~= 0
            ML_MoS_all(i) = ML_MoS_HS_BFF(1,i);
            ML_MoS_DS(1, i) = ML_MoS_HS_BFF(1,i);
        elseif ML_MoS_FF_BHO(1,i) ~= 0
            ML_MoS_all(i) = ML_MoS_FF_BHO(1,i);
            ML_MoS_SS(1, i) = ML_MoS_FF_BHO(1,i);
        elseif ML_MoS_HO_BTO(1,i) ~= 0
            ML_MoS_all(i) = ML_MoS_HO_BTO(1,i);
            ML_MoS_SS(1, i) = ML_MoS_HO_BTO(1,i);
        end
    end
end
