function final_output = delete_zero(A,n,threshold)
% 输入序列,和要删除的连续0最少长度n,
%该函数将删除大于等于n的连续的0,并返回删除的起始点
%输出可以是行向量,但最后输出为列向量
    B=(A>threshold).*A;
    delete_begin=[];
    delete_end=[];
    len=length(A);

    output=reshape(A,len,1);
    output1=output;
    i=1;
    while i<=len-n+1
        j=0;

        while sum(B(i:i+j+n-1))==0
            if (i+j+n-1)==len
                j=j+1;
                break;
            else
                j=j+1;
            end
        end
        
        if j>0
            delete_begin=[delete_begin,i]; %记录删除的开头和结尾的指标
            delete_end=[delete_end,n+i+j-2];
            %注意这两个都是行向量
            
            output(i:n+i+j-2)=pi;  %将这些要删除的标记为一个超越数,方便删除,不能直接在这里删除,否则会破坏序列的长度
            output1(i:n+i+j-2)=0;  %这个只是将那些低于阈值的 ,且连续的置为0,而并没有删除他们
            i=n+i+j-2;
        else
            i=i+1;
        end
    end

    output(output==pi)=[]; %这是删除掉那些无效值后的序列
    final_output={output,output1,delete_begin,delete_end};
end