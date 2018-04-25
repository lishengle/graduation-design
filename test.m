for i = 1:9180
    if p(i + 1, 1) - p(i, 1) ~= 1
        break;
    end
end

IDIndex = zeros(10, 2);
index = 1;
for i = 1:len
    if i == 1
        IDIndex(index, 1) = i;
    else if ~isequal(allID{i, 1}, ids{1, index + 1})
            IDIndex(index, 2) = i - 1;
            index = index + 1;
            IDIndex(index, 1) = i;
        end
    end
end
IDIndex(10, 2) = len;

day = zeros(len, 1);
hour = zeros(len, 1);
parfor i = 1:len
    date = datestr(t(i, 1)/86400 + 719529);
    %date = datestr(date);
    day(i, 1) = weekday(datenum(date), 'long');
    date = datevec(date);
    hour(i, 1) = date(1, 4);
end

stratTime = index(1, 1);
endTime = index(1, 2);
day = trainNum(2:100001, 5);
hour = trainNum(2:100001, 6);
predict = zeros(100000, 1);
for nowDay = 1:7
    for nowHour = 1:24
        temp = find(day == nowDay);
        tempLen = length(temp);
        p = [];
        for a = 1:tempLen
            if hour(temp(a, 1)) == nowHour
                p = [p, temp(a, 1)];
            end
        end
        p = p';
        nowValue = v(p);
        meanValue = mean(nowValue);
        stdValue = std(nowValue);
        pLen = length(p);
        for a = 1:pLen
            if v(p(a, 1), 1) > meanValue + stdValue ||  v(p(a, 1), 1) < meanValue - stdValue
                predict(p(a, 1), 1) = 1;
            end
        end
    end
end
            
        
        
        
        
        