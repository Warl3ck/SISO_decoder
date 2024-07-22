function [LLR, extrinsic] = SISO_dec(in, apriori, blklen)

% SISO-decoder
% MAX-LOG-MAP decoding
% The generation matrix is [1 1 0 1;1 0 1 1] according 
% to the standard
% The input is LLR
% the output is a soft output and external information

sys= int16(in(1:2:end));              % Input systematic bits
parity= int16(in(2:2:end)); 
apriori = int16(apriori);% input parity bit


%Initialisation
least_val = -128;
%branch=zeros(8,2,in_length);     % branch measure, 8 possible states, input is
% 0 or 1
alpha= (least_val*ones(8,blklen+4));  % forward metric, A(S,k)
alpha(1,1)= 0;                   % register status from all zeros
beta= (least_val*ones(8,blklen+4+1));% backward metric, B(S,k)
beta(1,blklen+4+1)= 0;         % Register status ended by all zeros
LLR = (zeros(blklen+4, 1));

% Setting metrics as int16 vars
alpha = int16(alpha);
beta = int16(beta);
LLR = int16(LLR);

%Calculating branch metric, forward metric and LLR
% Precalculating branch values

init_branch1 =   int16(-(apriori+sys+parity)/2);
init_branch2 =   int16(-(apriori+sys-parity)/2);


writematrix(init_branch1,'init_branch1.txt');
writematrix(init_branch2,'init_branch2.txt');


for k=2:blklen+4
  
    alpha(1,k)=max((alpha(1,k-1)+init_branch1(k-1)),(alpha(2,k-1)-init_branch1(k-1))) ;
    alpha(2,k)=max((alpha(3,k-1)-init_branch2(k-1)),(alpha(4,k-1)+init_branch2(k-1))) ;
    alpha(3,k)=max((alpha(5,k-1)+init_branch2(k-1)),(alpha(6,k-1)-init_branch2(k-1))) ;
    alpha(4,k)=max((alpha(7,k-1)-init_branch1(k-1)),(alpha(8,k-1)+init_branch1(k-1))) ;
    alpha(5,k)=max((alpha(1,k-1)-init_branch1(k-1)),(alpha(2,k-1)+init_branch1(k-1))) ;
    alpha(6,k)=max((alpha(3,k-1)+init_branch2(k-1)),(alpha(4,k-1)-init_branch2(k-1))) ;
    alpha(7,k)=max((alpha(5,k-1)-init_branch2(k-1)),(alpha(6,k-1)+init_branch2(k-1))) ;
    alpha(8,k)=max((alpha(7,k-1)+init_branch1(k-1)),(alpha(8,k-1)-init_branch1(k-1))) ; 
    
    alpha(:,k) = alpha(:,k) - alpha(1, k);

end

