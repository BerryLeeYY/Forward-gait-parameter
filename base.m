%% load the data
clear
addpath 'C:\Users\a1003\OneDrive\桌面\Project_Review\side_walk_new\SW'
addpath 'C:\Users\a1003\OneDrive\桌面\Project_Review\sideward walking\inclinationa_angle\gait'
subject = ('R_Gait_0001_3');
subjfile = [(subject),'.mat'];
load(subjfile);
data_label = 16;
R_data = load(subject);
name =Gait_0001_3;
label = Gait_0001_3.Trajectories.Labeled.Labels;
%% analyze anterior-posterior inclination angle: coordination = 1
%  analyze medial-lateral incliantion angle: coordination = 2
coordination = 1 ;% 1: anterior-posterior, 2: medial-lateral, 3: up and down

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

%%% Calculate the COM
%%%find the marker
path = name.Trajectories.Labeled.Labels;

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


%%%
coordination = 2 ;% 1: anterior-posterior, 2: medial-lateral, 3: up and down
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Right Leg %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Trajectory extraction
RDM5_trajectory = name.Trajectories.Labeled.Data(find(strcmp(label, 'RDM5')),1, :);
RDM5_trajectory = reshape(RDM5_trajectory, [length(RDM5_trajectory), 1]);
%%%%%% velocity calculation
marker_trajectory = RDM5_trajectory;
velocity_result = velocity_func(marker_trajectory);
%%%%%% velocity normalized
velocity_result = velocity_result;
normalized_velocity = normalize(velocity_result);
%%%%%% velocity filtering
normalized_velocity = normalized_velocity;
filtered_velocity = filter_func(normalized_velocity);
%%%%%% extracting event
filtered_data = filtered_velocity;
[event,  stride_event] = event_func(filtered_data);
R_event = event;
R_stride_event = stride_event;
R_Event_without_noise = [];
R_stride_event_without_noise = [];
count = 1;
for i = 1:(length(R_event)-1)
    if R_event(i+1) - R_event(i) > 20
        R_Event_without_noise(count) = R_event(i);
        R_stride_event_without_noise(count) = R_stride_event(i);
        count = count + 1;
    end
end
%%%%%% plot 
%{
figure
plot(filtered_velocity)
hold on 
scatter(R_Event_without_noise, filtered_velocity(fix(R_Event_without_noise)))
%}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Left Leg %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Trajectory extraction
LDM5_trajectory = name.Trajectories.Labeled.Data(find(strcmp(label, 'LDM5')),1, :);
LDM5_trajectory = reshape(LDM5_trajectory, [length(LDM5_trajectory), 1]);
%%%%%% velocity calculation
marker_trajectory = LDM5_trajectory;
velocity_result = velocity_func(marker_trajectory);
%%%%%% velocity normalized
velocity_result = velocity_result;
normalized_velocity = normalize(velocity_result);
%%%%%% velocity filtering
normalized_velocity = normalized_velocity;
filtered_velocity = filter_func(normalized_velocity);
%%%%%% extracting event
filtered_data = filtered_velocity;
[event,  stride_event] = event_func(filtered_data);
L_event = event;
L_stride_event = stride_event;
L_Event_without_noise = [];
L_stride_event_without_noise = [];
count = 1;
for i = 1:(length(L_event)-1)
    if L_event(i+1) - L_event(i) > 20
        L_Event_without_noise(count) = L_event(i);
        L_stride_event_without_noise(count) = L_stride_event(i);
        count = count + 1;
    end
end
%%%%%% plot
%{
figure
plot(filtered_velocity)
hold on 
scatter(L_Event_without_noise, filtered_velocity(fix(L_Event_without_noise)))
%}

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
disp(size(force_plat_valid_signal))
disp(size(force_data))
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
    
end

   
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  IA calculation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
COM = New_COM;
threshold = 30;
IA = zeros(size(force_plat_valid_signal, 1), length(force_plat_valid_signal));

for i = 1:length(final_cop)
    ia(i) =  (final_cop(i)-New_COM(coordination,i))/New_COM(3,i);
end
IA = atand(ia);
%% ankle supination

