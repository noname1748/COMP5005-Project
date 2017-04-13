function [ci_update] = Environment_update(K,req_init,ci)
    ci_update = ci;
    ci_update(req_init) = K*ci(req_init);
end