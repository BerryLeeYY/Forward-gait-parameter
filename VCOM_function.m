function VCOM = VCOM_function(New_COM, time)
    %% VCOM
    COM = New_COM / 1000;
    dt = 1 / 200;


    %%% the code below is to form the velocity data in different axis for different marker

    VCOM = zeros(3, time );
    for i = 1:(time-1)
        VCOM(1,i) = ((COM(1, i+1) - COM(1, i)) / dt);
        VCOM(2,i) = ((COM(2, i+1) - COM(2, i)) / dt);
        VCOM(3,i) = ((COM(3, i+1) - COM(3, i)) / dt);
    end


end