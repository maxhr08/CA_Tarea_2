function [K,Ki] = rei_lqr(plantaMIMO, Q, R)
     
    [A,B,C,D] = ssdata(plantaMIMO);
     
     A_aug = [A;C];
     A_aug_size = size(A_aug);
     A_aug = [A_aug,zeros(A_aug_size(1),1)];
     
     B_aug = [B;zeros(A_aug_size(1),1)];
     
end 