%%% right
RDH = find(strcmp( path, 'RDH'));
RDM5 = find(strcmp( path, 'RDM5'));

RDH_data = name.Trajectories.Labeled.Data(RDH,1:3,:);
RDH_trajectory = reshape(RDH_data, [3, time]);
RDM5_data = name.Trajectories.Labeled.Data(RDM5,1:3,:);
RDM5_trajectory = reshape(RDM5_data, [3, time]);

x = abs(RDH_trajectory(2,:) - RDM5_trajectory(2,:));
z = abs(RDH_trajectory(3,:) - RDM5_trajectory(3,:));

tan_value = z./x;
R_sup_angle = atand(tan_value);



%%% left
LDH = find(strcmp( path, 'LDH'));
LDM5 = find(strcmp( path, 'LDM5'));

LDH_data = name.Trajectories.Labeled.Data(LDH,1:3,:);
LDH_trajectory = reshape(LDH_data, [3, time]);
LDM5_data = name.Trajectories.Labeled.Data(LDM5,1:3,:);
LDM5_trajectory = reshape(LDM5_data, [3, time]);

x = abs(LDH_trajectory(2,:) - LDM5_trajectory(2,:));
z = abs(LDH_trajectory(3,:) - LDM5_trajectory(3,:));

tan_value = z./x;
L_sup_angle = atand(tan_value);


%% Step length
LCAL2_position = find(strcmp( path, 'LCAL2'));
RCAL2_position = find(strcmp( path, 'RCAL2'));

LCAL2_data = name.Trajectories.Labeled.Data(LCAL2_position,1:3,:);
RCAL2_data = name.Trajectories.Labeled.Data(RCAL2_position,1:3,:);
LCAL2_data_reshape = reshape(LCAL2_data, [3,time]);
RCAL2_data_reshape = reshape(RCAL2_data, [3,time]);

step_length = abs(RCAL2_data_reshape(1,:) - LCAL2_data_reshape(1,:));
step_width = abs(RCAL2_data_reshape(2,:) - LCAL2_data_reshape(2,:));

%% Integration and processing

R_event_sup_angle = [R_sup_angle(fix(R_Event_without_noise));step_length(fix(R_Event_without_noise)); IA(fix(R_Event_without_noise)); R_stride_event_without_noise];
L_event_sup_angle = [L_sup_angle(fix(L_Event_without_noise));step_length(fix(L_Event_without_noise)); IA(fix(L_Event_without_noise)); L_stride_event_without_noise];

count = 1;
for i = 1:size(R_event_sup_angle, 2)
    if R_event_sup_angle(4,i) == 1 
        R_contact_sup_angle(count) = R_event_sup_angle(1,i);
        R_contact(count) = R_Event_without_noise(i);
        count = count + 1;
    end
end

count = 1;
for i = 1:size(L_event_sup_angle, 2)
    if L_event_sup_angle(4,i) == 1 
        L_contact_sup_angle(count) = L_event_sup_angle(1,i);
        L_contact(count) = L_Event_without_noise(i);
        count = count + 1;
    end
end

%%%%%% if angle < 6 then that is the outlier
R_final_contact_sup_angle = [];

count = 1;
for i = 1:length(R_contact_sup_angle)
    if R_contact_sup_angle(i) > 8
        R_final_contact_sup_angle(count) = R_contact_sup_angle(i);
        R_contact_without_noise(count) = R_contact(i);
        count = count + 1;
    end
end

L_final_contact_sup_angle = [];
count = 1;
for i = 1:length(L_contact_sup_angle)
    if L_contact_sup_angle(i) > 8
        L_final_contact_sup_angle(count) = L_contact_sup_angle(i);
        L_contact_without_noise(count) = R_contact(i);
        count = count + 1;
    end
end



fw_ankle_supination = [R_final_contact_sup_angle, L_final_contact_sup_angle];
fw_ankle_supination = reshape(fw_ankle_supination, [length(fw_ankle_supination), 1]);
n = zeros(length(fw_ankle_supination), 1);
for i = 1:length(fw_ankle_supination)
    n(i) = data_label;
