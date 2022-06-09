function [R_foot_off_event, L_foot_off_event] = foot_off_strike(name, label)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Right Leg %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% Trajectory extraction
    RDM5_trajectory = name.Trajectories.Labeled.Data(find(strcmp(label, 'RDM5')),1, :);
    RDM5_trajectory = reshape(RDM5_trajectory, [length(RDM5_trajectory), 1]);
    %%%%%% velocity calculation
    marker_trajectory = RDM5_trajectory;
    velocity_result = velocity_func(marker_trajectory);
    %%%%%% velocity normalized
    velocity_result = velocity_result(:,1);
    filtered_velocity = filter_func(velocity_result);
    %%%%%% extracting event
    filtered_data = filtered_velocity;
    [event,  stride_event] = event_func(filtered_data);
    R_event = event;
    R_Event_without_noise = [];
    count = 1;
    R_foot_contact_event = R_event(stride_event == 1);
    R_foot_off_event = R_event(stride_event == 0);
    R_foot_off_event = R_foot_off_event(2:end);
    for i = 1:(length(R_event(stride_event == 1)))
        try
            if (R_foot_contact_event(i+1) - R_foot_contact_event(i)) > 20
                R_Event_without_noise(count) = R_foot_contact_event(i);
                count = count + 1;
            end
        catch
            continue
        end
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Left Leg %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% Trajectory extraction
    LDM5_trajectory = name.Trajectories.Labeled.Data(find(strcmp(label, 'LDM5')),1, :);
    LDM5_trajectory = reshape(LDM5_trajectory, [length(LDM5_trajectory), 1]);
    %%%%%% velocity calculation
    marker_trajectory = LDM5_trajectory;
    velocity_result = velocity_func(marker_trajectory);
    %%%%%% velocity normalized
    velocity_result = velocity_result(:,1);
    filtered_velocity = filter_func(velocity_result);
    %%%%%% extracting event
    filtered_data = filtered_velocity;
    [event,  stride_event] = event_func(filtered_data);
    L_event = event;
    L_Event_without_noise = [];
    count = 1;
    L_foot_contact_event = L_event(stride_event == 1);
    L_foot_off_event = L_event(stride_event == 0);
    L_foot_off_event = L_foot_off_event(2:end);
    for i = 1:(length(L_event(stride_event == 1)))
        try
            if (L_foot_contact_event(i+1) - L_foot_contact_event(i)) > 20
                L_Event_without_noise(count) = L_foot_contact_event(i);
                count = count + 1;
            end
        catch
            continue
        end
    end
end