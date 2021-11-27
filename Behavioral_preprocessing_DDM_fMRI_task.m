clear all;

Path = 'E:\CSCN\Believe_fmri_Danish&China\Believe_Danish&China\behavior\Convert_Chinese';
savePath = 'E:\CSCN\Believe_fmri_Danish&China\Believe_Danish&China\behavior\Convert_Chinese';

subnum=[1:9,11:37];
for i = 1: length(subnum) 
    Subject{i,1}=['sub',num2str(subnum(i),'%.2d')]; 
end;
filename = {'MS1','MS2'}; %% .txt line 10

fp=fopen('ddm_sum_Chinese_self_referential_task_allsubjects.txt','a');
fprintf(fp,'%s\t%s\t%s\t%s\n','subj_idx','Type','rt','response');

%%

for sub = 1:length(Subject)  
    
    fprintf([Subject{sub},'...\n']);
    
    for f = 1:length(filename)   
        fid = fopen(fullfile(Path,Subject{sub},'logfile',[filename{f},'.log'])); 
        C = textscan(fid, '%s%d%s%s%f%f %f%f%f%f%f','delimiter','\t','headerlines',6);
        fclose(fid);
       %% Prepare the code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           Code=C{1,4};
           Time=C{1,5};
            temp = regexp(Code,'ºÚÌå');
            for i=1:length(temp) 
                if isempty(temp{i,1})==1; 
                   Index(i,1)=0;
                else Index(i,1)=1; 
                end;
            end;
            Num = find(Index==1); % localize the columms of all trials 
            Condition_list={};
            j=1;
            delete_trials=[];
            for i =1:length(Num)
            Condition_list{i,1}=Code{Num(i),1}(1:14);
            response_list{i,1}=Code{Num(i)+1,1}(1);
            RT_list{i,1}= (Time(Num(i)+1)-Time(Num(i)))./10000;
            if Code{Num(i)+1,1}=='fix'
                delete_trials(j,1)=i;
                j=j+1;
            end                
            end
               Condition_out = cell2mat(Condition_list);
                response_out = cell2mat(response_list);
               RT_out = cell2mat(RT_list);
            Condition_out(delete_trials,:)=[];
            response_out(delete_trials,:)=[];
             RT_out(delete_trials)=[];
            RT_out=single(RT_out);
           for r=1:length(RT_out)
    
          fprintf(fp,'%d\t%s\t%5.2f\t%s\n',sub-1, Condition_out(r,:), RT_out(r), response_out(r));
    
           end

                  
          clear C Code Time delete_trials Num Index Condition_list RT_list response_list Condition_out  response_out  RT_out ;     
        end;                         
     end;    
     
      fclose(fp);
 
 
 
