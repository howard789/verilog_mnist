module myram_28X28 #(


	parameter	[10:0]		ID			=   1,
	parameter	[10:0]		UP			=	108,
	parameter	[10:0]		DOWN		=	164,
	parameter	[10:0]		LEFT		=	212,
	parameter	[10:0]		RIGHT		=	269,
	parameter	[10:0]		EACH_WIDE	=   2,
	parameter           	DEBIT       =   22,
	


	parameter	[DEBIT:0]		W_0			=	10,
	parameter	[DEBIT:0]		W_1			=	10,
	parameter	[DEBIT:0]		W_2			=	10,
	parameter	[DEBIT:0]		W_3			=	10,
	parameter	[DEBIT:0]		W_4			=	10,
	parameter	[DEBIT:0]		W_5			=	10,
	parameter	[DEBIT:0]		W_6			=	10,
	parameter	[DEBIT:0]		W_7			=	10,
	parameter	[DEBIT:0]		W_8			=	10,
	parameter	[DEBIT:0]		W_9			=	10

)(
	//system signals
	input						clk,
	input			[10:0]      xpos,
	input			[10:0]      ypos,
	input			[ 7:0]      dq_i,

	output		wire					res_done,
	output		reg	signed  [DEBIT:0]		score_0,
	output		reg	signed  [DEBIT:0]		score_1,
	output		reg	signed  [DEBIT:0]		score_2,
	output		reg	signed  [DEBIT:0]		score_3,
	output		reg	signed  [DEBIT:0]		score_4,
	output		reg	signed  [DEBIT:0]		score_5,
	output		reg	signed  [DEBIT:0]		score_6,
	output		reg	signed  [DEBIT:0]		score_7,
	output		reg	signed  [DEBIT:0]		score_8,
	output		reg	signed  [DEBIT:0]		score_9

);


//这个block 的边界,不包含在这个block里




wire		    		 rst_valid;
// wire         	done_1,done_2,done_3,done_4,done_5,done_6,done_7,done_8,done_9,done_10,done_11,done_12,done_13,done_14,done_15,done_16,done_17,done_18,done_19,done_20,done_21,done_22,done_23,done_24,done_25,done_26,done_27,done_28,done_29,done_30,done_31,done_32,done_33,done_34,done_35,done_36,done_37,done_38,done_39,done_40,done_41,done_42,done_43,done_44,done_45,done_46,done_47,done_48,done_49,done_50,done_51,done_52,done_53,done_54,done_55,done_56,done_57,done_58,done_59,done_60,done_61,done_62,done_63,done_64;
// wire  [ 7:0]    dq_o_1,dq_o_2,dq_o_3,dq_o_4,dq_o_5,dq_o_6,dq_o_7,dq_o_8,dq_o_9,dq_o_10,dq_o_11,dq_o_12,dq_o_13,dq_o_14,dq_o_15,dq_o_16,dq_o_17,dq_o_18,dq_o_19,dq_o_20,dq_o_21,dq_o_22,dq_o_23,dq_o_24,dq_o_25,dq_o_26,dq_o_27,dq_o_28,dq_o_29,dq_o_30,dq_o_31,dq_o_32,dq_o_33,dq_o_34,dq_o_35,dq_o_36,dq_o_37,dq_o_38,dq_o_39,dq_o_40,dq_o_41,dq_o_42,dq_o_43,dq_o_44,dq_o_45,dq_o_46,dq_o_47,dq_o_48,dq_o_49,dq_o_50,dq_o_51,dq_o_52,dq_o_53,dq_o_54,dq_o_55,dq_o_56,dq_o_57,dq_o_58,dq_o_59,dq_o_60,dq_o_61,dq_o_62,dq_o_63,dq_o_64;


wire         		    done_1,done_2,done_3,done_4;
wire  signed [ 7:0]     dq_o_1,dq_o_2,dq_o_3,dq_o_4;

reg   signed [DEBIT:0]     sum;

reg   signed [DEBIT:0]  	ave;
reg 		   			done_ave;

reg 		  		 	done_score;
reg 		  			done_res_d;
reg 		  			done_res;


reg   signed [DEBIT:0]  score_0_t;
reg   signed [DEBIT:0]  score_1_t;
reg   signed [DEBIT:0]  score_2_t;
reg   signed [DEBIT:0]  score_3_t;
reg   signed [DEBIT:0]  score_4_t;
reg   signed [DEBIT:0]  score_5_t;
reg   signed [DEBIT:0]  score_6_t;
reg   signed [DEBIT:0]  score_7_t;
reg   signed [DEBIT:0]  score_8_t;
reg   signed [DEBIT:0]  score_9_t;


//=============================================================================
//****************************     Main Code    *******************************
//=============================================================================

