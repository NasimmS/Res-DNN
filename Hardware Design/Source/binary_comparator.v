////////////////////////////////////////////////////////////////////////////////
module bin_comp(a,b,aeqb,agtb,altb);
input [3:0] a,b;
output aeqb,agtb,altb;
reg aeqb,agtb,altb;

always @(a or b)
begin
aeqb=0; agtb=0; altb=0;
if(a==b)
aeqb=1;
else if (a>b)

agtb=1;
else
altb=1;
end
endmodule


module b_comp1 (a, b, L, E,G); 
input a, b; output L, E, G;
wire s1, s2;
not X1(s1, a);
not X2 (s2, b);
and X3 (L,s1, b);
and X4 (G,s2, a);
xnor X5 (E, a, b);
endmodule

