
clear
addpath 'C:\Users\a1003\OneDrive\桌面\Project_Review\sideward walking\inclinationa_angle\gait'
addpath 'C:\Users\a1003\OneDrive\桌面\Thesis\script\gait'
addpath 'C:\Users\a1003\OneDrive\桌面\Thesis\script'
addpath 'C:\Users\a1003\OneDrive\桌面\Thesis\script\gait\COM related\full_markers_COM'
addpath 'C:\Users\a1003\OneDrive\桌面\Thesis\script\gait\COM related\thirteen_markers_COM'
addpath 'C:\Users\a1003\OneDrive\桌面\Thesis\script\gait\COM related\thirteen_markers_COM'

filenames = dir('C:\Users\a1003\OneDrive\桌面\Project_Review\sideward walking\inclinationa_angle\gait');
%length(filenames)
for n = 1:length(filenames)
    try
        subjfile = filenames(n).name;
        filename = load(filenames(n).name);
        name = filename.(subsref(fieldnames(filename),substruct('{}',{1})));
        label = filename.(subsref(fieldnames(filename),substruct('{}',{1}))).Trajectories.Labeled.Labels;
        path = filename.(subsref(fieldnames(filename),substruct('{}',{1}))).Trajectories.Labeled.Labels;
        split_filename = split(subjfile, ["_", "-"]);
        if ismember(["eyecl"], split_filename) || ismember(["eyescl"], split_filename)
            trial = "EC";
        else
            trial = "EP";
        end
        sub_ID = "sub" + subjfile(4:5) + "_" + subjfile(end-6:end-4);
        sub = "sub" + subjfile(4:5);
        if sum(ismember(["sub01", "sub04", "sub06", "sub08", "sub14", "sub15", "sub17"], split_filename)) == 1
            target_performance = "Good";
        elseif sum(ismember(["sub07", "sub09", "sub10", "sub11", "sub12", "sub13", "sub16", "sub18"], split_filename)) == 1
            target_performance = "Moderate";
        elseif sum(ismember(["sub02", "sub03", "sub05", "sub19", "sub24", "sub25", "sub26"], split_filename)) == 1
            target_performance = "Bad";
        end
        
        if sum(ismember(["sub03", "sub05", "sub07", "sub09", "sub10", "sub11", "sub13", "sub17", "sub18", "sub19"], split_filename)) == 1
            sex = 1; %%% 1 male, 2 female
        else
            sex = 2; %%% 1 male, 2 female
        end
        
        if sub == "sub01"
            weight = 64;
        elseif sub == "sub02"
            weight = 61;
        elseif sub == "sub03"
            weight = 90;
        elseif sub == "sub04"
            weight = 61;
        elseif sub == "sub05"
            weight = 93;
        elseif sub == "sub06"
            weight = 55;
        elseif sub == "sub07"
            weight = 73.4;
        elseif sub == "sub08"
            weight = 70.6;
        elseif sub == "sub09"
            weight = 70.6;
        elseif sub == "sub10"
            weight = 81.2;
        elseif sub == "sub11"
            weight = 68.3;
        elseif sub == "sub12"
            weight = 61.7;
        elseif sub == "sub13"
            weight = 86.7;
        elseif sub == "sub14"
            weight = 75.6;
        elseif sub == "sub15"
            weight = 81.2;
        elseif sub == "sub16"
            weight = 63.4;
        elseif sub == "sub17"
            weight = 75.8;
        elseif sub == "sub18"
            weight = 74.9;
        elseif sub == "sub19"
            weight = 60.1;
        end
        
        FP1_COP_data = name.Force(1).COP;
        FP2_COP_data = name.Force(2).COP;
        FP3_COP_data = name.Force(3).COP;
        FP4_COP_data = name.Force(4).COP;
        FP5_COP_data = name.Force(5).COP;
        FP6_COP_data = name.Force(6).COP;
        FP7_COP_data = name.Force(7).COP;

        FP1_Force_data = name.Force(1).Force;
        FP2_Force_data = name.Force(2).Force;
        FP3_Force_data = name.Force(3).Force;
        FP4_Force_data = name.Force(4).Force;
        FP5_Force_data = name.Force(5).Force;
        FP6_Force_data = name.Force(6).Force;
        FP7_Force_data = name.Force(7).Force;

        data_len = length(FP1_COP_data);
        frq = length(FP1_COP_data) / length(name.Trajectories.Labeled.Data(26,1,:));
        time = data_len / frq;
        %% Calculate the COM
        LPSI_position = find(strcmp( path, 'LPSI'));
        RPSI_position = find(strcmp( path, 'RPSI'));
        LASI_position = find(strcmp( path, 'LASI'));
        RASI_position = find(strcmp( path, 'RASI'));
        
        LPSI_data = name.Trajectories.Labeled.Data(LPSI_position,1:3,:);
        RPSI_data = name.Trajectories.Labeled.Data(RPSI_position,1:3,:);
        LASI_data = name.Trajectories.Labeled.Data(LASI_position,1:3,:);
        RASI_data = name.Trajectories.Labeled.Data(RASI_position,1:3,:);
        
        LPSI_data = reshape(LPSI_data, [3, time]);
        RPSI_data = reshape(RPSI_data, [3,time]);
        LASI_data = reshape(LASI_data, [3,time]);
        RASI_data = reshape(RASI_data, [3,time]);

        LASI = LASI_data;
        LPSI = LPSI_data;
        RASI = RASI_data;
        RPSI = RPSI_data;

        % calculate the hip marker position
        [hip_center, L_hip_center, R_hip_center] = hip_markers(LASI, LPSI, RASI, RPSI);
        %%% 4 markers version
        %New_COM = hip_center;
        %%% 13 markers version
        %New_COM = thirteen_markers_COM_func(path, name, time, sex);
        %%% 38 markers version
        %NrOfSamples = time;
        %New_COM = CoM(path, name, NrOfSamples, sex, time);
        %%% force plate version
        [Pos_estimate, Vel_estimate] = force_COM_func(filename, name, path, sex, weight);
        New_COM = Pos_estimate;
        %% COM velocity
        marker_trajectory = New_COM;
        vCOM = velocity_func(marker_trajectory);
        %% COM acceleration
        marker_trajectory = vCOM;
        aCOM = velocity_func(marker_trajectory);
        %% stepping phases
        [FF_BHO, HO_BTO, HS_BFF, TO_BFF] = stepping_phase(name, time, path);
        SS_ratio = num2str((sum(FF_BHO)+ sum(HO_BTO)+ sum(TO_BFF))/(sum(HS_BFF) + sum(FF_BHO)+ sum(HO_BTO)+ sum(TO_BFF)));
        DS_ratio = num2str((sum(HS_BFF))/(sum(HS_BFF) + sum(FF_BHO)+ sum(HO_BTO)+ sum(TO_BFF)));
        %% step width
        step_wid = step_width(name, time, path);
        %% step length
        step_len = step_length(path, name, time);
        %% AP inclination angle
        coordination = 1;
        IA = inclination_angle(subjfile, name, path, coordination, New_COM);
        AP_IA = IA;
        %% ML inclination angle
        coordination = 2;
        IA = inclination_angle(subjfile, name, path, coordination, New_COM);
        ML_IA = IA;
        %% COP trjactory (old version)
        %final_cop = FW_COP_trajectory(name, coordination); 
        %% foot clearance
        foot_clearance = foot_clearance_func(path, name, time);
        %% XCOM
        XCOM = XCOM_function(New_COM, time);
        %% Margin of stability
        [AP_MoS_all, AP_MoS_DS, AP_MoS_SS, ML_MoS_all, ML_MoS_DS, ML_MoS_SS] = MOS_func(name, path, time, New_COM);
        %% new AP COP (new version)
        coordination = 1;
        [new_cop] = new_COP(subjfile, coordination);
        AP_COP = new_cop;
        %% new ML COP (new version)
        coordination = 2;
        [new_cop] = new_COP(subjfile, coordination);
        ML_COP = new_cop;
        %% new AP COP velocity (new version)
        marker_trajectory = AP_COP;
        vCOP = velocity_func(marker_trajectory);
        AP_vCOP = vCOP(1,:);
        %% new ML COP velocity(new version)
        marker_trajectory = ML_COP;
        vCOP = velocity_func(marker_trajectory);
        ML_vCOP = vCOP(1,:);
        %% new AP COP acc (new version)
        marker_trajectory = AP_vCOP;
        aCOP = velocity_func(marker_trajectory);
        AP_aCOP = aCOP(1,:);
        %% new ML COP acc (new version)
        marker_trajectory = ML_vCOP;
        aCOP = velocity_func(marker_trajectory);
        ML_aCOP = aCOP(1,:);
        %% Seperate the step and take out the feature
        
        [pks, loc] = findpeaks(step_len, "MinPeakDistance", 40);
        count = 1;
        for ii = 1:(length(loc)-1)
            try 
                timstemps = [loc(ii), loc(ii+1)];
                i = 1;
                %%% COM trajectory
                std_AP_COM = nanstd(New_COM(1, timstemps(i):timstemps(i+1)));
                std_ML_COM = nanstd(New_COM(2, timstemps(i):timstemps(i+1)));
                std_vretical_COM = nanstd(New_COM(3, timstemps(i):timstemps(i+1)));
                ROM_AP_COM = abs(max(New_COM(1, timstemps(i):timstemps(i+1))) - min(New_COM(1, timstemps(i):timstemps(i+1))));
                ROM_ML_COM = abs(max(New_COM(2, timstemps(i):timstemps(i+1))) - min(New_COM(2, timstemps(i):timstemps(i+1))));
                
                %%% COM velocity
                std_AP_vCOM = nanstd(vCOM(1, timstemps(i):timstemps(i+1)));
                std_ML_vCOM = nanstd(vCOM(2, timstemps(i):timstemps(i+1)));
                std_vretical_vCOM = nanstd(vCOM(3, timstemps(i):timstemps(i+1)));
                max_AP_vCOM = abs(max(vCOM(1, timstemps(i):timstemps(i+1))));
                max_ML_vCOM = abs(max(vCOM(2, timstemps(i):timstemps(i+1))));
                ROM_AP_vCOM = abs(max(vCOM(1, timstemps(i):timstemps(i+1))) - min(vCOM(1, timstemps(i):timstemps(i+1))));
                ROM_ML_vCOM = abs(max(vCOM(2, timstemps(i):timstemps(i+1))) - min(vCOM(2, timstemps(i):timstemps(i+1))));
                
                %%% COM acceleration
                std_AP_aCOM = nanstd(aCOM(1, timstemps(i):timstemps(i+1)));
                std_ML_aCOM = nanstd(aCOM(2, timstemps(i):timstemps(i+1)));
                std_vretical_aCOM = nanstd(aCOM(3, timstemps(i):timstemps(i+1)));
                max_AP_aCOM = max(aCOM(1, timstemps(i):timstemps(i+1)));
                max_ML_aCOM = max(aCOM(2, timstemps(i):timstemps(i+1)));
                ROM_AP_aCOM = abs(max(aCOM(1, timstemps(i):timstemps(i+1))) - min(aCOM(1, timstemps(i):timstemps(i+1))));
                ROM_ML_aCOM = abs(max(aCOM(2, timstemps(i):timstemps(i+1))) - min(aCOM(2, timstemps(i):timstemps(i+1))));
                
                %%% stance phases
                SS_ratio = num2str((sum(FF_BHO(timstemps(i):timstemps(i+1),1))+ sum(HO_BTO(timstemps(i):timstemps(i+1),1))+ sum(TO_BFF(timstemps(i):timstemps(i+1),1)))/(sum(HS_BFF(timstemps(i):timstemps(i+1),1)) + sum(FF_BHO(timstemps(i):timstemps(i+1),1))+ sum(HO_BTO(timstemps(i):timstemps(i+1),1))+ sum(TO_BFF(timstemps(i):timstemps(i+1),1))));
                DS_ratio = num2str((sum(HS_BFF(timstemps(i):timstemps(i+1),1)))/(sum(HS_BFF(timstemps(i):timstemps(i+1),1)) + sum(FF_BHO(timstemps(i):timstemps(i+1),1))+ sum(HO_BTO(timstemps(i):timstemps(i+1),1))+ sum(TO_BFF(timstemps(i):timstemps(i+1),1))));
                SS_duration_ratio = SS_ratio;
                DS_duration_ratio = DS_ratio;
                
                %%% Length between heel markers (in a step)
                ROM_length = abs(max(step_len(1,timstemps(i):timstemps(i+1))) - min(step_len(1,timstemps(i):timstemps(i+1))));
                std_length = nanstd(step_len(1,timstemps(i):timstemps(i+1)));
                
                %%% Width between heel markers (in a step)
                ROM_width = abs(max(step_wid(1,timstemps(i):timstemps(i+1))) - min(step_wid(1,timstemps(i):timstemps(i+1))));
                std_width = nanstd(step_wid(1,timstemps(i):timstemps(i+1)));
                
                %%% foot clearance
                mean_clearance = nanmean(foot_clearance(1,timstemps(i):timstemps(i+1)));
                std_clearance = nanstd(foot_clearance(1,timstemps(i):timstemps(i+1)));
                max_clearance = max(foot_clearance(1,timstemps(i):timstemps(i+1)));
                
                %%% COP trajectory
                std_AP_COP = nanstd(AP_COP(1, timstemps(i):timstemps(i+1)));
                std_ML_COP = nanstd(ML_COP(1, timstemps(i):timstemps(i+1)));
                ROM_AP_COP = abs(max(AP_COP(1, timstemps(i):timstemps(i+1))) - min(AP_COP(1, timstemps(i):timstemps(i+1))));
                ROM_ML_COP = abs(max(ML_COP(1, timstemps(i):timstemps(i+1))) - min(ML_COP(1, timstemps(i):timstemps(i+1))));
                
                %%% COP velocity
                std_AP_vCOP = nanstd(AP_vCOP(1, timstemps(i):timstemps(i+1)));
                std_ML_vCOP = nanstd(ML_vCOP(1, timstemps(i):timstemps(i+1)));
                max_AP_vCOP = abs(max(AP_vCOP(1, timstemps(i):timstemps(i+1))));
                max_ML_vCOP = abs(max(ML_vCOP(1, timstemps(i):timstemps(i+1))));
                ROM_AP_vCOP = abs(max(AP_vCOP(1, timstemps(i):timstemps(i+1))) - min(AP_vCOP(1, timstemps(i):timstemps(i+1))));
                ROM_ML_vCOP = abs(max(ML_vCOP(1, timstemps(i):timstemps(i+1))) - min(ML_vCOP(1, timstemps(i):timstemps(i+1))));
                
                %%% COP acceleration
                std_AP_aCOP = nanstd(AP_aCOP(1, timstemps(i):timstemps(i+1)));
                std_ML_aCOP = nanstd(ML_aCOP(1, timstemps(i):timstemps(i+1)));
                max_AP_aCOP = max(AP_aCOP(1, timstemps(i):timstemps(i+1)));
                max_ML_aCOP = max(ML_aCOP(1, timstemps(i):timstemps(i+1)));
                ROM_AP_aCOP = abs(max(AP_aCOP(1, timstemps(i):timstemps(i+1))) - min(AP_aCOP(1, timstemps(i):timstemps(i+1))));
                ROM_ML_aCOP = abs(max(ML_aCOP(1, timstemps(i):timstemps(i+1))) - min(ML_aCOP(1, timstemps(i):timstemps(i+1))));
                
                %%% Extrapolated center of mass
                std_AP_xCOM = nanstd(XCOM(1, timstemps(i):timstemps(i+1)));
                std_ML_xCOM = nanstd(XCOM(2, timstemps(i):timstemps(i+1)));
                std_vretical_xCOM = nanstd(XCOM(3, timstemps(i):timstemps(i+1)));
                ROM_AP_xCOM = abs(max(XCOM(1, timstemps(i):timstemps(i+1))) - min(XCOM(1, timstemps(i):timstemps(i+1))));
                ROM_ML_xCOM = abs(max(XCOM(2, timstemps(i):timstemps(i+1))) - min(XCOM(2, timstemps(i):timstemps(i+1))));
                
                %%% MoS
                mean_AP_MOS = nanmean(AP_MoS_all(1, timstemps(i):timstemps(i+1)));
                mean_ML_MOS = nanmean(ML_MoS_all(1, timstemps(i):timstemps(i+1)));
                std_AP_MOS = nanstd(AP_MoS_all(1, timstemps(i):timstemps(i+1)));
                std_ML_MOS = nanstd(ML_MoS_all(1, timstemps(i):timstemps(i+1)));
                mean_AP_SS_MOS = nanmean(AP_MoS_SS(1, timstemps(i):timstemps(i+1)));
                mean_ML_SS_MOS = nanmean(ML_MoS_SS(1, timstemps(i):timstemps(i+1)));
                mean_AP_DS_MOS = nanmean(AP_MoS_DS(1, timstemps(i):timstemps(i+1)));
                mean_ML_DS_MOS = nanmean(ML_MoS_DS(1, timstemps(i):timstemps(i+1)));
                max_AP_MOS = max(AP_MoS_all(1, timstemps(i):timstemps(i+1)));
                max_ML_MOS = max(ML_MoS_all(1, timstemps(i):timstemps(i+1)));
                min_AP_MOS = min(AP_MoS_all(1, timstemps(i):timstemps(i+1)));
                min_ML_MOS = min(ML_MoS_all(1, timstemps(i):timstemps(i+1)));
                ROM_AP_MOS = abs(max_AP_MOS - min_AP_MOS);
                ROM_ML_MOS = abs(max_ML_MOS - min_ML_MOS);
                
                 
                %%% inclination angle
                mean_AP_IA = nanmean(AP_IA(1, timstemps(i):timstemps(i+1)));
                mean_ML_IA = nanmean(ML_IA(1, timstemps(i):timstemps(i+1)));
                std_AP_IA = nanstd(AP_IA(1, timstemps(i):timstemps(i+1)));
                std_ML_IA = nanstd(ML_IA(1, timstemps(i):timstemps(i+1)));
                ROM_AP_IA = abs(max(AP_IA(1, timstemps(i):timstemps(i+1))) - min(AP_IA(1, timstemps(i):timstemps(i+1))));
                ROM_ML_IA = abs(max(ML_IA(1, timstemps(i):timstemps(i+1))) - min(ML_IA(1, timstemps(i):timstemps(i+1))));
                
                
                feature_value = [sub, std_AP_COM, std_ML_COM, std_vretical_COM, ROM_AP_COM, ROM_ML_COM, std_AP_vCOM, std_ML_vCOM,... 
                    std_vretical_vCOM, max_AP_vCOM, max_ML_vCOM,ROM_AP_vCOM, ROM_ML_vCOM, std_AP_aCOM, std_ML_aCOM,...
                    std_vretical_aCOM, max_AP_aCOM, max_ML_aCOM, ROM_AP_aCOM, ROM_ML_aCOM, str2num(SS_duration_ratio), str2num(DS_duration_ratio),...
                    ROM_length, std_length, ROM_width, std_width, mean_clearance, std_clearance, max_clearance,...
                    std_AP_COP, std_ML_COP, ROM_AP_COP, ROM_ML_COP, std_AP_vCOP, std_ML_vCOP, max_AP_vCOP, max_ML_vCOP,...
                    ROM_AP_vCOP, ROM_ML_vCOP, std_AP_aCOP, std_ML_aCOP, max_AP_aCOP, max_ML_aCOP, ROM_AP_aCOP, ROM_ML_aCOP,...
                    std_AP_xCOM, std_ML_xCOM, std_vretical_xCOM, ROM_AP_xCOM, ROM_ML_xCOM, mean_AP_MOS, mean_ML_MOS, std_AP_MOS,...
                    std_ML_MOS, mean_AP_SS_MOS, mean_ML_SS_MOS, mean_AP_DS_MOS, mean_ML_DS_MOS, max_AP_MOS, max_ML_MOS,...
                    min_AP_MOS, min_ML_MOS, ROM_AP_MOS, ROM_ML_MOS, mean_AP_IA, mean_ML_IA, std_AP_IA, std_ML_IA, ROM_AP_IA,ROM_ML_IA, target_performance];
         
                feature_col = ["sub_ID", "std_AP_COM", "std_ML_COM", "std_vretical_COM", "ROM_AP_COM", "ROM_ML_COM", "std_AP_vCOM", "std_ML_vCOM",... 
                    "std_vretical_vCOM", "max_AP_vCOM", "max_ML_vCOM","ROM_AP_vCOM", "ROM_ML_vCOM", "std_AP_aCOM", "std_ML_aCOM",...
                    "std_vretical_aCOM", "max_AP_aCOM", "max_ML_aCOM", "ROM_AP_aCOM", "ROM_ML_aCOM", "SS_duration_ratio", "DS_duration_ratio",...
                    "ROM_length", "std_length", "ROM_width", "std_width", "mean_clearance", "std_clearance", "max_clearance",...
                    "std_AP_COP", "std_ML_COP", "ROM_AP_COP", "ROM_ML_COP", "std_AP_vCOP", "std_ML_vCOP", "max_AP_vCOP", "max_ML_vCOP",...
                    "ROM_AP_vCOP", "ROM_ML_vCOP", "std_AP_aCOP", "std_ML_aCOP", "max_AP_aCOP", "max_ML_aCOP", "ROM_AP_aCOP", "ROM_ML_aCOP",...
                    "std_AP_xCOM", "std_ML_xCOM", "std_vretical_xCOM", "ROM_AP_xCOM", "ROM_ML_xCOM", "mean_AP_MOS", "mean_ML_MOS", "std_AP_MOS",...
                    "std_ML_MOS", "mean_AP_SS_MOS", "mean_ML_SS_MOS", "mean_AP_DS_MOS", "mean_ML_DS_MOS", "max_AP_MOS", "max_ML_MOS",...
                    "min_AP_MOS", "min_ML_MOS", "ROM_AP_MOS", "ROM_ML_MOS", "mean_AP_IA", "mean_ML_IA", "std_AP_IA", "std_ML_IA", "ROM_AP_IA","ROM_ML_IA", "target_performance"];
                
                feature_summary = [feature_col; feature_value];
                saved_path_name = "D:\files\second_part\force_plate_COM_version\" + sub_ID + "_" + num2str(count) + ".csv";
                writematrix(feature_summary, saved_path_name)
                count = count + 1;
            catch
                subjfile
                error= "error in second try-catch statement"
                continue
            end
        end
    catch
        subjfile
        %clear
        addpath 'C:\Users\a1003\OneDrive\桌面\Project_Review\sideward walking\inclinationa_angle\gait'
        addpath 'C:\Users\a1003\OneDrive\桌面\Thesis\script\gait'
        filenames = dir('C:\Users\a1003\OneDrive\桌面\Project_Review\sideward walking\inclinationa_angle\gait');
        continue
    end
end