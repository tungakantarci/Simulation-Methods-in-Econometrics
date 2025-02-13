% Exercise - Understanding heteroskedasticity using simulation

%% 1. Aim of the exercise
% To understand the implications of heteroskedasticity.

%% 2. Theory
% Refer to the accompanying PDF file for the theory.

%% 3. Application

% 3.1. Clear the memory
clear;

% 3.2. Set the number of simulations
N_sim = 1000; 

% 3.3. Set the sample size
N_obs = 500;

% 3.4. Set true values for the coefficients
B_true = [0.2 0.5]';

% 3.5. Create the systematic component of the regression
x_0 = ones(N_obs,1);
x_1 = random('Uniform',-1,1,[N_obs 1]);
X = [x_0 x_1];

% 3.6. Define the number of coeﬃcients to be simulated
N_par = 2;

% 3.7. Preallocate matrices for storing simulated statistics 
B_hat_sim_het = NaN(N_sim,N_par);
B_hat_sim_hom = NaN(N_sim,N_par);
sigma_hat_sim_het = NaN(N_sim,1); 

% 3.8. Heteroskedasticity parameter 
Gamma = 1.5; 

% 3.9. Sampling distribution of the OLS estimator when errors are het.
for i = 1:N_sim  
    u_het = random('Normal',0,exp(x_1*Gamma),[N_obs 1]);
    y_het = X*B_true+u_het;  
    LSS_het = exercisefunctionlss(y_het,X); 
    B_hat_sim_het(i,1) = LSS_het.B_hat(1,1); 
    B_hat_sim_het(i,2) = LSS_het.B_hat(2,1); 
    sigma_hat_sim_het(i,1) = LSS_het.sigma_hat; 
end

% 3.10. Average of standard deviation estimate under heteroskedasticity
sigma_hat_sim_het_mean = mean(sigma_hat_sim_het); 

% 3.11. Sampling distribution of the OLS estimator when errors are  hom.
for i = 1:N_sim
    u_hom = random('Normal',0,sigma_hat_sim_het_mean,[N_obs 1]);
    y_hom = X*B_true+u_hom;  
    LSS_hom = exercisefunctionlss(y_hom,X); 
    B_hat_sim_hom(i,1) = LSS_hom.B_hat(1,1);  
    B_hat_sim_hom(i,2) = LSS_hom.B_hat(2,1); 
end

%% 4. Plot the scatter diagram and the OLS fitted line
scatter(X(:,2),y_het,'filled','black')
hold on
set(lsline,'color','blue','LineWidth',2)
hold off
title(['Fig. 1. Heteroskedasticity Created by Simulating the ' ...
    'Estimate of the S.D. of the Reg. Err. as a Fun. of x_1'])
legend('Scatter Plot','Fitted Line');

%% 5. Plot the sampling distribution of the OLS estimator 
ksdensity(B_hat_sim_het(:,2))
hold on 
ksdensity(B_hat_sim_hom(:,2))
hold on
line([mean(B_hat_sim_hom(:,2)) mean(B_hat_sim_hom(:,2))],ylim, ...
    'Color','black')
title(['Fig. 2. The Effect of Heteroskedasticity on the Sampling ' ...
    'Distribution of the OLS estimator'])
legend('Error is heteroskedastic','Error is homoskedastic', ...
    'B\_hat\_sim\_mean');

%% 6. Check the variance of the error  
var(u_het(x_1 > 0.1 & x_1 < 0.3,1)) 
var(u_het(x_1 > 0.6 & x_1 < 0.8,1))
