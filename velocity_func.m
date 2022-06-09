function velocity_result = velocity_func(marker_trajectory)

    velocity_result = nan(3,length(marker_trajectory));

    for i = 1:(length(marker_trajectory)-1)
        try
            velocity_result(:,i) = (marker_trajectory(:,i+1) - marker_trajectory(:,i))/(1/length(marker_trajectory));
        catch
            continue
        end
    end

end



