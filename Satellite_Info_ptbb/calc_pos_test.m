%% position calculation

function [pos] = calc_pos_test (sv_crd, pr, is_estimating_rec_clk)
% This function will calculate a position coordinate based the pseudoranges
% and satellite coordinates. The coordinates refer to transmission time. A
% flag can be set to disregard receiver clock error estimation.
% 
% This function is implemented based on Notes from Allan Aasbjerg Nielsen, 
% http://www2.imm.dtu.dk/pubdb/views/edoc_download.php/2804/pdf/imm2804.pdf
% 
% Input: sv_crd satellite coordinates in [prn x y z]
% pr pseudoranges for the satellites (the first column is value of pseudorange,second is prn
% is_estimating_rec_clk, flag whether to estimate receiver clock error in the calculation
% possible values are 0 and 1 (default)
% 
% Output: pos [X Y Z]
% rec_clk: The estimated receiver clock error
% error ellipses for the semiaxes, 95% and 99%

% Sets the default value of estimating the receiver clock
if nargin<=2
  is_estimating_rec_clk=1;
end   



%% start calculating the position
% Define the starting position as center of the Earth
StartPos = [0 0 0];

% Define starting guess of unknowns
StartGuess = [StartPos 0];

% Split satellite ciirdiunates X Y Z into three variables
xSV = sv_crd(:,2);
ySV = sv_crd(:,3);
zSV = sv_crd(:,4);

% l is the observation equations % pr as an input , the first column is
% values of pseudorange. the second column is prn number???
% l = pr(:,2);
l=pr(:,1);

% Number of observations
n = length(pr);
% Number of unknowns
p = length(StartGuess);
% Degrees of freedom
f = n-p;


% Set up the weight matrix P
sSquared = 10^2;
% eye return the n-by-n identity matrix
P = eye(n)/sSquared;

% Initialise deltahat 
deltahat = ones(n,n);

iterations = 1;
% Start the GaussNewton iteration process, stop when the change of deltahat
% is low or with a max of 20 iterations
while (max(abs(deltahat))>0.001 | (iterations > 20))
    % Range from SVs to startguess
    range = sqrt((StartGuess(1)-xSV).^2+(StartGuess(2)-ySV).^2+(StartGuess(3)-zSV).^2);
    
    if (is_estimating_rec_clk)
    
       % Add the clock correction
       prange = range+StartGuess(4);

       F = prange;
       % initialise the derivative matrix
       A = [];

       % The inverse range
       irange = 1./range;
       VectorOfOnes = ones(n,1);
       A = [irange.*(StartGuess(1)-xSV), irange.*(StartGuess(2)-ySV), irange.*(StartGuess(3)-zSV), VectorOfOnes];
   
    else
       
       F = range;
       % initialise the derivative matrix
       A = [];

       % The inverse range
       irange = 1./range;
       A = [irange.*(StartGuess(1)-xSV), irange.*(StartGuess(2)-ySV), irange.*(StartGuess(3)-zSV)];
    end
    
    k = l-F;
    N = A'*P*A;
    c = A'*P*k;
    % Solve for deltahat
    deltahat = N\c;

    
     if (is_estimating_rec_clk)
        % Update the position with the new estimated gradients
        StartGuess = StartGuess+deltahat';
     else
        StartGuess(1:3) = StartGuess(1:3)+deltahat';
     end
     
    % Update the iterations counter
    iterations = iterations +1;
end
% % % % % % % % end of position calculation % % % %


% Return zeros if it was not possible to estimate a position
if (iterations > 20)
   pos = [0 0 0];
   rec_clk = 0;
else
   pos = StartGuess(1,1:3);
   rec_clk = StartGuess(1,4);
end
