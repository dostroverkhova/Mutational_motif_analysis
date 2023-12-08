%script_combine_mut_calls

%combine mutation calls

disp('formatting output');


caller1 = importMAFfile('./colorectal_data/TCGA.COAD.muse.70cb1255-ec99-4c08-b482-415f8375be3f.DR-10.0.somatic.maf');
caller2 = importMAFfile('./colorectal_data/TCGA.COAD.mutect.03652df4-6090-4f5a-a2ff-ee28a37f9301.DR-10.0.somatic.maf');
caller3 = importMAFfile('./colorectal_data/TCGA.COAD.somaticsniper.70835251-ddd5-4c0d-968e-1791bf6379f6.DR-10.0.somatic.maf');
caller4 = importMAFfile('./colorectal_data/TCGA.COAD.varscan.8177ce4f-02d8-4d75-a0d6-1c5450ee08b0.DR-10.0.somatic.maf');

combined_maf_file = combineMutCallers(caller1,caller2, caller3, caller4);

writetable(combined_maf_file, 'TCGA.COAD.combined.somatic.maf', 'FileType', 'text','Delimiter','\t');
save('MATLAB_TCGA.COAD.combined.somatic.mat', '-v7.3','combined_maf_file');


disp('done formatting');
