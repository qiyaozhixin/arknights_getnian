%输入：已知年的出率为0.7%；50抽以上没多一抽不出货就+2%概率；2%概率抽到6星就重置概率
%输出：求单吊年的抽数期望

%思路：1000000个人进行抽取 存储每一个人的出货结果到一个1*1000000的矩阵中，最后求均值

clear;
clc;

getnian = 0;
output = zeros(1,1000000);
for i = 1:1000000                       %i为抽取人数，共1000000人
    j = 0;                                  %j为抽取次数
    k = 0;                                  %k为当前抽取未出货次数
    getnian = 0;
    while getnian == 0
       k = k + 1;
       p = rand;
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
fprintf('经一百万次测试，平均需要%f抽才能出年\n',expect)
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