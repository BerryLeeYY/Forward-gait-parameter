function [FF_BHO, HO_BTO, HS_BFF] = stepping_phase(name, time, path)
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

        for i = 1:time
            if LCAL1_height(1, i) > CAL1_position_threshold && RCAL1_height(1, i) > CAL1_position_threshold && RDM2_height(1, i) < DM2_position_threshold && LDM2_height(1, i) > DM2_position_threshold
                HO_BTO(i) = 1;
            elseif RCAL1_height(1, i) > CAL1_position_threshold && LCAL1_height(1, i) > CAL1_position_threshold && LDM2_height(1, i) < DM2_position_threshold && RDM2_height(1, i) > DM2_position_threshold
                HO_BTO(i) = 1;
            else
                HO_BTO(i) = 0;
            end
        end
end
