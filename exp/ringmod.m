% Step 1. Specify Equations and Variables
syms x1(t) x2(t) x3(t) x4(t) x5(t) x6(t) x7(t) x8(t) x9(t) x10(t) x11(t) x12(t) x13(t) x14(t) x15(t)

C   = 1.6e-8;
Cp  = 1e-8;
Lh  = 4.45;
Ls1 = 0.002;
Ls2 = 5e-4;
Ls3 = 5e-4;
gam = 40.67286402e-9;
R   = 25000;
Rp  = 50;
Rg1 = 36.3;
Rg2 = 17.3;
Rg3 = 17.3;
Ri  = 50;
Rc  = 600;
del = 17.7493332;

syms t real
q = symfun(gam * (exp(del*t) - 1), t);
Uin1 = symfun(0.5 * sin(2000*pi*t), t);
Uin2 = symfun(2 * sin(20000*pi*t), t);
UD1 =  x3(t) - x5(t) - x7(t) - Uin2(t);
UD2 = -x4(t) + x6(t) - x7(t) - Uin2(t);
UD3 =  x4(t) + x5(t) + x7(t) + Uin2(t);
UD4 = -x3(t) - x6(t) + x7(t) + Uin2(t);

eqns = [
    diff(x1(t)) - 1/C *(x8(t) - 0.5*x10(t) + 0.5*x11(t) + x14(t) - x1(t)/R)
    diff(x2(t)) - 1/C *(x9(t) - 0.5*x12(t) + 0.5*x13(t) + x15(t) - x2(t)/R)
     x10(t) - q(UD1) + q(UD4)
    -x11(t) + q(UD2) - q(UD3)
     x12(t) + q(UD1) - q(UD3)
    -x13(t) - q(UD2) + q(UD4)
    diff(x7(t)) - 1/Cp*(-x7(t)/Rp + q(UD1) + q(UD2) - q(UD3) - q(UD4))
    diff(x8(t)) + x1(t)/Lh
    diff(x9(t)) + x2(t)/Lh
    diff(x10(t)) - 1/Ls2*( 0.5*x1(t) - x3(t) - Rg2*x10(t))
    diff(x11(t)) - 1/Ls3*(-0.5*x1(t) + x4(t) - Rg3*x11(t))
    diff(x12(t)) - 1/Ls2*( 0.5*x2(t) - x5(t) - Rg2*x12(t))
    diff(x13(t)) - 1/Ls3*(-0.5*x2(t) + x6(t) - Rg3*x13(t))
    diff(x14(t)) - 1/Ls1*(-x1(t) + Uin1(t) - (Ri+Rg1)*x14(t))
    diff(x15(t)) - 1/Ls1*(-x2(t) - (Rc+Rg1)*x15(t))
];
vars = [x1(t) x2(t) x3(t) x4(t) x5(t) x6(t) x7(t) x8(t) x9(t) x10(t) x11(t) x12(t) x13(t) x14(t) x15(t)];


% Step 2. Reduce Differential Order (do nothing for this DAE because there is no higher order derivatives)
[eqns, vars] = reduceDifferentialOrder(eqns, vars);


% Step 3. Check and Reduce Differential Index
if ~isLowIndexDAE(eqns, vars)
    fprintf('DAE is high-index.\n') % this will be printed
    
    % Try to reduce the index by reduceDAEIndex
    % but it ends in failure with warning message "Warning: Index of reduced DAEs is larger than 1."
    [DAEs, DAEvars] = reduceDAEIndex(eqns, vars);
    if eqns == DAEs & DAEvars == vars
        fprintf('No modification.\n')
    end
    
    % ...we proceed anyway
end


% Step 4. Convert DAE Systems to MATLAB Function Handles
F = daeFunction(DAEs, DAEvars);


% Step 5. Find Initial Conditions For Solvers
y0est = zeros(15, 1);
yp0est = [0 0 6.2831853071796e4 -6.2831853071796e4 -6.2831853071796e4 6.2831853071796e4 0 0 0 0 0 0 0 0 0];
opt = odeset('jacobian', provide_jacobian(DAEs, DAEvars)); % provide Jacobians ("provide_jacobian" is defined later)
[y0, yp0] = decic(F, 0, y0est, [], yp0est, [], opt);


% Step 6. Solve DAEs Using ode15i
[tSol, ySol] = ode15i(F, [0, 1e-3], y0, yp0, opt);
plot(tSol, ySol(:,1:15), '-o')

for k = 1:15
  S{k} = char(DAEvars(k));
end

legend(S, 'Location', 'Best')
grid on


% function that returns a function handle of Jacobians
function JFun = provide_jacobian(eqns, vars)
    yp = sym('yp', [15 1]);
    y = sym('y', [15 1]);
    eqns = subs(subs(eqns, diff(vars), yp), vars, y); % change xi(t) to yi and diff(xi(t)) to ypi for i = 1,...,15
    Jp = matlabFunction(jacobian(eqns, yp)); % compute Jacobian by "jacobian" and convert it into a matlab function by "matlabFunction"
    J  = matlabFunction(jacobian(eqns, y ));
    
    function [Jval, Jpval] = JF(t, x, xp)
        Jval  = J(t, x(3), x(4), x(5), x(6), x(7)); % J depends on t and x3(t),...,x7(t)
        Jpval = Jp();                               % Jp is constant
    end
    
    JFun = @JF;
end

