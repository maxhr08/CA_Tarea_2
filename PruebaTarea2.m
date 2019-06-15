% PruebaTarea2
% Sistema MIMO original, dos entradas y dos salidas
A = [0 1 0 0;0 0 0.3 0; 0.25 0 0 1; 0 0 0 0];
B = [0 0;0.5 0; 0 0; 0 0.55];
C = [1 0 0 0;0 0 1 0];
D = zeros(2);
% Sistema MIMO
plantaMIMO = ss(A,B,C,D);
% Matrices para REI con LQR, los valores Qii los
% define cada equipo durante sus pruebas según los
% resultados de la Tarea 1.
% Ejemplo Qii = N
% Durante la prueba final se usará un conjunto de
% valores que debe producir la respuesta mostrada
Q = diag([Q11 Q22 Q33 Q44 Q55 Q66]);
R = eye(2);
% Llamada a la función creada
[K,Ki] = rei_lqr(plantaMIMO,Q,R)
% Simule el sistema en Simulink
