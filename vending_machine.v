module vending_machine (
    input  wire clk,
    input  wire reset,

    input  wire product_A,
    input  wire product_B,

    input  wire coin_5,
    input  wire coin_10,

    output reg dispense_A,
    output reg dispense_B,
    output reg change_5,
    output reg change_10
);

    // =========================================================
    // FSM STATES
    // =========================================================

    localparam IDLE        = 3'd0;
    localparam MONEY_5     = 3'd1;
    localparam MONEY_10    = 3'd2;
    localparam MONEY_15    = 3'd3;
    localparam MONEY_20    = 3'd4;
    localparam DISPENSE_A  = 3'd5;
    localparam DISPENSE_B  = 3'd6;
    localparam CHANGE      = 3'd7;

    reg [2:0] state;

    // =========================================================
    // COIN EDGE DETECTION
    // =========================================================

    reg coin5_prev;
    reg coin10_prev;

    wire coin5_pulse;
    wire coin10_pulse;

    assign coin5_pulse  = coin_5  & ~coin5_prev;
    assign coin10_pulse = coin_10 & ~coin10_prev;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            coin5_prev  <= 1'b0;
            coin10_prev <= 1'b0;
        end
        else begin
            coin5_prev  <= coin_5;
            coin10_prev <= coin_10;
        end
    end

    // =========================================================
    // CHANGE MEMORY
    // 00 = no change
    // 01 = ₹5
    // 10 = ₹10
    // =========================================================

    reg [1:0] change_amount;

    // =========================================================
    // VISIBLE OUTPUT TIMER
    // 100 MHz clock
    // 100,000,000 cycles = approximately 1 second
    // =========================================================

    reg [26:0] display_counter;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            display_counter <= 27'd0;
        end

        else begin

            if ((state == DISPENSE_A) ||
                (state == DISPENSE_B) ||
                (state == CHANGE)) begin

                if (display_counter < 27'd100_000_000)
                    display_counter <= display_counter + 1'b1;
                else
                    display_counter <= display_counter;

            end

            else begin
                display_counter <= 27'd0;
            end

        end

    end

    // =========================================================
    // FSM
    // =========================================================

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            state         <= IDLE;
            change_amount <= 2'b00;

        end

        else begin

            case (state)

                // -------------------------------------------------
                // IDLE
                // -------------------------------------------------

                IDLE: begin

                    change_amount <= 2'b00;

                    if (coin5_pulse)
                        state <= MONEY_5;

                    else if (coin10_pulse)
                        state <= MONEY_10;

                end

                // -------------------------------------------------
                // ₹5
                // -------------------------------------------------

                MONEY_5: begin

                    if (coin5_pulse)
                        state <= MONEY_10;

                    else if (coin10_pulse)
                        state <= MONEY_15;

                    // Product A costs ₹10,
                    // but only ₹5 is inserted,
                    // so wait for more money.

                end

                // -------------------------------------------------
                // ₹10
                // -------------------------------------------------

                MONEY_10: begin

                    if (product_A) begin
                        state <= DISPENSE_A;
                        change_amount <= 2'b00;
                    end

                    else if (coin5_pulse)
                        state <= MONEY_15;

                    else if (coin10_pulse)
                        state <= MONEY_20;

                end

                // -------------------------------------------------
                // ₹15
                // -------------------------------------------------

                MONEY_15: begin

                    if (product_B) begin
                        // Product B = ₹15
                        state <= DISPENSE_B;
                        change_amount <= 2'b00;
                    end

                    else if (product_A) begin
                        // Product A = ₹10
                        // ₹15 - ₹10 = ₹5
                        state <= CHANGE;
                        change_amount <= 2'b01;
                    end

                    else if (coin5_pulse)
                        state <= MONEY_20;

                end

                // -------------------------------------------------
                // ₹20
                // -------------------------------------------------

                MONEY_20: begin

                    if (product_A) begin
                        // ₹20 - ₹10 = ₹10
                        state <= CHANGE;
                        change_amount <= 2'b10;
                    end

                    else if (product_B) begin
                        // ₹20 - ₹15 = ₹5
                        state <= CHANGE;
                        change_amount <= 2'b01;
                    end

                end

                // -------------------------------------------------
                // PRODUCT A
                // -------------------------------------------------

                DISPENSE_A: begin

                    if (display_counter >= 27'd99_999_999)
                        state <= IDLE;

                end

                // -------------------------------------------------
                // PRODUCT B
                // -------------------------------------------------

                DISPENSE_B: begin

                    if (display_counter >= 27'd99_999_999)
                        state <= IDLE;

                end

                // -------------------------------------------------
                // CHANGE
                // -------------------------------------------------

                CHANGE: begin

                    if (display_counter >= 27'd99_999_999)
                        state <= IDLE;

                end

                default:
                    state <= IDLE;

            endcase

        end

    end

    // =========================================================
    // OUTPUT DECODER
    // =========================================================

    always @(*) begin

        dispense_A = 1'b0;
        dispense_B = 1'b0;
        change_5   = 1'b0;
        change_10  = 1'b0;

        case (state)

            DISPENSE_A:
                dispense_A = 1'b1;

            DISPENSE_B:
                dispense_B = 1'b1;

            CHANGE: begin

                if (change_amount == 2'b01)
                    change_5 = 1'b1;

                else if (change_amount == 2'b10)
                    change_10 = 1'b1;

            end

            default: begin
                dispense_A = 1'b0;
                dispense_B = 1'b0;
                change_5   = 1'b0;
                change_10  = 1'b0;
            end

        endcase

    end

endmodule