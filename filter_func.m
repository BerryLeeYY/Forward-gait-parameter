function filtered_velocity = filter_func(velocity_result)
threshold = 1200;
for i = 1:length(velocity_result)
    if abs(velocity_result(i)) < threshold 
        velocity_result(i) = 0;
    else
         velocity_result(i) =  velocity_result(i);
    end
end

filtered_velocity = velocity_result;
end