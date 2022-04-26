%Putting data obtained from the excel sheet into a matrix
udata = readmatrix('data.xlsx','Range','A2:A17');
tdata = readmatrix('data.xlsx','Range','B2:B17');
fdata= readmatrix('data.xlsx','Range','D2:D17');
Direction = readcell('data.xlsx' ,'Range','C2:C17');
% Since there are n number of storms, there are n number of Hs,Tp and Ts
n=numel(udata);
Ts=zeros(n,1);
Hs=zeros(n,1);
Tp=zeros(n,1);
Ua=zeros(n,1);
Sea_State="";
for i=1:n  
u=udata(i);
f=fdata(i);
t=tdata(i);
ua=0.71*(u^1.23);
g=9.81;
fstar=g*f*1000/(ua^2);
tstar=g*t*3600/ua;
% Fully Developed Sea
hs1=0.243*ua*ua/g;
tp1=8.13*ua/g;
fcondstar=(tstar/68.8)^(3/2);
% Developing Sea
if fcondstar<fstar
    % Duration Limited
    hs2=0.0016*fcondstar^(1/2)*ua*ua/g;
    tp2=0.286*fcondstar^(1/3)*ua/g;
    Sea_State(i,1)='Developing Sea - Duration Limited';
else
    % Fetch Limited
    hs2=0.0016*fstar^(1/2)*ua*ua/g;
    tp2=0.286*fstar^(1/3)*ua/g;
    Sea_State(i,1)='Developing Sea - Fetch Limited';
end
% Take Smaller Hs
if hs1<hs2
    hsresult=hs1;
    tpresult=tp1;
    Sea_State(i,1)='Fully Developed Sea';
else
    hsresult=hs2;
    tpresult=tp2;
end
Ts(i)=tpresult/1.05;
Hs(i)=hsresult;
Tp(i)=tpresult;
Ua(i)=ua;
end
results=table(Direction,Ua,Hs,Tp,Ts,Sea_State)