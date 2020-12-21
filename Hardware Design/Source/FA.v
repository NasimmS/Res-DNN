
module FA(
    input a,
    input b,
    input cin,
    output s,
    output cout
    );
    
    
	 assign s1=a^b;
    assign s=s1^cin;
    assign c1=a&b;
    assign c2=s1&cin;
    assign cout=c1|c2;  
    
endmodule
