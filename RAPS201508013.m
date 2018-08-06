clear
[A,R,DUR] = instanceG(150);%%%scale
RR_U = 999999;%%%
N = length(A);
N_RR = size(R,1);
NT = 1000;%%%%%%%%时间段参数
M=99999999;
x = binvar(N,NT,'full');
a = binvar(N,NT,'full');
b = binvar(N,NT,'full');
st = intvar(1,N,'full');
ft = intvar(1,N,'full');
TD = intvar(1,1,'full');
CX = [];
tic;
disp(['1:',num2str(toc)]);
CX = [CX, st(1) == 0];

CX = CX + (ft >= st + DUR);
  
CX = CX + (ft <= TD);
    
for i=1:N
    CX = CX + (ft(i)*A(i,:) <= st(1,:));
end

disp(['4:',num2str(toc)]);
for k=1:N_RR
    for t=1:NT
        CX = [CX,R(k,:)*x(:,t) <= RR_U(k)];
    end
end

disp(['5:',num2str(toc)]);
Ti = (1:NT)';
for i=1:N
%    for t=1:NT
%         CX = [CX, a(i,t)*M > (t-st(1,i))];
%         CX = [CX, (1-a(i,t))*M > (st(1,i)-t)];
%         CX = [CX, b(i,t)*M >= (ft(1,i)-t+1)];
%         CX = [CX, (1-b(i,t))*M >= (t-ft(1,i))];
        CX = [CX, a(i,:)*M > (Ti'-st(1,i))];
        CX = [CX, (1-a(i,:))*M > (st(1,i)-Ti')];
        CX = [CX, b(i,:)*M >= (ft(1,i) - Ti' + 1)];
        CX = [CX, (1 - b(i,:))*M >= (Ti' - ft(1,i))];
%    end
end
CX = [CX, x >= a + b - 1];
disp(['6:',num2str(toc)]);

%f = x*C + 10*ft(N);
%f = x*C;
f = TD;
options = sdpsettings('solver','gurobi');
% options.gurobi.MIPGap = 0.001;
% options.gurobi.MIPGapAbs = 0.00001;
options.gurobi.TimeLimit = 60*5;
%sol = solvesdp(F,f,options)
sol = solvesdp(CX,f,options);
sol