end
%% XCOM
% w0 = sqrt(g / l)
% xCOM = COM + Vcom / w0
% l = pendulum length, leg length
COM = New_COM / 1000;
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

%%
Position = XCOM;
% store COP datat
FP1_data = name.Force(1).COP;
FP2_data = name.Force(2).COP;
FP3_data = name.Force(3).COP;
FP4_data = name.Force(4).COP;
FP5_data = name.Force(5).COP;
FP6_data = name.Force(6).COP;

% store force data
FP1_data_Force = name.Force(1).Force;
FP2_data_Force = name.Force(2).Force;
FP3_data_Force = name.Force(3).Force;
FP4_data_Force = name.Force(4).Force;
FP5_data_Force = name.Force(5).Force;
FP6_data_Force = name.Force(6).Force;


data_len = length(FP1_data);
FP = zeros(6, data_len);

% corresponding time
frq = length(FP1_data) / length(name.Trajectories.Labeled.Data(26,1,:));
time = data_len / frq;


%% plot boundary 

path = name.Trajectories.Labeled.Labels;

RDM1 = find(strcmp( path, 'RDM1'));
RDM5 = find(strcmp( path, 'RDM5'));
RDH = find(strcmp( path, 'RDH'));
RMCAL = find(strcmp( path, 'RMCAL'));
RCAL1 = find(strcmp( path, 'RCAL1'));
RLCAL = find(strcmp( path, 'RLCAL'));

LDM1 = find(strcmp( path, 'LDM1'));
LDM5 = find(strcmp( path, 'LDM5'));
LDH = find(strcmp( path, 'LDH'));
LMCAL = find(strcmp( path, 'LMCAL'));
LCAL1 = find(strcmp( path, 'LCAL1'));
LLCAL = find(strcmp( path, 'LLCAL'));

RDM1_data = name.Trajectories.Labeled.Data(RDM1,1:3,:);
RDM5_data = name.Trajectories.Labeled.Data(RDM5,1:3,:);
RDH_data = name.Trajectories.Labeled.Data(RDH,1:3,:);
RMCAL_data = name.Trajectories.Labeled.Data(RMCAL,1:3,:);
RCAL1_data = name.Trajectories.Labeled.Data(RCAL1,1:3,:);
RLCAL_data = name.Trajectories.Labeled.Data(RLCAL,1:3,:);

LDM1_data = name.Trajectories.Labeled.Data(LDM1,1:3,:);
LDM5_data = name.Trajectories.Labeled.Data(LDM5,1:3,:);
LDH_data = name.Trajectories.Labeled.Data(LDH,1:3,:);
LMCAL_data = name.Trajectories.Labeled.Data(LMCAL,1:3,:);
LCAL1_data = name.Trajectories.Labeled.Data(LCAL1,1:3,:);
LLCAL_data = name.Trajectories.Labeled.Data(LLCAL,1:3,:);

RDM1_data = reshape(RDM1_data, [3, time]) / 1000;
RDM5_data = reshape(RDM5_data, [3, time]) / 1000;
RDH_data = reshape(RDH_data, [3, time])/ 1000;
RMCAL_data = reshape(RMCAL_data, [3, time])/ 1000;
RCAL1_data = reshape(RCAL1_data, [3, time])/ 1000;
RLCAL_data = reshape(RLCAL_data, [3, time])/ 1000;

LDM1_data = reshape(LDM1_data, [3, time]) / 1000;
LDM5_data = reshape(LDM5_data, [3, time]) / 1000;
LDH_data = reshape(LDH_data, [3, time])/ 1000;
LMCAL_data = reshape(LMCAL_data, [3, time])/ 1000;
LCAL1_data = reshape(LCAL1_data, [3, time])/ 1000;
LLCAL_data = reshape(LLCAL_data, [3, time])/ 1000;

        
center = (LMCAL_data + LLCAL_data + RDM1_data + RDM5_data)/4;     
distance = abs(XCOM - center);
x_sqr = distance(1,:) .* distance(1,:);
y_sqr = distance(2,:) .* distance(2,:);
d = sqrt(x_sqr + y_sqr);
