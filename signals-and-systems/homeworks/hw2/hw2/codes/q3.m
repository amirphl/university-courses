% set image path
imdata = double(imread('HW2G1/HW2G1/tree.png'));

% box blur w=3
w=1;
newimage=boxblur(imdata,w);
f=figure(1);
imshow(newimage);
saveas(f,'Q3_boxblur_k=3.png');

% box blur w=5
w=2;
newimage=boxblur(imdata,w);
f=figure(2);
imshow(newimage);
saveas(f,'Q3_boxblur_k=5.png');

% guassian blur w=3
w=1;
newimage=guassianblur(imdata,w);
f=figure(3);
imshow(newimage);
saveas(f,'Q3_guassian_k=3.png');

% guassian blur w=5
w=2;
newimage=guassianblur(imdata,w);
f=figure(4);
imshow(newimage);
saveas(f,'Q3_guassianblur_k=5.png');

function [newimage] = boxblur(imdata,w)
    [m,n,p]=size(imdata);
    newimage=zeros(m,n,p);    
    box_filter=(1/((2*w+1)^2)).*ones(2*w+1);
    for k = 1:p
        newimage(1:w,:,k)=imdata(1:w,:,k);
        for i = 1+w:m-w
            newimage(i,1:w,k)=imdata(i,1:w,k);
            for j = 1+w:n-w
                newimage(i,j,k)=sum(sum(box_filter.*imdata(i-w:i+w,j-w:j+w,k)));
            end
            newimage(i,n-w+1:n,k)=imdata(i,n-w+1:n,k);
        end
        newimage(m-w+1:m,:,k)=imdata(m-w+1:m,:,k);
    end
    newimage=uint8(newimage);
end

function [newimage] = guassianblur(imdata,w)
    [m,n,p]=size(imdata);
    newimage=zeros(m,n,p);
    if(w==1)
        g_filter=(1/16).*[1 2 1;2 4 2;1 2 1];
    elseif(w==2)
        g_filter=(1/273).*[1 4 7 4 1;4 16 26 16 4;7 26 41 26 7;4 16 26 16 4;1 4 7 4 1];
    end
    
    for k = 1:p
        newimage(1:w,:,k)=imdata(1:w,:,k);
        for i = 1+w:m-w
            newimage(i,1:w,k)=imdata(i,1:w,k);
            for j = 1+w:n-w
                newimage(i,j,k)=sum(sum(g_filter.*imdata(i-w:i+w,j-w:j+w,k)));
            end
            newimage(i,n-w+1:n,k)=imdata(i,n-w+1:n,k);
        end
        newimage(m-w+1:m,:,k)=imdata(m-w+1:m,:,k);
    end
    newimage=uint8(newimage);
end