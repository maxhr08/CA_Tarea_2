function [K,Ki] = rei_lqr(plantaMIMO, Q, R)
    
    % Extract space state matrices from ss model
    [A,B,C,D] = ssdata(plantaMIMO);
    
    % Generate augmented A & B matrices
    A_aug = [A;C];
    A_aug_size = size(A_aug);
    A_aug = [A_aug,zeros(A_aug_size(1),A_aug_size(1)-A_aug_size(2))];
    
    B_size = size(B);
    B_aug = [B;zeros(A_aug_size(1)-A_aug_size(2),B_size(2))];
    
    % Check controllability of the augmented system
    if (~controlabilidad(A_aug,B_aug))
        error('Sistema de estados aumentados no es controlable. Ingrese un sistema controlable.')
    end
    
    % ----------------- %
    % --- FUNCTIONS --- %
    
    % Function to check controllability
    % Returns 'true' if the system is controllable, otherwise, returns
    % 'false'
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
        options=optimset('Algorithm','quasi-newton','disp','off','MaxIter',1000000,'MaxFunEvals',10000);
        P = fsolve(@(x) x*A + A'*x - x*B*(R^-1)*B'*x + Q, rand(size(A)));
        K = (R^-1)*B'*P;
    end
end 
