function combined_maf_file = combineMutCallers(caller1,caller2, caller3, caller4)
%combineMutCallers combines the mutational calls of different algorithms
%based on majority vote.

combined_maf_file = caller1(1,:);
%empty the table, we don't want to simply take the union, we want majority
%voting
types = varfun(@class, combined_maf_file, 'OutputFormat', 'cell');
combined_maf_file(:, strcmp(types, 'cell')) = {''};
combined_maf_file(:, strcmp(types, 'double')) = {NaN};

allsamples = unique(caller1.Tumor_Sample_Barcode);
allchr = unique(caller1.Chromosome);
numberOfCallers = 4;
currInd = 1;

%for each sample
for i=201:length(allsamples)
    disp(['processing sample ' allsamples{i} ',index ' num2str(i)]);
    %for each chromosome
    for j=1:length(allchr)
        curr_caller1 = caller1(strcmpi(caller1.Tumor_Sample_Barcode, allsamples(i)), :);
        curr_caller2 = caller2(strcmpi(caller2.Tumor_Sample_Barcode, allsamples(i)), :);
        curr_caller3 = caller3(strcmpi(caller3.Tumor_Sample_Barcode, allsamples(i)), :);
        curr_caller4 = caller4(strcmpi(caller4.Tumor_Sample_Barcode, allsamples(i)), :);
        curr_caller1 = curr_caller1(strcmpi(curr_caller1.Chromosome, allchr(j)), :);
        curr_caller2 = curr_caller2(strcmpi(curr_caller2.Chromosome, allchr(j)), :);
        curr_caller3 = curr_caller3(strcmpi(curr_caller3.Chromosome, allchr(j)), :);
        curr_caller4 = curr_caller4(strcmpi(curr_caller4.Chromosome, allchr(j)), :);
        allStartPositions = unique([curr_caller1.Start_Position;...
            curr_caller2.Start_Position; curr_caller3.Start_Position;curr_caller4.Start_Position;]);
        disp(['processing chr ' allchr{j} ',index ' num2str(j)]);
        for k=1:length(allStartPositions)
%             disp(['processing position ' num2str(allStartPositions(k)) ',index ' num2str(k)]);
            flag1 = curr_caller1.Start_Position==allStartPositions(k);
            flag2 = curr_caller2.Start_Position==allStartPositions(k);
            flag3 = curr_caller3.Start_Position==allStartPositions(k);
            flag4 = curr_caller4.Start_Position==allStartPositions(k);
            %add the mutation for this sample and chromosome to the
            %outputfile only if there is a consensus voting.
            if min(1,sum(flag1))+min(1,sum(flag2))+min(1,sum(flag3))+ min(1,sum(flag4)) >= numberOfCallers/2
                if sum(flag1)>=1                    
                    combined_maf_file(currInd:currInd+sum(flag1)-1, :)=curr_caller1(flag1,:);currInd = currInd+sum(flag1);
                elseif sum(flag2)>=1
                    combined_maf_file(currInd:currInd+sum(flag2)-1, :)=curr_caller2(flag2,:);currInd = currInd+sum(flag2);
                elseif sum(flag3)>=1
                    combined_maf_file(currInd:currInd+sum(flag3)-1, :)=curr_caller3(flag3,:);currInd = currInd+sum(flag3);
                else
                    combined_maf_file(currInd:currInd+sum(flag4)-1, :)=curr_caller4(flag4,:);currInd = currInd+sum(flag4);
                end
            end
        end
    end
end
