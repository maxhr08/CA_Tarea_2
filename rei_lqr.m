function [K,Ki] = rei_lqr(plantaMIMO, Q, R)
    
    % Extract space state matrices from ss model
    [A,B,C] = ssdata(plantaMIMO);
    
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
    
    % Calculate K & Ki
    [K_total] = lqr(A_aug,B_aug,Q,R);
    K_total_size = size(K_total);
    
    K = K_total(1:K_total_size(2)-1);
    Ki = K_total(K_total_size(2));
    
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
end 
