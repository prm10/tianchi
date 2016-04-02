function F=calculateF(target,prediction)
err=(prediction-target)./max(target,ones(size(target)));
yita=sqrt(mean(err.^2,2));
w=sqrt(sum(target,2));
F=(1-yita)'*w;