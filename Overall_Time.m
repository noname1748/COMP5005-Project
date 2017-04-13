function [T] = Overall_Time(elev_init,elev_end,req_init,req_end)
    T = abs(req_init-elev_init)+abs(elev_end-req_end)/2;
end