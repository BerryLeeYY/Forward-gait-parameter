function XCOM = XCOM_function(New_COM, time)
    %% XCOM
    % w0 = sqrt(g / l)
    % xCOM = COM + Vcom / w0
    % l = pendulum length, leg length
    COM = New_COM / 1000;
    dt = 1 / 200;


    %%% the code below is to form the velocity data in different axis for different marker

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


    g = 9.81;
    l = (nanmean(COM(3,:)));
    w0 = sqrt( g / l);
    XCOM = (COM) + (total/ w0);
end