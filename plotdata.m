function print
clc;clear;
matrix = xlsread('train.csv', 1, 'A2:C128562');
x = matrix(:, 1);
y = matrix(:, 2);
value = matrix(:, 3);
p = find(value == 1);
plot(x,y,'r','linewidth',2);
grid on;
text(x(p),y(p),'*','color','g');
[num, txt, raw] = xlsread('train.csv');
p = find(num(:, 1) == 1493568000);

file = fopen('newtrain.csv');
for i = 1:131793
    f = ['A',num2str(i + 1)];
    xlswrite(file,xi(1,i),[f,':',f]);
end
fclose(file)

 matrix=xlsread('train.csv',1,'A644019:C772989');
t=matrix(:,1);
v=matrix(:,2);
l=matrix(:,3);
ti=t(1,1):60:t(128971,1);
vi=interp1(t,v,ti,'nearest');
li=interp1(t,l,ti,'nearest');
ti=ti';
vi=vi';
li=li';
xlswrite('train2.xlsx',ti,'A2:A128972');
xlswrite('train2.xlsx',vi,'B2:B128972');
xlswrite('train2.xlsx',li,'C2:C128972');

matrix=xlsread('train.csv',1,'A772990:C901656');
t=matrix(:,1);
v=matrix(:,2);
l=matrix(:,3);
ti=t(1,1):60:t(128667,1);
vi=interp1(t,v,ti,'nearest');
li=interp1(t,l,ti,'nearest');
ti=ti';
vi=vi';
li=li';
xlswrite('train2.xlsx',ti,'E2:E128668');
xlswrite('train2.xlsx',vi,'F2:F128668');
xlswrite('train2.xlsx',li,'G2:G128668');

matrix=xlsread('train.csv',1,'A901657:C1030509');
t=matrix(:,1);
v=matrix(:,2);
l=matrix(:,3);
ti=t(1,1):60:t(128853,1);
vi=interp1(t,v,ti,'nearest');
li=interp1(t,l,ti,'nearest');
ti=ti';
vi=vi';
li=li';
xlswrite('train2.xlsx',ti,'I2:I128854');
xlswrite('train2.xlsx',vi,'J2:J128854');
xlswrite('train2.xlsx',li,'K2:K128854');
        
matrix=xlsread('train.csv',1,'A1030510:C1039293');
t=matrix(:,1);
v=matrix(:,2);
l=matrix(:,3);
ti=t(1,1):60:t(8784,1);
vi=interp1(t,v,ti,'nearest');
li=interp1(t,l,ti,'nearest');
ti=ti';
vi=vi';
li=li';
xlswrite('train2.xlsx',ti,'M2:M8785');
xlswrite('train2.xlsx',vi,'N2:N8785');
xlswrite('train2.xlsx',li,'O2:O8785');
matrix=xlsread('train.csv',1,'A1039294:C1048576');
t=matrix(:,1);
v=matrix(:,2);
l=matrix(:,3);
ti=t(1,1):60:t(9282,1);
vi=interp1(t,v,ti,'nearest');
li=interp1(t,l,ti,'nearest');
ti=ti';
vi=vi';
li=li';
xlswrite('train2.xlsx',ti,'Q2:Q9283');
xlswrite('train2.xlsx',vi,'R2:R9283');
xlswrite('train2.xlsx',li,'S2:S9283');

        
