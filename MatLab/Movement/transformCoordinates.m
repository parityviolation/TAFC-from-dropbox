function [xVectorTrans,yVectorTrans,alpha,r] = transformCoordinates(xVector,yVector,theta)
%build a funtion f such that [x' y'] = f(vectorX,vectorY, alpha, theta, r);
%how does it calculate it? x' = r.sin(alpha+theta)  and
%y'=r.cos(alpha+theta)

r = zeros(size(xVector,1),size(xVector,2));
alpha = r;
xVectorTrans = r;
yVectorTrans = r;


for i = 1:size(xVector,1)
for h = 1:size(xVector,2)
   
   r(i,h) = sqrt((xVector(i,h)^2) + (yVector(i,h)^2));  
   alpha(i,h) = atand(xVector(i,h)/yVector(i,h));
   xVectorTrans(i,h) = r(i,h)*sind(alpha(i,h)+theta);  
   yVectorTrans(i,h) = r(i,h)*cosd(alpha(i,h)+theta);
    
end
end
end
