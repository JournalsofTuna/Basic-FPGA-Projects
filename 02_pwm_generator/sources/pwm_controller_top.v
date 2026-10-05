`timescale 1ns / 1ps

module pwm_controller_top #(
    parameter SIM_DEBOUNCE_LIMIT = 20'd1_000_000 // Donanım için 10ms (100MHz)
)(
    input  wire       clk,        // Basys 3 100MHz osilatör (W5)
    input  wire       rst,        // Reset butonu - btnC (U18)
    input  wire       btn_up,     // Parlaklık artır - btnU (T18)
    input  wire       btn_down,   // Parlaklık azalt - btnD (U17)
    output wire       pwm_out,    // PWM çıkışı - LED0 (U16)
    output wire [7:0] duty_leds   // Mevcut duty değerini gösteren LED'ler (LD7 - LD0)
);

    // -------------------------------------------------------------
    // 1. Debounce ve Kenar Yakalama Birimleri
    // -------------------------------------------------------------
    wire inc_pulse;
    wire dec_pulse;

    button_debounce_edge #(
        .DEBOUNCE_LIMIT(SIM_DEBOUNCE_LIMIT)
    ) u_deb_up (
        .clk      (clk),
        .rst      (rst),
        .btn_in   (btn_up),
        .pulse_out(inc_pulse)
    );

    button_debounce_edge #(
        .DEBOUNCE_LIMIT(SIM_DEBOUNCE_LIMIT)
    ) u_deb_down (
        .clk      (clk),
        .rst      (rst),
        .btn_in   (btn_down),
        .pulse_out(dec_pulse)
    );

    // -------------------------------------------------------------
    // 2. Duty Cycle Yönetimi (8-bit Çözünürlük: 0 - 255)
    // -------------------------------------------------------------
    reg [7:0] duty_reg;
    localparam STEP = 8'd16; // Her basışta ~%6.25 değişim

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            duty_reg <= 8'd128; // Başlangıçta %50 duty cycle
        end else begin
            if (inc_pulse) begin
                if (duty_reg <= (8'd255 - STEP))
                    duty_reg <= duty_reg + STEP;
                else
                    duty_reg <= 8'd255;
            end else if (dec_pulse) begin
                if (duty_reg >= STEP)
                    duty_reg <= duty_reg - STEP;
                else
                    duty_reg <= 8'd0;
            end
        end
    end

    assign duty_leds = duty_reg;

    // -------------------------------------------------------------
    // 3. PWM Üretim Birimi (~1 kHz Frekans)
    // 100MHz / (390 * 256) = ~1001.6 Hz
    // -------------------------------------------------------------
    reg [8:0] prescaler_cnt; // 0 - 389 sayar
    reg [7:0] pwm_cnt;       // 0 - 255 sayar

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prescaler_cnt <= 9'd0;
            pwm_cnt       <= 8'd0;
        end else begin
            if (prescaler_cnt >= 9'd389) begin
                prescaler_cnt <= 9'd0;
                pwm_cnt       <= pwm_cnt + 1'b1;
            end else begin
                prescaler_cnt <= prescaler_cnt + 1'b1;
            end
        end
    end

    assign pwm_out = (pwm_cnt < duty_reg) ? 1'b1 : 1'b0;

endmodule

// -----------------------------------------------------------------
// Alt Modül: Debounce + 2-FF Senkronizasyon + Tek Darbe Üreteci
// -----------------------------------------------------------------
module button_debounce_edge #(
    parameter DEBOUNCE_LIMIT = 20'd1_000_000
)(
    input  wire clk,
    input  wire rst,
    input  wire btn_in,
    output reg  pulse_out
);
    // CDC Senkronizasyonu (2 Flip-Flop)
    reg sync_0, sync_1;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync_0 <= 1'b0;
            sync_1 <= 1'b0;
        end else begin
            sync_0 <= btn_in;
            sync_1 <= sync_0;
        end
    end

    // Gürültü Filtresi / Kararlılık Sayıcısı
    reg [19:0] stable_cnt;
    reg        state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stable_cnt <= 20'd0;
            state      <= 1'b0;
        end else begin
            if (sync_1 != state) begin
                stable_cnt <= stable_cnt + 1'b1;
                if (stable_cnt >= DEBOUNCE_LIMIT) begin
                    state      <= sync_1;
                    stable_cnt <= 20'd0;
                end
            end else begin
                stable_cnt <= 20'd0;
            end
        end
    end

    // Kenar Dedektörü (Yükselen Kenarda 1 Clock Cycle Darbe)
    reg state_d;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_d   <= 1'b0;
            pulse_out <= 1'b0;
        end else begin
            state_d   <= state;
            pulse_out <= (state && !state_d);
        end
    end
endmodule