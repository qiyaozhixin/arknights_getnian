%���룺��֪��ĳ���Ϊ0.7%��50������û��һ�鲻������+2%���ʣ�2%���ʳ鵽6�Ǿ����ø���
%������󵥵���ĳ�������

%˼·��1000000���˽��г�ȡ �洢ÿһ���˵ĳ��������һ��1*1000000�ľ����У�������ֵ

clear;
clc;

getnian = 0;
output = zeros(1,1000000);
for i = 1:1000000                       %iΪ��ȡ��������10000��
    j = 0;                                  %jΪ��ȡ����
    k = 0;                                  %kΪ��ǰ��ȡδ��������
    getnian = 0;
    while getnian == 0
       k = k + 1;
       p = rand;
       if k <= 50                           %��ǰ50������
           if p < 0.007                     %50�����ڳ���
               getnian = 1;
               j = j + k;
           end
           if p >= 0.007 && p < 0.02        %50�����ڳ�������6��
               j = j + k;             
               k = 0;
           end
       end
       if k > 50                            %��ǰ50������
           if p < 0.007 + 0.02 * 0.35 * (k - 50)    %50�����ϳ���
               getnian = 1;
               j = j + k;
           end
           if p >= 0.007 + 0.02 * 0.35 * (k - 50)  && p < 0.02 + 0.02 * (k - 50)        %50�����ϳ�������6��
               j = j + k;
               k = 0;
           end
       end
    end
    output(1,i) = j;
end

expect = mean(output(:));
fprintf('��һ����β��ԣ�ƽ����Ҫ%f����ܳ��꣬ϴϴ˯��\n',expect)

figure;
cdfplot(output);
figure;
ymin=min(output);
ymax=max(output);
x=linspace(ymin,ymax,100);
yy=hist(output,x);
yy=yy/length(output);
bar(x,yy)