%Calculating backward metric
for k=blklen+4:-1:1
        beta(1,k)=max((beta(1,k+1)+init_branch1(k)),(beta(5,k+1)-init_branch1(k))) ;
        beta(2,k)=max((beta(5,k+1)+init_branch1(k)),(beta(1,k+1)-init_branch1(k))) ;
        beta(3,k)=max((beta(6,k+1)+init_branch2(k)),(beta(2,k+1)-init_branch2(k))) ;
        beta(4,k)=max((beta(2,k+1)+init_branch2(k)),(beta(6,k+1)-init_branch2(k))) ;
        beta(5,k)=max((beta(3,k+1)+init_branch2(k)),(beta(7,k+1)-init_branch2(k))) ;
        beta(6,k)=max((beta(7,k+1)+init_branch2(k)),(beta(3,k+1)-init_branch2(k))) ;
        beta(7,k)=max((beta(8,k+1)+init_branch1(k)),(beta(4,k+1)-init_branch1(k))) ;
        beta(8,k)=max((beta(4,k+1)+init_branch1(k)),(beta(8,k+1)-init_branch1(k))) ;
        
        beta(:,k) = beta(:,k) - beta(1,k);

        % Calculation of LLR
        LLR(k)=max(...
        max(...
            max((alpha(1,k)-init_branch1(k)+beta(5,k+1)),(alpha(2,k)-init_branch1(k)+beta(1,k+1))),...
            max((alpha(3,k)-init_branch2(k)+beta(2,k+1)),(alpha(4,k)-init_branch2(k)+beta(6,k+1)))),...
            max(...
            max((alpha(5,k)-init_branch2(k)+beta(7,k+1)),(alpha(6,k)-init_branch2(k)+beta(3,k+1))),...
            max((alpha(7,k)-init_branch1(k)+beta(4,k+1)),(alpha(8,k)-init_branch1(k)+beta(8,k+1))))...
            )...
         - max(...
            max(...
            max((alpha(1,k)+init_branch1(k)+beta(1,k+1)),(alpha(2,k)+init_branch1(k)+beta(5,k+1))),...
            max((alpha(3,k)+init_branch2(k)+beta(6,k+1)),(alpha(4,k)+init_branch2(k)+beta(2,k+1)))),...
            max(...
            max((alpha(5,k)+init_branch2(k)+beta(3,k+1)),(alpha(6,k)+init_branch2(k)+beta(7,k+1))),...
            max((alpha(7,k)+init_branch1(k)+beta(8,k+1)),(alpha(8,k)+init_branch1(k)+beta(4,k+1))))...
            );
			
			
		qq1(k) = alpha(1,k)-init_branch1(k)+beta(5,k+1);
		qq2(k) = alpha(2,k)-init_branch1(k)+beta(1,k+1);
		qq3(k) = alpha(3,k)-init_branch2(k)+beta(2,k+1);
		qq4(k) = alpha(4,k)-init_branch2(k)+beta(6,k+1);
		qq5(k) = alpha(5,k)-init_branch2(k)+beta(7,k+1);
		qq6(k) = alpha(6,k)-init_branch2(k)+beta(3,k+1);
		qq7(k) = alpha(7,k)-init_branch1(k)+beta(4,k+1);
		qq8(k) = alpha(8,k)-init_branch1(k)+beta(8,k+1);
		
		qo1(k) = alpha(1,k)+init_branch1(k)+beta(1,k+1);
		qo2(k) = alpha(2,k)+init_branch1(k)+beta(5,k+1);
		qo3(k) = alpha(3,k)+init_branch2(k)+beta(6,k+1);
		qo4(k) = alpha(4,k)+init_branch2(k)+beta(2,k+1);
		qo5(k) = alpha(5,k)+init_branch2(k)+beta(3,k+1);
		qo6(k) = alpha(6,k)+init_branch2(k)+beta(7,k+1);
		qo7(k) = alpha(7,k)+init_branch1(k)+beta(8,k+1);
		qo8(k) = alpha(8,k)+init_branch1(k)+beta(4,k+1);
		
		
	for i = 1:516
		qq1_inv(i) = qq1(517-i);
		qq2_inv(i) = qq2(517-i);
		qq3_inv(i) = qq3(517-i);
		qq4_inv(i) = qq4(517-i);
		qq5_inv(i) = qq5(517-i);
		qq6_inv(i) = qq6(517-i);
		qq7_inv(i) = qq7(517-i);
		qq8_inv(i) = qq8(517-i);
	
		qo1_inv(i) = qo1(517-i);
		qo2_inv(i) = qo2(517-i);
		qo3_inv(i) = qo3(517-i);
		qo4_inv(i) = qo4(517-i);
		qo5_inv(i) = qo5(517-i);
		qo6_inv(i) = qo6(517-i);
		qo7_inv(i) = qo7(517-i);
		qo8_inv(i) = qo8(517-i);
	
	end
		
		
	   
	   writematrix(qq1_inv.','llrm_1_0.txt');
	   writematrix(qq2_inv.','llrm_1_1.txt');
	   writematrix(qq3_inv.','llrm_1_2.txt');
	   writematrix(qq4_inv.','llrm_1_3.txt');
	   writematrix(qq5_inv.','llrm_1_4.txt');
	   writematrix(qq6_inv.','llrm_1_5.txt');
	   writematrix(qq7_inv.','llrm_1_6.txt');
	   writematrix(qq8_inv.','llrm_1_7.txt');
	
	   	   
	   writematrix(qo1_inv.','llrm_2_0.txt');
	   writematrix(qo2_inv.','llrm_2_1.txt');
	   writematrix(qo3_inv.','llrm_2_2.txt');
	   writematrix(qo4_inv.','llrm_2_3.txt');
	   writematrix(qo5_inv.','llrm_2_4.txt');
	   writematrix(qo6_inv.','llrm_2_5.txt');
	   writematrix(qo7_inv.','llrm_2_6.txt');
	   writematrix(qo8_inv.','llrm_2_7.txt');
	   
		

        q1(k) = max((alpha(1,k)-init_branch1(k)+beta(5,k+1)),(alpha(2,k)-init_branch1(k)+beta(1,k+1)));
        q2(k) = max((alpha(3,k)-init_branch2(k)+beta(2,k+1)),(alpha(4,k)-init_branch2(k)+beta(6,k+1)));
        q3(k) = max((alpha(5,k)-init_branch2(k)+beta(7,k+1)),(alpha(6,k)-init_branch2(k)+beta(3,k+1)));
        q4(k) = max((alpha(7,k)-init_branch1(k)+beta(4,k+1)),(alpha(8,k)-init_branch1(k)+beta(8,k+1)));

        q5(k) = max((alpha(1,k)+init_branch1(k)+beta(1,k+1)),(alpha(2,k)+init_branch1(k)+beta(5,k+1)));
        q6(k) = max((alpha(3,k)+init_branch2(k)+beta(6,k+1)),(alpha(4,k)+init_branch2(k)+beta(2,k+1)));
        q7(k) = max((alpha(5,k)+init_branch2(k)+beta(3,k+1)),(alpha(6,k)+init_branch2(k)+beta(7,k+1)));
        q8(k) = max((alpha(7,k)+init_branch1(k)+beta(8,k+1)),(alpha(8,k)+init_branch1(k)+beta(4,k+1)));

        o51(k) = alpha(1,k)-init_branch1(k)+beta(5,k+1);
        o52(k) = alpha(2,k)-init_branch1(k)+beta(1,k+1);
       
	for i = 1:516
		q1_inv(i) = q1(517-i);
		q2_inv(i) = q2(517-i);
		q3_inv(i) = q3(517-i);
		q4_inv(i) = q4(517-i);
		q5_inv(i) = q5(517-i);
		q6_inv(i) = q6(517-i);
		q7_inv(i) = q7(517-i);
		q8_inv(i) = q8(517-i);
	end
		
		
	   
	  % writematrix(q1_inv.','llrm_1_0.txt');
	  % writematrix(q2_inv.','llrm_1_1.txt');
	  % writematrix(q3_inv.','llrm_1_2.txt');
	  % writematrix(q4_inv.','llrm_1_3.txt');
	  % writematrix(q5_inv.','llrm_1_4.txt');
	  % writematrix(q6_inv.','llrm_1_5.txt');
	  % writematrix(q7_inv.','llrm_1_6.txt');
	  % writematrix(q8_inv.','llrm_1_7.txt');

        r1 = max(q1,q2);
        r2 = max(q3,q4);
        r3 = max(q5,q6);
        r4 = max(q7,q8);

        llr_1_max_1 =  max(r1, r2);
        llr_2_max_1 =  max(r3, r4);
        a = llr_1_max_1 - llr_2_max_1;

end
        
        b = LLR-apriori-sys;
        extrinsic=  0.75*(LLR-apriori-sys);
        LLR = LLR(1:blklen);


end
