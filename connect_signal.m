%coding=<GB 2312>
function output = connect_signal (A,del_begin,del_end,original_length)
    % 输入切分后的序列,但要恢复到原先的状态
    %非零序列和零序列应该是交替进行的
    output=zeros(1,original_length);
    the_end_list=[del_begin-1, original_length];
    the_begin_list=[1, del_end+1];

    if del_begin(1)==0
        the_end_list(1)=[];
        the_begin_list(1)=[];
    end
    
    if del_end(end)==original_length
        the_begin_list(end)=[];
        the_end_list(end)=[];
    end

    end_i=0;
    for i=1:length(the_begin_list)
        length_i=the_end_list(i)-the_begin_list(i)+1;
        open_i=end_i+1;
        end_i=end_i+length_i;
        output(the_begin_list(i):the_end_list(i))=A(open_i:end_i);
    end
end        
