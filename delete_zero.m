function final_output = delete_zero(A,n,threshold)
% ��������,��Ҫɾ��������0���ٳ���n,
%�ú�����ɾ�����ڵ���n��������0,������ɾ������ʼ��
%���������������,��������Ϊ������
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
            delete_begin=[delete_begin,i]; %��¼ɾ���Ŀ�ͷ�ͽ�β��ָ��
            delete_end=[delete_end,n+i+j-2];
            %ע������������������
            
            output(i:n+i+j-2)=pi;  %����ЩҪɾ���ı��Ϊһ����Խ��,����ɾ��,����ֱ��������ɾ��,������ƻ����еĳ���
            output1(i:n+i+j-2)=0;  %���ֻ�ǽ���Щ������ֵ�� ,����������Ϊ0,����û��ɾ������
            i=n+i+j-2;
        else
            i=i+1;
        end
    end

    output(output==pi)=[]; %����ɾ������Щ��Чֵ�������
    final_output={output,output1,delete_begin,delete_end};
end