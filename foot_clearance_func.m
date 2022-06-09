function foot_clearance = foot_clearance_func(path, name, time)

    LDH_position = find(strcmp( path, 'LDH'));
    RDH_position = find(strcmp( path, 'RDH'));

    LDH_data = name.Trajectories.Labeled.Data(LDH_position,1:3,:);
    RDH_data = name.Trajectories.Labeled.Data(RDH_position,1:3,:);
    LDH_data_reshape = reshape(LDH_data, [3,time]);
    RDH_data_reshape = reshape(RDH_data, [3,time]);

    if nanmean(LDH_data_reshape(3,:)) > nanmean(RDH_data_reshape(3,:))
        foot_clearance = (LDH_data_reshape(3,:));
    elseif nanmean(LDH_data_reshape(3,:)) < nanmean(RDH_data_reshape(3,:))
        foot_clearance = (RDH_data_reshape(3,:));
    end
end