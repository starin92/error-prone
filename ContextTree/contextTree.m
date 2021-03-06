%%%%% Author: Pedro Borges
%%%%% Reads Log from file and creates a context tree
%%%%% Input: 
%%%%%   File: File containing lines of CALL name and RETURN name
%%%%% Ouput: 
%%%%%    tree: Calling Context Tree resulting from the prossecing of the
%%%%%    file
function [ tree ] = contextTree( File )

fid = fopen(File);

aux = fgetl(fid);
tline(1) = {aux};
i = 2;
while ischar(aux)
    %% disp(tline);
    aux= fgetl(fid);
    tline(i) = {aux};
    i = i+1;
end

fclose(fid);

i = 0;
aux = 'a';
%%% Initialize the data structure of the tree
tree = {};
%treeNode = struct('name', 'init', 'parent', 'init','child', {}, 'times_called',0, 'index',1); %% Parent contains the index of the parent in the tree array. Child contains the index of the child in the tree array
treeNode.name = 'ROOT';
treeNode.parent = [];
treeNode.child = [];
treeNode.times_called = 1;
treeNode.index = 1;
tree{1} = treeNode;
already_child = false; %% initializes the variable that checks if a node already has the presented child
node_index = 2;

for i = 1:length(tline)-1
    aux = char(tline(i));
    [token, remain] = strtok(tline(i));
    remain = char(remain);
    remain = strtrim(remain); %% Take off the white space that is in the begining
    if ~isempty(strfind( aux, 'CALL')) %% there is the word CALL in the line
        
        %%%% if it is the root
        if node_index == 2
            
            treeNode.child = node_index;
            tree{1} = treeNode; %% updates the parents with the info of the current child
            
            treeNode.name = remain;
            treeNode.parent = 1;
            treeNode.child = [];
            treeNode.times_called = 1;
            treeNode.index = node_index; %% node index is 1
            
            tree{node_index} = treeNode;
            
            node_index = node_index +1; %% increments only when adds a node
        else
            if ~isempty(treeNode.child)
                %%% loops over the children to check if the one now already
                %%% exists
                for j = 1:length(treeNode.child)
                    
                    if node_index == 4
                    end
                    
                    if strfind(tree{treeNode.child(j)}.name, remain) >=1 %% If found the call as one of the children, doesn't add again
                        already_child = true;
                        child_index = treeNode.child(j);
                    end
                end
                
            else
                already_child = false;
            end
            
            if already_child == false %% If didn't find the child, adds it and goes to it
                % node_index = node_index +1; %% index of the child
                
                treeNode.child(end+1) = node_index;
                tree{treeNode.index} = treeNode; %% updates the current tree node
                
                %%% treeNode is now the child
                treeNode.name = remain;
                treeNode.parent = treeNode.index;
                treeNode.child = [];
                treeNode.times_called = 1;
                treeNode.index = node_index;
                tree{node_index} = treeNode;
                
                node_index = node_index +1; %%% increments only if it was not a child. Which means I am adding the node
                
            elseif already_child ==true
                already_child = false;
                called = tree{child_index}.times_called;
                called = called +1;
                tree{child_index}.times_called = called;
                treeNode = tree{child_index}; %% accesses the child
            end
        end
        
    elseif ~isempty(strfind( aux, 'RETURN')) %% there is the word RETURN in the line
        if ~isempty(treeNode.parent) %% if it is empty it is the root
            treeNode = tree{treeNode.parent};
        end
    end
end
end