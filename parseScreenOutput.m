function reformated_table = parseScreenOutput(filename, numFieldsPerBlock)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
reformated_table = table;
fileID = fopen(filename,'r');

cnt = 0;
%loop through each 'DEBUG {'
%find first block
while ~feof(fileID)
    InputText = textscan(fileID,'%s',1,'delimiter','\n');  % Read lines
    if ~contains(InputText{:},'DEBUG {')
        continue;
    else
        cnt = cnt+1;
        %         disp(['block ' num2str(cnt)]);
        InputText = strrep(InputText{:}, 'DEBUG {   ', '');
        block = textscan(fileID,'%s',numFieldsPerBlock-1,'delimiter','\n');  % Read block
        block = [InputText; block{:}];
        [headers,values] = strtok(block, ':');
        headers = strrep(headers, '''', '');
        values = strrep(values, ': ', '');
        values = strrep(values, ',', '');
        values = strrep(values, '}', '');
        values = strrep(values, '''', '');
        if cnt == 1 %first block - create the table
            reformated_table = cell2table(values', 'VariableNames', headers);
        else
            reformated_table = [reformated_table; values'];
        end
        if mod(cnt, 1000) == 0 
            disp(['block ' num2str(cnt)]);
        end
	if mod(cnt, 10000) == 0
		save('intermidfile.mat','reformated_table','cnt');
	end
    end
end

disp('done processing all blocks');
%continue for the rest of the blocks


fclose(fileID);

end


