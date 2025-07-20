function [X,Y] = label_match(raw_X,raw_Y,label_X,label_Y)


% label match
match_list = zeros(size(label_X));

iter_label_Y = label_Y;

for k = 1:size(label_X,1)
    tempX = label_X(k,1);

    equal_idx = find(tempX==iter_label_Y);

    if size(equal_idx,1) ~= 0
        
        sel_idx = round(length(equal_idx)/2);

        match_list(k,1) = equal_idx(sel_idx);
    
        iter_label_Y(equal_idx(sel_idx)) = -1;
    else
        match_list(k,1) = -1;
    end
end

match_list_Y = match_list;
match_list_Y(match_list==-1) = [];

X = raw_X(match_list~=-1,:);
Y = raw_Y(match_list_Y,:);