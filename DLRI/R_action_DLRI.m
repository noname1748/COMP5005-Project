function [next_Prob] = R_action_DLRI(ci,cur_Prob,N)
    No_Action = length(cur_Prob);
    cum_P = cumsum(cur_Prob);
    cur_Action = find(rand()<cum_P,1);
    beta = Environment(ci(cur_Action));
    
    next_Prob = zeros(No_Action,1);
    if beta == 0
        next_Prob(1:cur_Action-1) = (cur_Prob(1:cur_Action-1)*N-1)/N;
        next_Prob(cur_Action+1:end) = (cur_Prob(cur_Action+1:end)*N-1)/N;
        next_Prob(next_Prob<0) = 0;
        next_Prob(cur_Action) = 1-sum(next_Prob);
    else
        next_Prob = cur_Prob;
    end
end