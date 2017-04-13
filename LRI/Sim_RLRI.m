function [action] = Sim_RLRI(no_step,ci,K,init_Prob)
    cur_Prob = init_Prob;
    for n = 1:no_step
        [next_Prob] = R_action_LRI(ci,K,cur_Prob);
        cur_Prob = next_Prob;
        if max(cur_Prob)>0.95
            break;
        end
    end
    [~,action] = max(cur_Prob);
end