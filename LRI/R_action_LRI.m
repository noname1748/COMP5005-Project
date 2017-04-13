function [next_Prob] = R_action_LRI(ci,K,cur_Prob)
    No_Action = length(cur_Prob);
    cum_P = cumsum(cur_Prob);
    cur_Action = find(rand()<cum_P,1);
    beta = Environment(ci(cur_Action));
    
    next_Prob = zeros(No_Action,1);
    if beta == 0
        next_Prob(1:cur_Action-1) = cur_Prob(1:cur_Action-1)*K;
        next_Prob(cur_Action+1:end) = cur_Prob(cur_Action+1:end)*K;
        next_Prob(cur_Action) = 1-sum(next_Prob);
    else
        next_Prob = cur_Prob;
    end
end



