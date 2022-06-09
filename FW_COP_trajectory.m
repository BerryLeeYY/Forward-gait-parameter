function final_cop = FW_COP_trajectory(name, coordination)

    %% store COP datat
    FP1_data = name.Force(1).COP;
    FP2_data = name.Force(2).COP;
    FP3_data = name.Force(3).COP;
    FP4_data = name.Force(4).COP;
    FP5_data = name.Force(5).COP;
    FP6_data = name.Force(6).COP;
    FP7_data = name.Force(7).COP;
    FP8_data = name.Force(8).COP;


    % store force data
    FP1_data_Force = name.Force(1).Force;
    FP2_data_Force = name.Force(2).Force;
    FP3_data_Force = name.Force(3).Force;
    FP4_data_Force = name.Force(4).Force;
    FP5_data_Force = name.Force(5).Force;
    FP6_data_Force = name.Force(6).Force;
    FP7_data_Force = name.Force(7).Force;
    FP8_data_Force = name.Force(8).Force;

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
    FP8_xyz = FP8_data(:,(1:frq:length(FP8_data)));



    % form the force matrix for 6 force plate
    FP1_xyz_Force = FP1_data_Force(:,(1:frq:length(FP1_data)));
    FP2_xyz_Force = FP2_data_Force(:,(1:frq:length(FP2_data)));
    FP3_xyz_Force = FP3_data_Force(:,(1:frq:length(FP3_data)));
    FP4_xyz_Force = FP4_data_Force(:,(1:frq:length(FP4_data)));
    FP5_xyz_Force = FP5_data_Force(:,(1:frq:length(FP5_data)));
    FP6_xyz_Force = FP6_data_Force(:,(1:frq:length(FP6_data)));
    FP7_xyz_Force = FP7_data_Force(:,(1:frq:length(FP7_data)));
    FP8_xyz_Force = FP8_data_Force(:,(1:frq:length(FP8_data)));
    
    
    %%%%%%%%%%%%%%%  filter stepping force platform  %%%%%%%%%%%%%%%
    force_plat_data = zeros(7, length(FP4_xyz(1,:)));
    force_plat_data(1,:) = FP1_xyz(coordination,:);
    force_plat_data(2,:) = FP2_xyz(coordination,:);
    force_plat_data(3,:) = FP3_xyz(coordination,:);
    force_plat_data(4,:) = FP4_xyz(coordination,:);
    force_plat_data(5,:) = FP5_xyz(coordination,:);
    force_plat_data(6,:) = FP6_xyz(coordination,:);
    force_plat_data(7,:) = FP7_xyz(coordination,:);
    force_plat_data(8,:) = FP8_xyz(coordination,:);

    force_plat_forcedata = zeros(7, length(FP4_xyz(1,:)));
    force_plat_forcedata(1,:) = FP1_xyz_Force(3,:);
    force_plat_forcedata(2,:) = FP2_xyz_Force(3,:);
    force_plat_forcedata(3,:) = FP3_xyz_Force(3,:);
    force_plat_forcedata(4,:) = FP4_xyz_Force(3,:);
    force_plat_forcedata(5,:) = FP5_xyz_Force(3,:);
    force_plat_forcedata(6,:) = FP6_xyz_Force(3,:);
    force_plat_forcedata(7,:) = FP7_xyz_Force(3,:);
    force_plat_forcedata(8,:) = FP8_xyz_Force(3,:);


    force_plat_identification = zeros(7, length(FP4_xyz(1,:)));
    force_plat_identification(1,:) = FP1_xyz(1,:);
    force_plat_identification(2,:) = FP2_xyz(1,:);
    force_plat_identification(3,:) = FP3_xyz(1,:);
    force_plat_identification(4,:) = FP4_xyz(1,:);
    force_plat_identification(5,:) = FP5_xyz(1,:);
    force_plat_identification(6,:) = FP6_xyz(1,:);
    force_plat_identification(7,:) = FP7_xyz(1,:);
    force_plat_identification(8,:) = FP8_xyz(1,:);

    force_plat_valid_signal = zeros(1,length(FP4_xyz(1,:)));
    force_data = zeros(1,length(FP4_xyz(1,:)));
    count = 1;
    for i = 1:8
        if std(force_plat_forcedata(i,:)) > 100
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
end