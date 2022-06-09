function [event, stride_event] = event_func(filtered_data)

stride_event = (0);
event = (0);
for i  = 1:(length(filtered_data))
    try 
        if abs(filtered_data(i+3) - filtered_data(i))>= 10 && filtered_data(i) == 0 && filtered_data(i+1) ~= 0
            event(end + 1) = i+2;
            stride_event(end + 1) = 0;
        elseif abs(filtered_data(i) - filtered_data(i-3))>= 10 && filtered_data(i) == 0 && filtered_data(i-1) ~= 0
            event(end + 1) = i;
            stride_event(end + 1) = 1;
        end
    catch
        continue
    end
end
end