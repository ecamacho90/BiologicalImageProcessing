function mm=meannonan(x,dim)

si=size(x);
if length(si)~=2
    error('meannonan: input an array of dim 2 only');
end
if ~exist('dim','var')
    dim=0;
end



if si(1)==1 || si(2)==1
    if dim==1 && si(1)==1
        mm=x;
        return;
    elseif dim==2 && si(2)==1
        mm=x;
        return;
    else
        mm=meannonan1d(x);
    end
else
    if dim==1 || dim==0 %avg each column
        mm=zeros(1,si(2));
        for ii=1:si(2)
            mm(ii)=meannonan1d(x(:,ii));
        end
    elseif dim==2 %avg each row
        mm=zeros(si(1),1);
        for ii=1:si(1)
            mm(ii)=meannonan1d(x(ii,:));
        end
    end     
        
end

function mm=meannonan1d(x)
notin=isnan(x) | isinf(x);
x(notin)=[];
mm=mean(x);