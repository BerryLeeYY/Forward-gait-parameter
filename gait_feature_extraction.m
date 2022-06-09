%% load the data
clear
addpath 'C:\Users\a1003\OneDrive\桌面\Project_Review\sideward walking\inclinationa_angle\gait'
addpath 'C:\Users\a1003\OneDrive\桌面\Thesis\script'

subject = ('S07_Gait_0002_03');%%%%%
subjfile = [(subject),'.mat'];
load(subjfile);
name = Gait_0002_03; %%%%%%%
label = name.Trajectories.Labeled.Labels; 
path = name.Trajectories.Labeled.Labels;
coordination = 1;

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
figure
plot(New_COM(1,:))
title("COM trajectory")
%% COM velocity
marker_trajectory = New_COM;
vCOM = velocity_func(marker_trajectory);
figure
plot(vCOM(1,:))
title("COM velocity")
%% COM acceleration
marker_trajectory = vCOM;
aCOM = velocity_func(marker_trajectory);
figure
plot(aCOM(1,:))
title("COM acceleration")
%% stepping phases
[FF_BHO, HO_BTO, HS_BFF] = stepping_phase(name, time, path);
figure
plot(FF_BHO)
hold on
plot(HO_BTO)
plot(HS_BFF)
legend(["FF_BHO", "HO_BTO", "HS_BFF"])
title("stepping phases")
%% step width
step_wid = step_width(path, name, time);
figure
plot(step_wid)
title("step width")

%% step length
step_len = step_length(path, name, time);
figure
plot(step_len)
title("step length")
%% inclination angle
IA = inclination_angle(name, path, coordination);
figure
plot(IA)
title("inclination angle")
%% COP trjactory
final_cop = FW_COP_trajectory(name, coordination);
figure
plot(final_cop)
title("COP trjactory")
%% gait event
%{
[R_foot_off_event, L_foot_off_event] = foot_off_strike(name, label);
figure
plot(IA)
hold on
scatter(R_foot_off_event, IA(fix(R_foot_off_event)))
scatter(L_foot_off_event, IA(fix(L_foot_off_event)))
title("giat event")
%}
%% foot clearance
foot_clearance = foot_clearance_func(path, name, time);
figure
plot(foot_clearance)
title("foot clearance")

%% Margin of stability
[AP_MoS_all, AP_MoS_DS, AP_MoS_SS, ML_MoS_all, ML_MoS_DS, ML_MoS_SS] = MOS_func(name, path, time);
figure
plot(AP_MoS_DS)
hold on
plot(AP_MoS_SS)
legend(["AP_MoS_DS", "AP_MoS_SS"])
title("AP MOS")

figure
plot(ML_MoS_DS)
hold on
plot(ML_MoS_SS)
legend(["ML_MoS_DS", "ML_MoS_SS"])
title("ML MOS")