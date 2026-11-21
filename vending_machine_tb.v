`timescale 1ns / 1ps

module vending_machine_tb;

    reg clk;
    reg reset;

    reg product_A;
    reg product_B;

    reg coin_5;
    reg coin_10;

    wire dispense_A;
    wire dispense_B;
    wire change_5;

    // Instantiate vending machine
    vending_machine uut (
        .clk(clk),
        .reset(reset),
        .product_A(product_A),
        .product_B(product_B),
        .coin_5(coin_5),
        .coin_10(coin_10),
        .dispense_A(dispense_A),
        .dispense_B(dispense_B),
        .change_5(change_5)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        // Initial values
        clk       = 0;
        reset     = 1;
        product_A = 0;
        product_B = 0;
        coin_5    = 0;
        coin_10   = 0;

        // Reset
        #10;
        reset = 0;

        // ------------------------------------------------
        // TEST 1
        // Product A = ₹10
        // Insert ₹10
        // Expected: Product A
        // ------------------------------------------------

        #10;
        coin_10 = 1;

        #10;
        coin_10 = 0;

        #10;
        product_A = 1;

        #10;
        product_A = 0;

        // ------------------------------------------------
        // TEST 2
        // Product A = ₹10
        // Insert ₹15
        // Expected: Product A + ₹5 change
        // ------------------------------------------------

        #20;
        coin_5 = 1;

        #10;
        coin_5 = 0;

        #10;
        coin_10 = 1;

        #10;
        coin_10 = 0;

        #10;
        product_A = 1;

        #10;
        product_A = 0;

        // ------------------------------------------------
        // TEST 3
        // Product B = ₹15
        // Insert ₹15
        // Expected: Product B
        // ------------------------------------------------

        #20;
        coin_10 = 1;

        #10;
        coin_10 = 0;

        #10;
        coin_5 = 1;

        #10;
        coin_5 = 0;

        #10;
        product_B = 1;

        #10;
        product_B = 0;

        // ------------------------------------------------
        // TEST 4
        // Product B = ₹15
        // Insert ₹20
        // Expected: Product B + ₹5 change
        // ------------------------------------------------

        #20;
        coin_10 = 1;

        #10;
        coin_10 = 0;

        #10;
        coin_10 = 1;

        #10;
        coin_10 = 0;

        #10;
        product_B = 1;

        #10;
        product_B = 0;

        // End simulation
        #50;

        $finish;

    end

endmodule