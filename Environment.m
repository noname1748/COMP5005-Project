
function [beta] = Environment(ci)
    beta = rand(1)<ci;
end