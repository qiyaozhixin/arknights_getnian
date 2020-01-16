%输入：已知年的出率为0.7%；50抽以上没多一抽不出货就+2%概率；2%概率抽到6星就重置概率；10次内必出5星及5星以上
%输出：求单吊年的抽数期望

%思路：100000000个人进行抽取 存储每一个人的出货结果到一个1*100000000的矩阵中，最后求均值

clear;
clc;

getnian = 0;
output = zeros(1,100000000);
for i = 1:100000000                       %i为抽取人数，共100000000人
    j = 0;                                  %j为抽取次数
    k = 0;                                  %k为当前抽取未出货次数
    getnian = 0;
    bd = 0;
    bdflag = 0;
    while getnian == 0
       k = k + 1;
       p = rand;
       if p >= 0.1 && bdflag == 0           %保底计数+1
           bd = bd + 1;
       end
       if p < 0.1 && bd < 10                %前10抽内抽到5星及5星以上则不触发保底
           bdflag = 1;
       end
       if bd == 10 && bdflag == 0           %触发保底
           p = p * 0.1;
           bdflag = 1;
       end
       if k <= 50                           %当前50抽以内
           if p < 0.007                     %50抽以内出年
               getnian = 1;
               j = j + k;
           end
           if p >= 0.007 && p < 0.02        %50抽以内出了其他6星
               j = j + k;             
               k = 0;
           end
       end
       if k > 50                            %当前50抽以上
           if p < 0.007 + 0.02 * 0.35 * (k - 50)    %50抽以上出年
               getnian = 1;
               j = j + k;
           end
           if p >= 0.007 + 0.02 * 0.35 * (k - 50)  && p < 0.02 + 0.02 * (k - 50)        %50抽以上出了其他6星
               j = j + k;
               k = 0;
           end
       end
    end
    output(1,i) = j;
end

expect = mean(output(:));
fprintf('经一亿次测试，平均需要%f抽才能出年\n',expect)
standard_deviation = std(output);
fprintf('标准差为%f\n',standard_deviation)
fprintf('最大值为为%f\n',max(output))
pct = prctile(output,[10,20,30,40,50,60,70,80,90]);

for i = 1:9
    fprintf('如果在%.f抽内出了年，则击败了%.f%%的玩家\n',pct(1,i),(10-i) * 10)
end

figure;
cdfplot(output);
title('累计分布');
figure;
ymin=min(output);
ymax=max(output);
x=linspace(ymin,ymax,100);
yy=hist(output,x);
yy=yy/length(output);
bar(x,yy)
title('概率密度');