//以下是边界,边界不包含
localparam [10:0] BLOCK_X_LEFT = LEFT + (((ID - 1'b1) % 5'd28) * EACH_WIDE);
localparam [10:0] BLOCK_Y_UP =    UP  + (((ID - 1'b1) / 5'd28) * EACH_WIDE);
localparam [10:0] BLOCK_X_RIGHT = BLOCK_X_LEFT + EACH_WIDE + 1'b1;
localparam [10:0] BLOCK_Y_DOWN = BLOCK_Y_UP + EACH_WIDE + 1'b1;
localparam [10:0] units_per_block= EACH_WIDE * EACH_WIDE;

wire		  in_block;

assign in_block = (xpos > BLOCK_X_LEFT) &&  (xpos < BLOCK_X_RIGHT) && (ypos > BLOCK_Y_UP) &&  (ypos < BLOCK_Y_DOWN);

wire		  end_sum;
assign end_sum = (xpos == BLOCK_X_RIGHT ) && (ypos == BLOCK_Y_DOWN - 1'b1);



assign res_done = (~done_res_d) & done_res;

assign rst_valid =(xpos == BLOCK_X_LEFT) && (ypos == BLOCK_Y_UP);
//****************************   calculate the result     *******************************



always @ (posedge clk ) begin
	if(rst_valid) begin
		sum <= 1'b0;
		
	end	

	else if(in_block)  
		sum <= sum + dq_i;
	
end 	


always @ (posedge clk ) begin
	if(rst_valid) begin
		ave <= 1'b0;
		done_ave <= 1'b0;
	end	
	else if(end_sum) begin	
        ave <= sum / units_per_block;
        done_ave <= 1'b1;
    end
    else begin
    	ave <= 1'b0;
    	done_ave <= 1'b0;
    end    
end


always @ (posedge clk) begin
	if(rst_valid) begin
		score_0_t <= 1'b0;
		score_1_t <= 1'b0;
		score_2_t <= 1'b0;
		score_3_t <= 1'b0;
		score_4_t <= 1'b0;
		score_5_t <= 1'b0;
		score_6_t <= 1'b0;
		score_7_t <= 1'b0;
		score_8_t <= 1'b0;
		score_9_t <= 1'b0;
		done_score <= 1'b0;
	end	
	else if(done_ave)begin
		// $monitor ($time, ,"ave=%d W_0=%d B_0=%d",ave,W_0,B_0);
		score_0_t <= W_0 * ave ;
		score_1_t <= W_1 * ave ;
		score_2_t <= W_2 * ave ;
		score_3_t <= W_3 * ave ;
		score_4_t <= W_4 * ave ;
		score_5_t <= W_5 * ave ;
		score_6_t <= W_6 * ave ;
		score_7_t <= W_7 * ave ;
		score_8_t <= W_8 * ave ;
		score_9_t <= W_9 * ave ;
		done_score <= 1'b1;
	end
	else begin
		score_0_t <= 1'b0;
		score_1_t <= 1'b0;
		score_2_t <= 1'b0;
		score_3_t <= 1'b0;
		score_4_t <= 1'b0;
		score_5_t <= 1'b0;
		score_6_t <= 1'b0;
		score_7_t <= 1'b0;
		score_8_t <= 1'b0;
		score_9_t <= 1'b0;
		done_score <= 1'b0;
	end	
end

always @ (posedge clk) begin
	if(rst_valid) begin
		score_0 <= 1'b0;
		score_1 <= 1'b0;
		score_2 <= 1'b0;
		score_3 <= 1'b0;
		score_4 <= 1'b0;
		score_5 <= 1'b0;
		score_6 <= 1'b0;
		score_7 <= 1'b0;
		score_8 <= 1'b0;
		score_9 <= 1'b0;
		done_res <= 1'b0;
	end	
	else if(done_score) begin	// 除以 pwo(2,10)

        score_0 <= score_0_t;
        score_1 <= score_1_t;
        score_2 <= score_2_t;
        score_3 <= score_3_t;
        score_4 <= score_4_t;
        score_5 <= score_5_t;
        score_6 <= score_6_t;
        score_7 <= score_7_t;
        score_8 <= score_8_t;
        score_9 <= score_9_t;
        done_res <= 1'b1;
    end

    else begin
    	score_0 <= 1'b0;
		score_1 <= 1'b0;
		score_2 <= 1'b0;
		score_3 <= 1'b0;
		score_4 <= 1'b0;
		score_5 <= 1'b0;
		score_6 <= 1'b0;
		score_7 <= 1'b0;
		score_8 <= 1'b0;
		score_9 <= 1'b0;
		done_res <= 1'b0;
    end    
end


always @ (posedge clk) begin
	if(rst_valid) begin
		done_res_d <= 1'b0;
	end	
    else begin
    	done_res_d <= done_res;
    end    
end














    
endmodule