function p=my_predict(theta,bias,n,y0)
%����m������y0������theta��Ԥ��n��
m=length(theta);% also =length(y0)
p=zeros(n,1);
h=zeros(m,1);
for i1=1:n
    if(i1<=m)
        h(1:m-i1+1)=y0(i1:m);
        h(m-i1+2:m)=p(1:i1-1);
    else
        h=p(i1-m:i1-1);
    end
    p(i1)=h(end:-1:1)'*theta+bias;
end