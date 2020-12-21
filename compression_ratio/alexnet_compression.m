net=alexnet;
inputSize = net.Layers(1).InputSize;
unzip('MerchData.zip');
imds = imageDatastore('MerchData',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');

[imdsTrain,imdsTest] = splitEachLabel(imds,0.7,'randomized');
augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsTest);

l=length(net.Layers);
lay=string(zeros(l,1));
p=zeros(l,1);
j=0;
for ll=1:l
    lay(ll)=net.Layers(ll).Name;
   if contains(net.Layers(ll).Name,'pool') || contains(net.Layers(ll).Name,'relu')
       j=j+1;
       layer=net.Layers(ll).Name;
       f = activations(net,augimdsTest,layer);
       t1=f(:,:,:,1);
       r2=reshape(t1,[],1);
       t1=round(t1/(max(r2))*2^15);
       z=length(find(t1==0));
       t=length(r2);
       p(ll)=1-((z+(t-z)*17)/(t*16));      
       %figure;
       %yticks('auto')
       %h=histogram(o,'binwidth',500,'FaceColor','r');
       %saveas(h,net.Layers(ll).Name+"mult",'png');
       %grid on
   
   else
      p(ll)=0; 
   end
       
end
mid=sum(p)/j;
p_compression_alexnet.name=lay;
p_compression_alexnet.value=p;
writetable(struct2table(p_compression_alexnet), 'p_compression_alexnet.xlsx')
