clc
clear
close all
t=0:0.1:15;
ts=t(1:2:end);
x=sin(0.2.*pi.*t);
xsamp=x(1:2:end);
b=max(xsamp);
a=min(xsamp);
l=16;
delta=(b-a)/l;
xsignal=a:delta:b;
xquantized=a+(delta/2):delta:b-(delta/2);
encoded = zeros(1,length(xsamp));
q = zeros(1,length(xsamp));

for i=1:length(xsamp)
    for j=1:length(xquantized)
        if((xsamp(i)>=xsignal(j)) && (xsamp(i)<=xsignal(j+1)))
            q(i)=xquantized(j);
        end
    end
end
varp=var(q-xsamp);
 SQNRp=(b^2)/varp;
  for i=1:length(q)
      encoded(i)=(find(xquantized==q(i)))-1;
  end
  symbols=unique(encoded);
  for i=1:length(symbols)
      count(i)=length(find(encoded==symbols(i)));
  end
  p=count./length(encoded);
  [dict,avglen] = huffmandict(symbols,p);
  comp = huffmanenco(encoded,dict);
  dsig = huffmandeco(comp,dict);
  for i=1:length(dsig)
      decoded(i)=xquantized(dsig(i)+1);
  end
  cmprate=log2(16)/avglen;
  self_info=-log2(p);
  entropy=sum(p.*self_info);
  efficiency=entropy./avglen;
  plot(t,x)
 hold on
  plot(ts,decoded)
  xlabel('time')
  ylabel('signal')
  