function [action] = Sim_RDLRI(no_step,ci,init_Prob,N)
    cur_Prob = init_Prob;
    for n = 1:no_step
        [next_Prob] = R_action_DLRI(ci,cur_Prob,N);
        cur_Prob = next_Prob;
        if max(cur_Prob)>0.95
            break;
        end
    end
    [~,action] = max(cur_Prob);
end