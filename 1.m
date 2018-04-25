idLen = length(id);
for i = 1:9000:idLen
    flag = 0;
    idsLen = length(ids);
    for j = 1:idsLen
        if strcmp(id(i, 1), ids(1, j))
            flag = 1;
            break;
        end
    end
    if ~flag
        ids(1, idsLen + 1) = id(i,1);
    end
end

t=num(1:128562,1);
v=num(1:128562,2);
l=num(1:128562,3);
ti=t(1,1):60:t(128562,1);
vi=interp1(t,v,ti,'liner');
li=interp1(t,l,ti,'liner');
ti=ti';
vi=vi';
li=li';
xlswrite('newtrain.xlsx',ti,'A2:A131796');
xlswrite('newtrain.xlsx',vi,'B2:B131796');
xlswrite('newtrain.xlsx',li,'C2:C131796');

t=num(128563:257175,1);
v=num(128563:257175,2);
l=num(128563:257175,3);
ti=t(1,1):60:t(128613,1);
vi=interp1(t,v,ti,'liner');
li=interp1(t,l,ti,'liner');
ti=ti';
vi=vi';
li=li';
xlswrite('newtrain.xlsx',ti,'A131797:A263591');
xlswrite('newtrain.xlsx',vi,'B131797:B263591');
xlswrite('newtrain.xlsx',li,'C131797:C263591');

startX = 257176;
endX = 386210;
len = endX - startX + 1;
t = num(startX:endX, 1);
v = num(startX:endX, 2);
l = num(startX:endX, 3);
ti = t(1, 1) : 60 : t(len, 1);
vi = interp1(t, v, ti, 'liner');
li = interp1(t, l, ti, 'liner');
ti = ti';
vi = vi';
li = li';
len = length(ti);
startX = 263592;
endX = startX + len - 1;
xlswrite('newtrain.xlsx',ti,['A', num2str(startX), ':A', num2str(endX)]);
xlswrite('newtrain.xlsx',vi,['B', num2str(startX), ':B', num2str(endX)]);
xlswrite('newtrain.xlsx',li,['C', num2str(startX), ':C', num2str(endX)]);

start = endX + 1;
startX = 1;
endX = 128971;
t = num(startX : endX, 1);
v = num(startX : endX, 2);
l = num(startX : endX, 3);
ti = t(1, 1) : 60 : t(endX, 1);
vi = interp1(t, v, ti, 'liner');
li = interp1(t, l, ti, 'liner');
ti = ti';
vi = vi';
li = li';
len = length(ti);
endX = start + len - 1;
xlswrite('newtrain.xlsx',ti,['A', num2str(start), ':A', num2str(endX)]);
xlswrite('newtrain.xlsx',vi,['B', num2str(start), ':B', num2str(endX)]);
xlswrite('newtrain.xlsx',li,['C', num2str(start), ':C', num2str(endX)]);

for i = 1:266
    for j = 1:13
        if isnan(ckd(i, j))
            ckd(i, j) = ckd(i - 1, j);
        end
    end
end

for i = 1:1048575
    for j = 1:32055
        if isequal(testNum(i, 1), er(j, 1))
            testLable(i, 1) = 1;
        end
    end
end

function [ date ] = ConvertDate( x )  
%将unix时间戳转换为标准时间  
date = datestr(x/86400 + 719529);  
date = datestr((x-3600*24+8*3600)/86400 + 70*365+19);  
end 

day = zeros(len, 1);
hour = zeros(len, 1);
parfor i = 1:len
    date = datestr(t(i, 1)/86400 + 719529);
    %date = datestr(date);
    day(i, 1) = weekday(datenum(date), 'long');
    date = datevec(date);
    hour(i, 1) = date(1, 4);
end

pLen = length(p);
for i = 1:pLen
    if hour(p(i, 1)) == 16
        pi = [pi, p(i, 1)];
    end
end
    