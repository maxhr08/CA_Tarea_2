function [K,Ki] = rei_lqr(plantaMIMO, Q, R)
     
    [A,B,C,D] = ssdata(plantaMIMO);
        
    A_aug = [A;C];
    A_aug_size = size(A_aug);
    A_aug = [A_aug,zeros(A_aug_size(1),1)];

    %B_aug = [B;zeros(A_aug_size(1),1)]; 
    
    % Check controllability of the augmented system
    if (~controlabilidad(A,B))
        error('Sistema de estados aumentados no es controlable. Ingrese un sistema controlable.')
    end
    
    
    % ----------------- %
    % --- FUNCTIONS --- %
    
    % Function to check controllability
    function controlable = controlabilidad(A,B)
        rows_A = size(A,1);
        
        % Compute the Controllability Matrix
        % ContMat = [B AB A^2B ... A^(n-1)B]
        ContMat = B;
        for i=1:1:rows_A-1
            ContMat = [ContMat, mpower(A,i)*B];
        end
        
        % Check Controllability with the matrix rank
        if(rank(ContMat) == rows_A)
            controlable = true;
        else
            controlable = false;
        end
    end
    
    % Compute K with analytic LQR
    function K = AnalyticLQR(A,B,Q,R)
        options=optimset('disp','iter','LargeScale','off','TolFun',0.01,'MaxIter',100000,'MaxFunEvals',10000);
        P = fsolve(@(x) x*A + A'*x - x*B*(R^-1)*B'*x + Q, 3*rand(size(A)));
        K = (R^-1)*B'*P;
    end
end 
