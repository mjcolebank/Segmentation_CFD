function [simple_conn,terminal] = find_simple_connectivity(conn_mat,details)
%% Note, this function processes based on the index of the matrix NOT the vessel number
M = size(conn_mat,1)-1;
% simple_conn = zeros(M,3);
temp_conn = zeros(M,3);
update_conn = zeros(M,3);
toss = [];
terminal = [];
for i=2:M+1
    clear who where radii_keep;
    k=2;
    radii_index = [];
    radii_comp  = [];
    daughters   = [];
    if any(toss == i) %Get rid of vessels that are part of trifurcation
        while ~isempty(conn_mat{i,k})% principal pathway
            if strcmp(conn_mat{i,2},'TERMINAL')
                break;
            end
            toss(end+1) = str2double(conn_mat{i,k}(2:end))+2;
            k=k+1;
        end
    elseif strcmp(conn_mat{i,2},'TERMINAL')
        terminal(end+1) = i;
    elseif ~isempty(conn_mat{i,4})  % Take only the vessels in 
        while ~isempty(conn_mat{i,k})% principal pathway
            radii_index(end+1) = str2double(conn_mat{i,k}(2:end))+2;
            radii_comp(end+1)  = details{radii_index(end),4};
            % Need to also include something to check how many generations
            % are downstream
%             daughters(end+1) = length(conn_mat{radii_index(end),9});
            k=k+1;
        end
        [who, where] = sort(radii_comp,'descend');
%         [who_daughters,where_daughters] = sort(daughters,'descend');
%         1
        radii_keep = radii_index(where(1:2));
        radii_toss = radii_index(where(3:end));
        toss_size = length(radii_toss);
        toss(end+1:end+toss_size) = radii_toss;
%         radii_toss = radii_index(where(3:end));
        temp_conn(i,1) = str2double(conn_mat{i,1}(2:end))+2;
        temp_conn(i,2:3) = radii_keep;
    else
       temp_conn(i,1) = str2double(conn_mat{i,1}(2:end))+2;
       temp_conn(i,2) = str2double(conn_mat{i,2}(2:end))+2;
       temp_conn(i,3) = str2double(conn_mat{i,3}(2:end))+2;
    end
end
% This check needs to implemented if a geometry has a false bifurcation
% if any(isnan(temp_conn))
%    display(nan) 
% end
%% This is for updating the vessel ID's once we've ignored a trifurcation
% for i=1:length(toss)
%    for j=1:M
%        if temp_conn(j,1) >= toss(i)
%            update_conn(j,1) = update_conn(j,1)+1;
%        end
%        if temp_conn(j,2) >= toss(i)
%            update_conn(j,2) = update_conn(j,2)+1;
%        end
%        if temp_conn(j,3) >= toss(i)
%            update_conn(j,3) = update_conn(j,3)+1;
%        end        
%    end
%    term_where = find(terminal >= toss(i));
%    terminal(term_where) = terminal(term_where)-1;
% end
temp_conn = temp_conn - update_conn;
parents = find(sum(temp_conn,2) > 0); %-1 for wanting vessel name (starts at 0)
simple_conn = temp_conn(parents,:); %+1 so indicies are greater than zero
end